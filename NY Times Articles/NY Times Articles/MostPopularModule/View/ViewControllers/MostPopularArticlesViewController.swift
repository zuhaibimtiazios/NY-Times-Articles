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
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var networkUnavailableView: UIView!
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var btnTryAgain: UIButton!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let mostPopularviewModel: MostPopularArticlesViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(_mostPopularArticlesViewModel: MostPopularArticlesViewModel) {
        self.mostPopularviewModel = _mostPopularArticlesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.mostPopularviewModel = MostPopularArticlesViewModel(_apiService: MostPopularArticlesService(), _settingManager: SettingManager(_languageManager: LanguageManager(), _ThemeManager: ThemeManager()))
        super.init(coder: coder)

    }
    
    //MARK: - ViewDidLoad Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.localizations()
        self.configurationNavigationBar()
        self.searchTextFieldConfiguration()
        self.tableViewConfiguration()
        self.bindViewModel()
    }
    
    //MARK: - UI localizations methods
    private func localizations(){
        self.title = MostPopularLocalizationKeysEnum.mostPopularArticlesTitleKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage())
        self.searchTextField.placeholder = MostPopularLocalizationKeysEnum.searchTextFieldPlaceholderkey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage())
        self.refreshControl.attributedTitle = NSAttributedString(string: MostPopularLocalizationKeysEnum.pullToRefreshKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()))
    }
 
    //MARK: - configurations methods
    private func configurationNavigationBar(){
        self.networkUnavailableView.isHidden = true
        self.navigationBarButtonConfigurationAndHandler()
    }
    
    private func navigationBarButtonConfigurationAndHandler() {
        self.navigationController?.navigationBar.backgroundColor = self.mostPopularviewModel.getThemeIsDark() ? nil : ColorConstants.customGreenNavbarColor
        self.view.backgroundColor = self.mostPopularviewModel.getThemeIsDark() ? .systemBackground : ColorConstants.customGreenNavbarColor
        self.searchView.backgroundColor = self.mostPopularviewModel.getThemeIsDark() ? .systemBackground : ColorConstants.customGreenNavbarColor
        self.navigationController?.navigationBar.tintColor = self.mostPopularviewModel.getThemeIsDark() ? .white : .black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: self.mostPopularviewModel.getThemeIsDark() ? UIColor.white : UIColor.black]

        let handler: (_ action: UIAction) -> () = { action in
            
            switch action.identifier.rawValue {
            case SettingsNameEnum.darkMode.rawValue:
                self.mostPopularviewModel.setTheme(isDark: true)
                self.navigationBarButtonConfigurationAndHandler()
                
            case SettingsNameEnum.lightMode.rawValue:
                self.mostPopularviewModel.setTheme(isDark: false)
                self.navigationBarButtonConfigurationAndHandler()
                
            case SettingsNameEnum.english.rawValue:
                self.mostPopularviewModel.setAppLanguage(langCode: .english)
                self.localizations()
                self.navigationBarButtonConfigurationAndHandler()
                
            case SettingsNameEnum.arabic.rawValue:
                self.mostPopularviewModel.setAppLanguage(langCode: .arabic)
                self.localizations()
                self.navigationBarButtonConfigurationAndHandler()
                
            default:
                break
            }
        }
        
        let actions = [
            UIAction(title: self.mostPopularviewModel.getThemeIsDark() ? MostPopularLocalizationKeysEnum.lightModeKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()) : MostPopularLocalizationKeysEnum.darkModeKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()),
                     identifier: UIAction.Identifier(self.mostPopularviewModel.getThemeIsDark() ? SettingsNameEnum.lightMode.rawValue : SettingsNameEnum.darkMode.rawValue), handler: handler),
            UIAction(title: self.mostPopularviewModel.getAppLanguage() == LanguageEnum.english.rawValue ? MostPopularLocalizationKeysEnum.arabicKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()) : MostPopularLocalizationKeysEnum.EnglishKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()) , identifier: UIAction.Identifier(self.mostPopularviewModel.getAppLanguage() == LanguageEnum.english.rawValue ? SettingsNameEnum.arabic.rawValue : SettingsNameEnum.english.rawValue), handler: handler)
            
        ]
        
        let menu = UIMenu(title: "",  children: actions)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "", image: UIImage(named: ImagesNameEnum.iconDots.rawValue), menu: menu), UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.actionSearch))]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: ImagesNameEnum.iconMenu.rawValue), style: .plain, target: self, action: #selector(self.actionMenu))
    }
    
    private func searchTextFieldConfiguration(){
        self.searchViewHeightConstraint.constant = 0
        self.searchTextField.delegate = self
        self.searchTextField.returnKeyType = .done
        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func tableViewConfiguration(){

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: MostPopularArticleTableViewCell.cell, bundle: Bundle.main), forCellReuseIdentifier: MostPopularArticleTableViewCell.cell)
        
        self.refreshControl.addTarget(self, action: #selector(self.actionTryAgain(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }

    //MARK: - Get Article Listing
    private func getArticleListing() {
        Task{
            try! await mostPopularviewModel.getArticles(with: .mostviewedCategory, section: .allSection, and: .onePeriod)
        }
    }
    
    //MARK: - bindViewModel
    private func bindViewModel() {
        self.articlesViewModelSubscriber()
        self.errorMessageSubscriber()
        self.view.showActivityIndicator(nil)
        self.getArticleListing()
    }
    
    //MARK: - View Model Subscribers
    private func articlesViewModelSubscriber() {
        self.mostPopularviewModel.$mostViewedArticles
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  in
                guard let self = self else { return }
                if $0.count>0{
                    self.view.dismissActivityIndicator()
                    self.refreshControl.endRefreshing()
                }
                self.reloadTableView()
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
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func actionMenu(){
        print("menu tapped")
    }
    
    @objc func actionSearch(){
        if self.searchViewHeightConstraint.constant == 0 {
            self.searchViewHeightConstraint.constant = 50
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else{
            self.searchViewHeightConstraint.constant = 0
            self.searchTextField.text = ""
            self.searchTextField.resignFirstResponder()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            self.tableView.reloadData()
        }
    }
    
    private func setUpNetworkErrorView(isShow: Bool){
        self.networkUnavailableView.isHidden = !isShow
        self.btnTryAgain.setTitle(MostPopularLocalizationKeysEnum.tryAgainButtonKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()), for: .normal)
        self.networkErrorLabel.text = MostPopularLocalizationKeysEnum.internetConnectivityLabelKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage())
        self.refreshControl.endRefreshing()
    }
    
    /// Display the alert
    /// - Parameter error: pass APIError
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
            self.showAlert(with: nil, and: ApiErrorLocalizationKeyEnum.invalidDataApiErrorKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()))
            break
        case .responseUnsuccessful(description: let description):
            self.view.dismissActivityIndicator()
            self.showAlert(with: nil, and: description.localizableString(local: self.mostPopularviewModel.getAppLanguage()))
            break
        case .jsonParsingFailure:
            self.view.dismissActivityIndicator()
            self.showAlert(with: nil, and: ApiErrorLocalizationKeyEnum.noInternetApiErrorKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()))
            break
        case .noInternet:
            self.view.dismissActivityIndicator()
            self.setUpNetworkErrorView(isShow: true)
            break
        case .failedSerialization:
            self.showAlert(with: nil, and: ApiErrorLocalizationKeyEnum.noInternetApiErrorKey.rawValue.localizableString(local: self.mostPopularviewModel.getAppLanguage()))
            break
        }
    }
    
    //MARK: - IBAction
    @objc
    @IBAction func actionTryAgain(_ sender: Any){
        self.view.showActivityIndicator(nil)
        self.setUpNetworkErrorView(isShow:false)
        self.getArticleListing()
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

//MARK: - Search TextField Delegate
extension MostPopularArticlesViewController: UITextFieldDelegate{
    
    @objc func textFieldDidChange(_ textField:UITextField){
        guard let searchText = textField.text else { return }
        self.mostPopularviewModel.searchArticles(with: searchText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
}


