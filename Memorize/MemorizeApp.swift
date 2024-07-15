//
//  MemorizeApp.swift
//  Memorize
//
//  Created by HannPC on 2024/7/4.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
