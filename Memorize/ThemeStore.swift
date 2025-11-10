//
//  ThemeStore.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 02.11.2025.
//

import SwiftUI
import Observation

@Observable
class ThemeStore {
    static var initialThemes: [Theme] {[
        Theme(name: "Halloween", color: RGBA(color: .orange), numberOfPairs: 10, emojis: "💀👻🎃🕷️🕸️🪦☠️👿🧟‍♂️👹"),
        Theme(name: "Animals", color: RGBA(color: .red), numberOfPairs: 8, emojis: "🐶🐷🐤🐯🐻🐱🦊🐧"),
        Theme(name: "Vehicles", color: RGBA(color: .blue), numberOfPairs: 11, emojis: "🚗🏎️🛵✈️🚀⛵️🚂🚜🚲🚙🚌"),
        Theme(name: "Flags", color: RGBA(color: .green), numberOfPairs: 7, emojis: "🏴‍☠️🇧🇾🇷🇺🇦🇫🇧🇧🇯🇵🇬🇧"),
        Theme(name: "Fruits", color: RGBA(color: .yellow), numberOfPairs: 6, emojis: "🍎🍊🍋🍍🍑🍌"),
        Theme(name: "Balls", color: RGBA(color: .black), numberOfPairs: 5, emojis: "⚽️🏀🏈🎾🏐")
    ]}
    
    //create json encoder and decoder for initialize computed property themes
    var themes: [Theme]
    
    //make it so that if jsondata is empty, then take initialThemes
    init() {
        self.themes = ThemeStore.initialThemes
    }
    
    func loadThemes() {
        //jsonDecoder
    }
    
    func saveThemes() {
        //jsonEncoder
    }
    
    func insertNewElement() -> Theme {
        //print("вызван shhheeet1")
        let newTheme = Theme(
            name: "New Theme",
            color: RGBA(color: .blue),
            numberOfPairs: 2,
            emojis: ""
        )
        themes.insert(newTheme, at: 0)
        //print("вызван shhheeet2")
        return newTheme
    }
}

//Color -> RGBA
extension RGBA {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

//RGBA -> Color
extension Color {
    init(rgba: RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}
