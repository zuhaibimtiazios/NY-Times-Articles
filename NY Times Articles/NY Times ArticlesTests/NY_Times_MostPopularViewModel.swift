//
//  NY_Times_MostPopularViewModel.swift
//  NY Times ArticlesTests
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import XCTest
@testable import NY_Times_Articles

class NY_Times_MostPopularViewModel: XCTestCase {
    
    let sut: MostPopularArticlesViewModel = MostPopularArticlesViewModel(_apiService: MostPopularArticlesService(), _settingManager: SettingManager(_languageManager: LanguageManager(), _ThemeManager: ThemeManager()))
    
    func test_SetThemeIsDark_And_Returns_true() {
        sut.setTheme(isDark: true)
        XCTAssertTrue(sut.getThemeIsDark())
    }
    
    func test_isUserPreferredThemeMode_And_Returns_true() {
        sut.setTheme(isDark: true)
        XCTAssertTrue(sut.isUserSetPreferredThemeMode())
    }
    
    func test_isUserPreferredLanguage_And_Returns_true() {
        sut.setAppLanguage(langCode: .english)
        XCTAssertTrue(sut.isUserSetPreferredLanguage())
    }
    
    func test_SetThemeIsDarkAnd_Returns_False() {
        sut.setTheme(isDark: false)
        XCTAssertFalse(sut.getThemeIsDark())
    }
    
    func test_getArticlesAnd_Return_NotNil_OR_Throws() async throws{
        do{
            let result = try await sut.apiService.getArticles(with: .mostviewedCategory, section: .allSection, and: .onePeriod)
            XCTAssertNotNil(result)
        }
        catch{
            XCTAssertNotNil(error.localizedDescription)
        }
    }
    
    func test_getArticlesAnd_Throws_NoInternet() async throws{
        let sutMock: MostPopularArticlesViewModel = MostPopularArticlesViewModel(_apiService: MockServiceForNoInternet(), _settingManager: SettingManager(_languageManager: LanguageManager(), _ThemeManager: ThemeManager()))

        do{
            _ = try await sutMock.apiService.getArticles(with: .mostviewedCategory, section: .allSection, and: .onePeriod)
        }
        catch{
            XCTAssertNotNil(error.localizedDescription)
        }
    }
    
    func test_getArticlesAnd_Throws_InvalidUrl() async throws{
        let sutMock: MostPopularArticlesViewModel = MostPopularArticlesViewModel(_apiService: MockServiceForInvalidUrl(), _settingManager: SettingManager(_languageManager: LanguageManager(), _ThemeManager: ThemeManager()))

        do{
            _ = try await sutMock.apiService.getArticles(with: .mostviewedCategory, section: .allSection, and: .onePeriod)
        }
        catch{
            XCTAssertEqual(error as? APIError, .requestFailed(description: ApiErrorLocalizationKeyEnum.invalidUrlErrorKey.rawValue))
        }
    }
    
    func test_searchArticlesAndReturn_NotNil() throws{
        XCTAssertNotNil(sut.searchArticles(with: "a"))
    }
    
    func test_searchArticlesWithEmptySearchTextAndReturn_NotNil() throws{
        XCTAssertNotNil(sut.searchArticles(with: ""))
    }
}


struct MockServiceForNoInternet: MostPopularArticlesServiceProtocol{
    func getArticles(with category: CategoryEnum, section: SectionEnum, and period: PeriodsEnum) async throws -> MostPopularArticleResponseModel? {
        throw(APIError.noInternet)
    }
}

struct MockServiceForInvalidUrl: MostPopularArticlesServiceProtocol{
    func getArticles(with category: CategoryEnum, section: SectionEnum, and period: PeriodsEnum) async throws -> MostPopularArticleResponseModel? {
        throw(APIError.requestFailed(description: ApiErrorLocalizationKeyEnum.invalidUrlErrorKey.rawValue))
    }
}
