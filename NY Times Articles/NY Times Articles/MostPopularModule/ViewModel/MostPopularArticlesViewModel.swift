//
//  MostPopularArticlesViewModel.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation

final class MostPopularArticlesViewModel: ObservableObject {
    
    @Published private(set) var mostViewedArticles: [MostPopularArticleModel] = []
    @Published private(set) var errorMessage: APIError = .none
    private var mostViewedArticlesMain: [MostPopularArticleModel] = []
    
    var apiService: MostPopularArticlesServiceProtocol
    var settingManager: SettingProtocol
    
    init(_apiService: MostPopularArticlesServiceProtocol, _settingManager: SettingProtocol) {
        apiService = _apiService
        settingManager = _settingManager
    }
    
    //MARK: - Search Article for cell
    func getArticle(at index: Int) -> MostViewedCellViewModel {
        let item = mostViewedArticles[index]
        return MostViewedCellViewModel(title: item.title ?? "", avatar: item.media?.first?.mediaMetaData?.first?.url ?? "", byLine: item.byline ?? "", PublishedDate: item.publishedDate ?? "", detailUrlString: item.url ?? "")
    }
    
    //MARK: - Search Article with title
    func searchArticles(with title: String){
        if title == ""{
            self.mostViewedArticles = self.mostViewedArticlesMain
        }else{
            self.mostViewedArticles = self.mostViewedArticlesMain.filter{$0.title?.lowercased().contains(title.lowercased()) ?? false}
        }
        print(self.mostViewedArticles.count)
    }
}

//MARK: - Get Articles List
extension MostPopularArticlesViewModel: MostPopularArticlesServiceProtocol{
    
    @discardableResult
    func getArticles(with category: CategoryEnum, section: SectionEnum, and period: PeriodsEnum) async throws -> MostPopularArticleResponseModel? {
        do{
            let response = try await self.apiService.getArticles(with: category, section: section, and: period)
            if let articles = response?.results{
                self.mostViewedArticles = articles
                self.mostViewedArticlesMain = articles
            }
            return nil
        }
        catch{
            let err = error as? APIError
            errorMessage = err ?? APIError.requestFailed(description: "Something Went Wrong")
        }
        return nil
    }
}

//MARK: - Theme Manager
extension MostPopularArticlesViewModel: SettingProtocol{
    
    func isUserSetPreferredLanguage() -> Bool {
        self.settingManager.isUserSetPreferredLanguage()
    }
    
    func getAppLanguage() -> String {
        self.settingManager.getAppLanguage()
    }
    
    /// Set the App Language
    /// - Parameter langCode: LanguageEnum
    func setAppLanguage(langCode: LanguageEnum) {
        self.settingManager.setAppLanguage(langCode: langCode)
    }
    
    func getThemeIsDark() -> Bool {
        return self.settingManager.getThemeIsDark()
    }
    
    /// Set App Theme
    /// - Parameter isDark: pass true for dark mode or false for light mode
    func setTheme(isDark: Bool) {
        self.settingManager.setTheme(isDark: isDark)
    }
    
    func isUserSetPreferredThemeMode() -> Bool {
        self.settingManager.isUserSetPreferredThemeMode()
    }
    
}
