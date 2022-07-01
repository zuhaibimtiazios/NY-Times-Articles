//
//  SettingManager.swift
//  NY Times Articles
//
//  Created by zuhaib imtiaz on 01/07/2022.
//

import Foundation

protocol SettingProtocol: LanguageProtocol, ThemeProtocol{
    
}

struct SettingManager: SettingProtocol{
    
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
    
    func isUserSetPreferredThemeMode() -> Bool {
        return self.themeManager.isUserSetPreferredThemeMode()
    }
}
