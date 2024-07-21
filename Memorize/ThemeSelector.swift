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
        var nPair: Int?
        var color: [String]
        var emojiSet: [String]
    }
    
    func select(_ id: Int, nPair: Int) -> Theme {
        // supporting 6 distinct themes
        switch id {
        case 0:
            let emojis1 = ["🥯","🍞","🥖","🥨","🥐","🥪","🧇","🥞","🍰"]
            return Theme(name: "backery", nPair: nPair, color: ["orange", "yellow"], emojiSet: emojis1)
        case 1:
            let emojis2 = ["🐶","🐱","🐭","🐰","🦊","🐻‍❄️","🐨","🐯","🦁"]
            return Theme(name: "animal", nPair: nPair, color: ["brown"], emojiSet: emojis2)
        case 2:
            let emojis3 = ["🚗","🚕","🚙","🚌","🏎️","🚓","🚑","🚒","🚐"]
            return Theme(name: "car", nPair: nil, color: ["blue"], emojiSet: emojis3)
        case 3:
            let emojis4 = ["🩷","❤️","💛","💚","🩵","💙","💜","🖤","🤍"]
            return Theme(name: "heart", nPair: nPair, color: ["pink"], emojiSet: emojis4)
        case 4:
            let emojis5 = ["🍊","🍋","🍋‍🟩","🍌","🍉","🍇","🍓","🍑","🍍"]
            return Theme(name: "fruit", nPair: nPair, color: ["green"], emojiSet: emojis5)
        default:
            let emojis6 = ["🙂‍↔️", "🥰", "😇", "🥹", "🤨", "😚", "🥳", "😎", "🙂‍↕️"]
            return Theme(name: "emotion", nPair: nPair, color: ["mint"], emojiSet: emojis6)
        }
    }
}
