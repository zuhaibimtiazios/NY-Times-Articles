//
//  LanguageManager.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation
import UIKit

enum LanguageEnum: String{
    case english = "en"
    case arabic = "ar"
}

protocol LanguageProtocol{
    func getAppLanguage() -> String
    func isUserSetPreferredLanguage() -> Bool
    func setAppLanguage(langCode: LanguageEnum)
}

class LanguageManager: LanguageProtocol{
    
    func isUserSetPreferredLanguage() -> Bool{
        return UserDefaults.standard.bool(forKey: UserDefaults.Keys.isSetPreferredLanguage.rawValue)
    }
    
    func getAppLanguage() -> String{
        return UserDefaults.standard.string(forKey: UserDefaults.Keys.lang.rawValue) ?? LanguageEnum.english.rawValue
    }
    
    func setAppLanguage(langCode: LanguageEnum){
        UserDefaults.standard.set(langCode.rawValue, forKey: UserDefaults.Keys.lang.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isSetPreferredLanguage.rawValue)
        UIView.appearance().semanticContentAttribute = langCode == LanguageEnum.english ? .forceLeftToRight :  .forceRightToLeft

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate{
            delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
        }


    }
}

protocol SettingProtocol: LanguageProtocol, ThemeProtocol{
    
}


class SettingManager: SettingProtocol{
    
    
    let languageManager: LanguageProtocol
    let themeManager: ThemeProtocol

    init(_languageManager: LanguageProtocol, _ThemeManager: ThemeProtocol){
        languageManager = _languageManager
        themeManager = _ThemeManager
    }
    
    func isUserSetPreferredLanguage() -> Bool {
        return self.languageManager.isUserSetPreferredLanguage()
    }
        
    func getAppLanguage() -> String {
        return self.languageManager.getAppLanguage()
    }
    
    func setAppLanguage(langCode: LanguageEnum) {
        self.languageManager.setAppLanguage(langCode: langCode)
    }
    
    func setTheme(isDark: Bool) {
        self.themeManager.setTheme(isDark: isDark)
    }
    
    func getThemeIsDark() -> Bool {
        return self.themeManager.getThemeIsDark()
    }
    
    
}
