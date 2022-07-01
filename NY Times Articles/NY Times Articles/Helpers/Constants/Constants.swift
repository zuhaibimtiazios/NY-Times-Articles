//
//  Constants.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation
import UIKit

struct NYTApiKeyConstant{
    static let nyTimesApiKey = "DDZ2Wry7ZEp6w8r7w30LZ4vL68xT7ibN"
}

struct ColorConstants{
    static let customGreenNavbarColor = UIColor(red: 73/255, green: 226/255, blue: 194/255, alpha: 1)
}

struct ApiConstant{
    static let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"
}

enum SettingsNameEnum: String{
    case lightMode = "Light Mode"
    case darkMode  = "Dark Mode"
    case arabic    = "Arabic"
    case english   = "English"
}

enum ImagesNameEnum: String{
    case iconDots = "ic_dots"
    case iconMenu = "ic_menu"
}

enum MostPopularLocalizationKeysEnum: String{
    case mostPopularArticlesTitleKey = "navbarArticlekey"
    case searchTextFieldPlaceholderkey = "searchkey"
    case pullToRefreshKey = "pullToRefreshkey"
    case tryAgainButtonKey = "Try Again"
    case internetConnectivityLabelKey = "Please check your internet connection"
    case darkModeKey = "Dark Mode"
    case lightModeKey = "Light Mode"
    case EnglishKey = "English"
    case arabicKey = "Arabic"

}

enum ApiErrorLocalizationKeyEnum: String{
    case invalidDataApiErrorKey = "Invalid Data error"
    case parsingApiErrorKey = "JSON Parsing Failure error"
    case noInternetApiErrorKey = "No internet connection"
    case serializationApiErrorKey = "serialization print for debug failed"
    case invalidUrlErrorKey = "invalid Url"

}

