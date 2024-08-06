//
//  MemoryGame.swift
//  Memorize
//
//  Created by HannPC on 2024/7/13.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    // means settings of this var is private, accessing the var is public
    private(set) var cards: Array<Card>
    
    // create a time-based score, initially each match add 20 seconds, and a mismatch -10 seconds, initial total score is 10 * nPair and ticked down
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content: CardContent = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
        score = 0
    }
    
    var currFaceUpCard: Int? {
        get {
            // get the currFaceUpCard if there is only one card facing up
            return cards.indices.filter { index in cards[index].isFaceUp}.only}
        set {
            // getting all other cards to be faced down
            cards.indices.forEach { index in
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                // first check the pre flip scenario
                if let potentialFaceUpCard = currFaceUpCard {
                    if cards[potentialFaceUpCard].content == cards[chosenIndex].content {
                        cards[potentialFaceUpCard].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 2 + cards[chosenIndex].bonus + cards[potentialFaceUpCard].bonus
                    } else {
                        // a mismatch
                        if cards[potentialFaceUpCard].isSeen {
                            score -= 1
                        }
                        if cards[chosenIndex].isSeen {
                            score -= 1
                        }
                    }
                } else {
                    // currFaceUpCard is nil, either there is no face up cards or the two facing up cards are not matching
                    currFaceUpCard = chosenIndex
                }
                // flip the card to be faced up
                cards[chosenIndex].isFaceUp = true
            }
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func restart() {
        cards.shuffle()
        cards.indices.forEach { index in
            cards[index].isMatched = false
            cards[index].isFaceUp = false
            cards[index].isSeen = false
        }
        score = 0
    }

    // nested struct
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id): \(content) is \(isFaceUp ? "up" : "down"), \(isMatched ? "matched" : "not matched yet");"
        }
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startBonusTime()
                } else {
                    stopBonusTime()
                }
                if oldValue && !isFaceUp {
                    isSeen = true
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopBonusTime()
                }
            }
        }
        var isSeen: Bool = false
        let content: CardContent // CardContent is a don't care for us, so do not(cannot) initialize
        
        var id: String // for Identifiable
        
        // MARK: Bonus Time
        
        var bonusTimePerCard: TimeInterval = 6
        
        // start timestamp for current period of facing up, will be reset everytime the card facing down
        var startFaceUpTime: Date?
        
        
        // total time of current period facing up, if card is currently facing up then add the current facing-up interval, else only return the previous time amount
        var currentFaceUpTime: TimeInterval {
            if let startFaceUpTime {
                return totalFaceUpTime + Date().timeIntervalSince(startFaceUpTime)
            } else {
                return totalFaceUpTime
            }
        }
        
        // the total facing up time accumulating from different period, when every counting stops, add the current totalFaceUpTime to this as previous FaceUp time
        var totalFaceUpTime: TimeInterval = 0
        
        private mutating func startBonusTime() {
            if isFaceUp && !isMatched && bonusPercentageRemaining > 0 && startFaceUpTime == nil {
                startFaceUpTime = Date()
            }
        }
        
        private mutating func stopBonusTime() {
            totalFaceUpTime = currentFaceUpTime
            startFaceUpTime = nil
        }
        
        // bonus score caculation
        var bonus: Int {
            Int(bonusTimePerCard * bonusPercentageRemaining)
        }
        
        var bonusPercentageRemaining: Double {
            bonusTimePerCard > 0 ? max(0, bonusTimePerCard - currentFaceUpTime) / bonusTimePerCard : 0
        }
        
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
