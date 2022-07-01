//
//  MostPopularArticlesViewController.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import UIKit
import Combine
import SafariServices

class MostPopularArticlesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkUnavailableView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var btnTryAgain: UIButton!

    private let search = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let mostPopularviewModel: MostPopularArticlesViewModel = MostPopularArticlesViewModel(_apiService: MostPopularArticlesService(), _settingManager: SettingManager(_languageManager: LanguageManager(), _ThemeManager: ThemeManager()))
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localizations()
        self.configurationNavigationBar()
        self.tableViewConfiguration()
        self.searchConfigureController()
        self.bindViewModel()
        
    }
    
    private func configurationNavigationBar(){
        self.networkUnavailableView.isHidden = true
        self.navigationBarButtonConfigurationAndHandler()
    }
    
    private func localizations(){
        self.title = "navbarArticlekey".localizableString(local: self.mostPopularviewModel.getAppLanguage())
        self.search.searchBar.placeholder = "searchkey".localizableString(local: self.mostPopularviewModel.getAppLanguage())
        self.refreshControl.attributedTitle = NSAttributedString(string: "pullToRefreshkey".localizableString(local: self.mostPopularviewModel.getAppLanguage()))

    }
    
    private func navigationBarButtonConfigurationAndHandler() {
       
        let handler: (_ action: UIAction) -> () = { action in
            
            switch action.identifier.rawValue {
            case settingsNameEnum.darkMode.rawValue:
                self.mostPopularviewModel.setTheme(isDark: true)
                self.navigationBarButtonConfigurationAndHandler()
                
            case settingsNameEnum.lightMode.rawValue:
                self.mostPopularviewModel.setTheme(isDark: false)
                self.navigationBarButtonConfigurationAndHandler()

            case settingsNameEnum.english.rawValue:
                self.mostPopularviewModel.setAppLanguage(langCode: .english)
                self.localizations()
                self.navigationBarButtonConfigurationAndHandler()

            case settingsNameEnum.arabic.rawValue:
                self.mostPopularviewModel.setAppLanguage(langCode: .arabic)
                self.localizations()
                self.navigationBarButtonConfigurationAndHandler()

            default:
                break
            }
        }
        
        let actions = [
            UIAction(title: self.mostPopularviewModel.getThemeIsDark() ? "lightModeKey".localizableString(local: self.mostPopularviewModel.getAppLanguage()) : "darkModeKey".localizableString(local: self.mostPopularviewModel.getAppLanguage()),
                     identifier: UIAction.Identifier(self.mostPopularviewModel.getThemeIsDark() ? settingsNameEnum.lightMode.rawValue : settingsNameEnum.darkMode.rawValue), handler: handler),
            UIAction(title: self.mostPopularviewModel.getAppLanguage() == LanguageEnum.english.rawValue ? "arabicKey".localizableString(local: self.mostPopularviewModel.getAppLanguage()) : "EnglishKey".localizableString(local: self.mostPopularviewModel.getAppLanguage()) , identifier: UIAction.Identifier(self.mostPopularviewModel.getAppLanguage() == LanguageEnum.english.rawValue ? settingsNameEnum.arabic.rawValue : settingsNameEnum.english.rawValue), handler: handler)

        ]
        
        let menu = UIMenu(title: "",  children: actions)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "", image: UIImage(named: imageNameEnum.iconDots.rawValue), menu: menu), UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.actionSearch))]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imageNameEnum.iconMenu.rawValue), style: .plain, target: self, action: #selector(self.actionMenu))
    }
    
    //MARK: - tableViewConfiguration
    private func tableViewConfiguration(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: MostPopularArticleTableViewCell.cell, bundle: Bundle.main), forCellReuseIdentifier: MostPopularArticleTableViewCell.cell)
        
        self.refreshControl.addTarget(self, action: #selector(self.actionTryAgain(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func searchConfigureController(){
        self.search.searchResultsUpdater = self
        self.search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = search
    }
    
    //MARK: - bindViewModel
    private func getArticleListing() {
        Task{
            try! await mostPopularviewModel.getArticles(with: .mostviewedCategory, section: .allSection, and: .onePeriod)
        }
    }
    
    private func bindViewModel() {
        self.articlesViewModelSubscriber()
        self.errorMessageSubscriber()
        self.view.showActivityIndicator(nil)
        self.getArticleListing()
    }
    
    private func articlesViewModelSubscriber() {
        self.mostPopularviewModel.$mostViewedArticles
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  in
                guard let self = self else { return }
                if $0.count>0{
                    self.view.dismissActivityIndicator()
                    self.refreshControl.endRefreshing()
                    self.reloadTableView()
                }
            }
            .store(in: &cancellables)
    }
    
    private func errorMessageSubscriber(){
        self.mostPopularviewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errr in
                guard let self = self else { return }
                self.callAlert(error: errr)
            }
            .store(in: &cancellables)
    }
    
    @objc
    @IBAction func actionTryAgain(_ sender: Any){
        self.view.showActivityIndicator(nil)
        self.setUpNetworkErrorView(isShow:false)
        self.getArticleListing()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func actionMenu(){
        print("menu tapped")
    }
    
    @objc func actionSearch(){
        self.navigationController?.present(search, animated: true)
    }
        
    private func setUpNetworkErrorView(isShow: Bool){
        self.networkUnavailableView.isHidden = !isShow
        self.btnTryAgain.setTitle("tryAgainKey".localizableString(local: self.mostPopularviewModel.getAppLanguage()), for: .normal)
        self.networkErrorLabel.text = "internetConnectKey".localizableString(local: self.mostPopularviewModel.getAppLanguage())
        self.refreshControl.endRefreshing()
    }
    
    func callAlert(error: APIError){
        switch error {
        case .none:
            break
        case .requestFailed(description: let description):
            self.view.dismissActivityIndicator()
            self.showAlert(with: nil, and: description)
            break
        case .jsonConversionFailure(description: let description):
            self.view.dismissActivityIndicator()
            self.showAlert(with: nil, and: description)
            break
        case .invalidData:
            self.view.dismissActivityIndicator()
            self.showAlert(with: nil, and: description)
            break
        case .responseUnsuccessful(description: let description):
            self.view.dismissActivityIndicator()
            self.showAlert(with: nil, and: description)
            break
        case .jsonParsingFailure:
            self.view.dismissActivityIndicator()
            self.showAlert(with: nil, and: "internetConnectKey".localizableString(local: self.mostPopularviewModel.getAppLanguage()))
            break
        case .noInternet:
            self.view.dismissActivityIndicator()
            self.setUpNetworkErrorView(isShow: true)
            break
        case .failedSerialization:
            self.showAlert(with: nil, and: "internetConnectKey".localizableString(local: self.mostPopularviewModel.getAppLanguage()))
            break
        }
    }
    
}

//MARK: - TableView delegate and datasource
extension MostPopularArticlesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.mostPopularviewModel.mostViewedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MostPopularArticleTableViewCell.cell, for: indexPath) as? MostPopularArticleTableViewCell{
            let article = self.mostPopularviewModel.getArticle(at: indexPath.row)
            cell.cellModel = article
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showDetails(self.mostPopularviewModel.getArticle(at: indexPath.row).detailUrlString)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
    
}

//MARK: - Show Article Details
extension MostPopularArticlesViewController{
    /// Show Article Details
    /// - Parameter itemUrl: pass the article url
    func showDetails(_ itemUrl: String) {
        if let url = URL(string: itemUrl) {
            let config = SFSafariViewController.Configuration()
            let vc = SFSafariViewController(url: url, configuration: config)
            self.present(vc, animated: true)
        }
    }
}

//MARK: - UISearchResultsUpdating
extension MostPopularArticlesViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.mostPopularviewModel.searchArticles(with: text)
    }
}
