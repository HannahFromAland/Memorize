//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by HannahFromAland on 2024/7/4.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    // View is stateless, constantly showing what being represent in Model
    // View is declared （not imperative)
    // View is reactive, reacting to all changes in Model
    
    // Never let ObservedObject equals to anything
    @ObservedObject var viewModel: EmojiMemoryGame
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 10
    
    var body: some View {
        VStack (spacing: spacing){
            VStack {
                title
                HStack {
                    Text("Score: \(viewModel.score)")
                        .font(.title2)
                    Spacer()
                    Text("Time Elapsed:")
                        .font(.title2)
                    if let startTime = viewModel.timer {
                        Text(startTime, style: .timer)
                            .font(.title2)
                    } else {
                        Text(viewModel.usedTimeFormatted)
                            .font(.title2)
                    }
                }.padding()

            }
            cards
                .animation(.default, value: viewModel.cards)
            HStack{
                Button("New Game") {
                    viewModel.restart()
                }
                Spacer()
                Button("Shuffle") {
                    viewModel.shuffle()
                }
                Spacer()
                Button("Pause Game") {
                    viewModel.pause()
                }
            }
            .padding()
        }
    }
    
    // Defines the title for the game
    var title: some View {
        Text("Memorize \(viewModel.theme.name)!")
            .font(.title)
            .padding()
            .foregroundColor(Color.gray)
    }

    
    // Defines card part
    @ViewBuilder
    private var cards: some View {
        // implicit return
        // lazyGrid will use space as less as it can, but HStack takes as much as it can
        let colorList = viewModel.theme.color.map { EmojiMemoryGame.intepretColor($0)}
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card, colorList: colorList)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        .foregroundColor(colorList.first)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
