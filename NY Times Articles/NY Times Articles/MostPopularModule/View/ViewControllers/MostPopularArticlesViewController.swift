//
//  MostPopularArticlesViewController.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import UIKit

class MostPopularArticlesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let search = UISearchController(searchResultsController: nil)

    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
        self.tableViewConfiguration()
        self.searchConfigureController()
    }
    
    private func configuration(){
        self.title = "Articles"
        self.navigationBarButtonConfigurationAndHandler()
    }
    
    private func navigationBarButtonConfigurationAndHandler() {
        let handler: (_ action: UIAction) -> () = { action in

            switch action.identifier.rawValue {
            case themeNameEnum.darkMode.rawValue:
                self.navigationBarButtonConfigurationAndHandler()
                
            case themeNameEnum.lightMode.rawValue:
                self.navigationBarButtonConfigurationAndHandler()

            default:
                break
            }
        }
        
        let actions = [
            UIAction(title: themeNameEnum.darkMode.rawValue, identifier: UIAction.Identifier(themeNameEnum.darkMode.rawValue), handler: handler)
        ]
        
        let menu = UIMenu(title: "",  children: actions)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "", image: UIImage(named: imageNameEnum.iconDots.rawValue), menu: menu), UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.actionSearch))]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imageNameEnum.iconMenu.rawValue), style: .plain, target: self, action: #selector(self.actionMenu))
    }
    
    @objc func actionMenu(){
        print("menu tapped")
    }
    
    @objc func actionSearch(){
        self.navigationController?.present(search, animated: true)
    }
    
    //MARK: - tableViewConfiguration
    private func tableViewConfiguration(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: MostPopularArticleTableViewCell.cell, bundle: Bundle.main), forCellReuseIdentifier: MostPopularArticleTableViewCell.cell)
        
        self.refreshControl.attributedTitle = NSAttributedString(string: Constants.pullToRefresh)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
    }

    private func searchConfigureController(){
        self.search.searchResultsUpdater = self
        self.search.obscuresBackgroundDuringPresentation = false
        self.search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
    }
    
    @objc func refresh(_ sender: AnyObject) {
    }

}

//MARK: - TableView delegate and datasource
extension MostPopularArticlesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MostPopularArticleTableViewCell.cell, for: indexPath) as? MostPopularArticleTableViewCell{
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
    
}

//MARK: - UISearchResultsUpdating
extension MostPopularArticlesViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}
