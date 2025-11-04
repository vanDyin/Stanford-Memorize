//
//  ViewModelMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 27.07.2025.
//

import SwiftUI
import Observation

@Observable
class EmojiMemorizeGame {
    typealias Card = ModelMemorizeGame<String>.Card
    
    var theme: Theme
    private var model: ModelMemorizeGame<String>
    var score: Int { model.score }
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemorizeGame.startGame(theme)
    }
    
    private static func createMemorizeGame(theme: Theme) -> ModelMemorizeGame<String> {
        return ModelMemorizeGame(numberOfPairsOfCards: theme.emojis.count) { pairIndex in 
            if theme.emojis.indices.contains(pairIndex) {
                return theme.emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    var cards: [Card] {
        return model.cards
    }
    
    //MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        return model.choose(card)
    }
}

private extension EmojiMemorizeGame {
    static func startGame(_ theme: Theme) -> (ModelMemorizeGame<String>) {
        let model = createMemorizeGame(theme: theme)
        return model
    }
}
