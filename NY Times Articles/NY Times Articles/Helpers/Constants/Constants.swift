//
//  Constants.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation

struct Constants{
    static let pullToRefresh = "Reloading"
    static let internetConnectionError = "Please check your internet connection"
}

struct NYTApiKeyConstant{
    static let nyTimesApiKey = "DDZ2Wry7ZEp6w8r7w30LZ4vL68xT7ibN"
}


struct ApiConstant{
    static let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"
}

enum themeNameEnum: String{
    case lightMode = "Light Mode"
    case darkMode = "Dark Mode"
}

enum imageNameEnum: String{
    case iconDots = "ic_dots"
    case iconMenu = "ic_menu"
}
