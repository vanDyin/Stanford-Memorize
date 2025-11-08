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
        let emojiArray = Array(theme.emojis)
        let actualNumberOfPairs = min(theme.numberOfPairs, emojiArray.count)
        return ModelMemorizeGame(numberOfPairsOfCards: actualNumberOfPairs) { pairIndex in
            if pairIndex < emojiArray.count {
                return String(emojiArray[pairIndex])
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
