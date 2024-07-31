//
//  Cardify.swift
//  Memorize
//
//  Created by HannPC on 2024/7/30.
//

import SwiftUI

struct Cardify: ViewModifier {
    let isFaceUp: Bool
    let isMatched: Bool
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .opacity(isMatched ? 0 : 1)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isFaceUp: Bool, isMatched: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched))
    }
}
