//
//  ThemeSelector.swift
//  Memorize
//
//  Created by HannPC on 2024/7/17.
//

import Foundation

struct ThemeSelector {
    struct Theme {
        var name: String
        var nPair: Int
        var color: String
        var emojiSet: [String]
    }
    
    func select(_ id: Int, nPair: Int) -> Theme {
        // supporting 6 distinct themes
        switch id {
        case 0:
            let emojis = ["🥯","🍞","🥖","🥨","🥐","🥪","🍔","🧇","🥞","🍕","🍰"]
            return Theme(name: "backery", nPair: nPair, color: "yellow", emojiSet: emojis)
        case 1:
            let emojis = ["🐶","🐱","🐭","🐹","🐰","🐻","🦊","🐻‍❄️","🐨","🐯","🦁"]
            return Theme(name: "animal", nPair: nPair, color: "brown", emojiSet: emojis)
        case 2:
            let emojis = ["🚗","🚕","🚙","🚌","🚎","🏎️","🚓","🚑","🚒","🚐","🛻"]
            return Theme(name: "car", nPair: nPair, color: "blue", emojiSet: emojis)
        case 3:
            let emojis = ["🩷","❤️","🧡","💛","💚","🩵","💙","💜","🖤","🩶","🤍"]
            return Theme(name: "heart", nPair: nPair, color: "pink", emojiSet: emojis)
        case 4:
            let emojis = ["🍎","🍐","🍊","🍋","🍋‍🟩","🍌","🍉","🍇","🍓","🍑","🍍"]
            return Theme(name: "fruit", nPair: nPair, color: "green", emojiSet: emojis)
        default:
            let emojis = ["🙂‍↔️", "🥰", "😇", "🥹", "😉", "🤨", "😚", "🤩","🥳", "😎", "🙂‍↕️"]
            return Theme(name: "emotion", nPair: nPair, color: "mint", emojiSet: emojis)
        }
    }
}
