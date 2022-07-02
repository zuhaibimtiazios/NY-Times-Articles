//
//  MostPopularArticlesService.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation
import Reachability

enum CategoryEnum: String{
    case mostviewedCategory = "mostviewed"
}

enum SectionEnum: String{
    case allSection = "/all-sections"
}

enum PeriodsEnum: String{
    case onePeriod = "/1"
    case sevenPeriod = "/7"
    case monthPeriod = "/30"
}

protocol MostPopularArticlesServiceProtocol {
    func getArticles(with category: CategoryEnum, section: SectionEnum, and period: PeriodsEnum) async throws -> MostPopularArticleResponseModel?
}

struct MostPopularArticlesService: ApiServiceProtocol, MostPopularArticlesServiceProtocol{
    
    
    func getArticles(with category: CategoryEnum, section: SectionEnum, and period: PeriodsEnum) async throws -> MostPopularArticleResponseModel? {
        let urlString = "\(ApiConstant.baseUrl)\(category.rawValue)\(section.rawValue)\(period.rawValue).json?api-key=\(NYTApiKeyConstant.nyTimesApiKey)"
        let reach = try? Reachability.init()
        if reach?.connection == .unavailable {
            throw APIError.noInternet
        }
        
        guard let url = URL(string: urlString) else{
            throw APIError.requestFailed(description: ApiErrorLocalizationKeyEnum.invalidUrlErrorKey.rawValue)
        }
        
        let request = URLRequest(url: url)
        do{
            return try await self.fetch(type: MostPopularArticleResponseModel.self, with: request)
        }catch{
            throw error
        }
    }
    
}
