//
//  CardView.swift
//  Memorize
//
//  Created by HannPC on 2024/7/24.
//

import SwiftUI


// Define each card, which has the state of face up or face down, with emoji as content on the card
struct CardView: View {
    typealias Card = MemoryGame<String>.Card
    let card: Card
    let colorList: [Color]
    
    init(_ card: MemoryGame<String>.Card, colorList: [Color]) {
        self.card = card
        self.colorList = colorList
    }
    
    // @State will create a pointer for isFaceUp which will never change, so the content it is pointing to can change
    @State var isFaceUp = false
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            Group {
                if colorList.count > 1 {
                    base.fill(Gradient(colors: colorList))
                } else {
                    base.fill(.white)
                }
                base.strokeBorder(lineWidth: Constants.lineWidth)
                Text(card.content)
                    .font(.system(size:Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.inset)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isMatched ? 0 : 1)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 60
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
    }
}

#Preview {
    typealias Card = MemoryGame<String>.Card
    return CardView(Card(isFaceUp: true, content: "test", id: "testid"), colorList: [.yellow,.pink])
        .padding()
}
