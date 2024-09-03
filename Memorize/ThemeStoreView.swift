//
//  ThemeChoiceList.swift
//  Memorize
//
//  Created by HannPC on 2024/9/1.
//

import SwiftUI

struct ThemeStoreView: View {
    @ObservedObject var themeStore: ThemeStore
    
    @State private var showThemeDetail = false
    @State private var selectedTheme: Theme?

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(themeStore.themes) { theme in
                    NavigationLink(value: theme) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                            Text(theme.emojis).lineLimit(1)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            deleteButton(theme)
                            editButton(theme)
                        }
                    }

                }
            }
            .navigationTitle("Theme Chooser")
            .toolbar {
                addThemeButton
            }
            .navigationDestination(for: Theme.self) { theme in
               EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))

            }
        } detail: {
            if let selectedTheme {
                if let index = themeStore.themes.firstIndex(where: {$0.id == selectedTheme.id}) {
                    EmojiMemoryGameView(game: EmojiMemoryGame(theme: themeStore.themes[index]))
                }
            } else {
                Text("Select a theme to start the game")
            }
        }
        .sheet(item: $selectedTheme) { item in
            if let index = themeStore.themes.firstIndex(where: {$0.id == item.id}) {
                ThemeDetail(theme: $themeStore.themes[index])
            }
        }
        .sheet(isPresented: $showThemeDetail) {
            ThemeDetail(theme: $themeStore.themes[themeStore.themes.count - 1])
        }

    }
    
    private func deleteButton(_ theme: Theme) -> some View {
        Button(role:.destructive){
            if let index = themeStore.themes.firstIndex(where: {$0.id == theme.id}) {
                themeStore.themes.remove(at:index)
            }
            
        } label: {
            Image(systemName: "minus.circle")
        }
    }
    
    private func editButton(_ theme: Theme) -> some View {
        Button {
            selectedTheme = theme
        } label: {
            Image(systemName: "square.and.pencil")
        }
    }
    
    private var addThemeButton: some View {
        Button {
            themeStore.append(name: "", emojis: "")
            showThemeDetail = true
        } label: {
            Image(systemName: "plus.circle")
        }
    }
}
#Preview {
    ThemeStoreView(themeStore: ThemeStore())
}
