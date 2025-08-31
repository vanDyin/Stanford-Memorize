//
//  ModelMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 27.07.2025.
//

import Foundation

struct ModelMemorizeGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    
    init(numberOfPairsOfCards: Int, myCardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = myCardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    var indexOfTheOneandOnlyFaceUpCard: Int? {
        get { cards.indices.filter {index in cards[index].isFaceUp}.only }
        set { cards.indices.forEach {cards[$0].isFaceUp = (newValue == $0)} }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneandOnlyFaceUpCard {
                    if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                        cards[potentialMatchIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                    }
                    cards[chosenIndex].isFaceUp = true // Переворачиваем карту
                } else {
                    // Нет других перевернутых карт
                    indexOfTheOneandOnlyFaceUpCard = chosenIndex
                    cards[chosenIndex].isFaceUp = true // Переворачиваем карту
                }
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        
        var id = UUID()
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
