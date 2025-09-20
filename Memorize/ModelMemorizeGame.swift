//
//  ModelMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 27.07.2025.
//

import Foundation

struct ModelMemorizeGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private(set) var score: Int = 0
    
    init(numberOfPairsOfCards: Int, myCardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = myCardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
        cards.shuffle()
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter {index in cards[index].isFaceUp}.only }
        set { cards.indices.forEach {cards[$0].isFaceUp = (newValue == $0)} }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                        cards[potentialMatchIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
                    }
                    if cards[chosenIndex].isViewed && !cards[chosenIndex].isMatched {
                        score -= 1
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    isViewed = true
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var content: CardContent
        var isViewed = false
        
        //MARK: bonus time
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var bonusTimeLimit: TimeInterval = 6
        
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var id = UUID()
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
