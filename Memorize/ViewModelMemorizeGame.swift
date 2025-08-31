//
//  ViewModelMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 27.07.2025.
//

import SwiftUI

class EmojiMemorizeGame: ObservableObject {
    
    private static let emojis = ["💀", "👻", "🎃", "🕷️", "🕸️", "🪦", "☠️", "👿", "🧟‍♂️", "👹", "dsa"]
    
    private static func createMemoizeGame() -> ModelMemorizeGame<String> {
        return ModelMemorizeGame(numberOfPairsOfCards: emojis.count) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published private var model = createMemoizeGame()
    
    var cards: [ModelMemorizeGame<String>.Card] {
        return model.cards
    }
    
    //MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: ModelMemorizeGame<String>.Card) {
        return model.choose(card)
    }
}

