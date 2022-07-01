//
//  ThemeManager.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation
import UIKit

protocol ThemeProtocol{
    func setTheme(isDark: Bool)
    func getThemeIsDark() -> Bool
}

class ThemeManager: ThemeProtocol{
    
    func getThemeIsDark() -> Bool{
        return UserDefaults.standard.bool(forKey: UserDefaults.Keys.isDarkMode.rawValue)
    }
    
    func setTheme(isDark: Bool){
        UserDefaults.standard.set(isDark, forKey: UserDefaults.Keys.isDarkMode.rawValue)
        UIApplication.shared.connectedScenes.forEach { (scene: UIScene) in
            (scene.delegate as? SceneDelegate)?.window?.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }
}
