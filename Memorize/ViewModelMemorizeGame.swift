//
//  ViewModelMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 27.07.2025.
//

import SwiftUI

class EmojiMemorizeGame: ObservableObject {
    typealias Card = ModelMemorizeGame<String>.Card
    
    private static let arrayOfThemes = [
        Theme(name: "Halloween",
              emojis: ["💀", "👻", "🎃", "🕷️", "🕸️", "🪦", "☠️", "👿", "🧟‍♂️", "👹"],
              color: Color.orange),
        Theme(name: "Animals",
              emojis: ["🐶", "🐷", "🐤", "🐯", "🐻", "🐱", "🦊", "🐧"],
              color: Color.red),
        Theme(name: "Vehicles",
              emojis: ["🚗", "🏎️", "🛵", "✈️", "🚀", "⛵️", "🚂", "🚜", "🚲", "🚙", "🚌"],
              color: Color.blue),
        Theme(name: "Flags",
              emojis: ["🏴‍☠️", "🇧🇾", "🇷🇺", "🇦🇫", "🇧🇧", "🇯🇵", "🇬🇧"],
              color: Color.green),
        Theme(name: "Fruits",
              emojis: ["🍎", "🍊", "🍋", "🍍", "🍑", "🍌"],
              color: Color.yellow),
        Theme(name: "Balls",
              emojis: ["⚽️", "🏀", "🏈", "🎾", "🏐"],
              color: Color.black),
    ]
    
    var currentTheme: Theme
    @Published private var model: ModelMemorizeGame<String>
    var score: Int { model.score }
    
    init() {
        (currentTheme, model) = EmojiMemorizeGame.startGame()
    }
    
    private static func createMemorizeGame(theme: Theme) -> ModelMemorizeGame<String> {
        return ModelMemorizeGame(numberOfPairsOfCards: theme.emojis.count) { pairIndex in //numberOfPairsOfCards: theme.emojis.count
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
    
    struct Theme {
        let name: String
        let emojis: [String]
        let numberOfPairsOfCards: Int?
        let color: Color
        
        init(name: String, emojis: [String], color: Color) {
            self.name = name
            self.emojis = emojis
            numberOfPairsOfCards = emojis.count
            self.color = color
        }
    }
}

private extension EmojiMemorizeGame {
    static func startGame() -> (Theme, ModelMemorizeGame<String>) {
        let theme = arrayOfThemes.randomElement()!
        let model = createMemorizeGame(theme: theme)
        return (theme, model)
    }
}
