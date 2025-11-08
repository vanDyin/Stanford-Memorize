//
//  Theme.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 01.11.2025.
//

import Foundation

struct Theme: Codable, Identifiable, Hashable {
    var name: String
    var color: RGBA
    var numberOfPairs: Int
    var emojis: String
    var id = UUID()
}

struct RGBA: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}
