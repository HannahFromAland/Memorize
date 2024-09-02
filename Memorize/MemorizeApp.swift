//
//  MemorizeApp.swift
//  Memorize
//
//  Created by HannPC on 2024/7/4.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore()
//    @StateObject var game = EmojiMemoryGame(theme: )
    var body: some Scene {
        WindowGroup {
            ThemeStoreView(themeStore: themeStore)
        }
    }
}
