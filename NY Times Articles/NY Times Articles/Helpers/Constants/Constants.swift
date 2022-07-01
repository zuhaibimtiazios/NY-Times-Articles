//
//  Constants.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation

struct NYTApiKeyConstant{
    static let nyTimesApiKey = "DDZ2Wry7ZEp6w8r7w30LZ4vL68xT7ibN"
}


struct ApiConstant{
    static let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"
}

enum settingsNameEnum: String{
    case lightMode = "Light Mode"
    case darkMode  = "Dark Mode"
    case arabic    = "Arabic"
    case english   = "English"
}

enum imageNameEnum: String{
    case iconDots = "ic_dots"
    case iconMenu = "ic_menu"
}
