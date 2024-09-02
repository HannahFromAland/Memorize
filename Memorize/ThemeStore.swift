//
//  ThemeStore.swift
//  Memorize
//
//  Created by HannPC on 2024/9/1.
//

import Foundation
import SwiftUI

extension UserDefaults {
    func themes(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key),
           let themes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            return themes
        } else {
            return []
        }
    }
    
    func set(_ themes: [Theme], forKey key: String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}

class ThemeStore: ObservableObject {
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    private var userDefaultsKey = "ThemeStore: Main"
    
    init() {
        if themes.isEmpty {
            themes = Theme.builtins
        }
    }
    
    // MARK: - Modify Themes
    
    func append(_ theme: Theme) {
        if let index = themes.firstIndex(where: {$0.id == theme.id}) {
            if themes.count == 1 {
                themes = [theme]
            } else {
                themes.remove(at: index)
                themes.append(theme)
            }
        } else {
            themes.append(theme)
        }
    }
    
    func append(name: String, emojis: String) {
        append(Theme(name: name, emojis: emojis, numberOfPairs: 4, color: "blue"))
    }
    
    
}


