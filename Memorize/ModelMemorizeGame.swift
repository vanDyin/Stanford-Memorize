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
                        score += 2
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
                if oldValue && !isFaceUp {
                    isViewed = true
                }
            }
        }
        var isMatched = false
        var content: CardContent
        var isViewed = false
        
        var id = UUID()
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
