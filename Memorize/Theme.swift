//
//  Theme.swift
//  Memorize
//
//  Created by HannPC on 2024/9/1.
//

import Foundation

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var numberOfPairs: Int
    var color: String
    var id = UUID()
    
    static var builtins: [Theme] {
        [
            Theme(name: "Animal", emojis: "🐶🐱🐭🐰🦊🐻‍❄️🐨🐯🦁", numberOfPairs: 6, color: "orange"),
            Theme(name: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", numberOfPairs: 6, color: "mint"),
            Theme(name: "Backery",emojis: "🥯🍞🥖🥨🥐🥪🧇🥞🍰", numberOfPairs: 6, color: "yellow")
        ]
    }
}
