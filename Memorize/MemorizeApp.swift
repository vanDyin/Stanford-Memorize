//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 11.07.2025.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    @State var game = EmojiMemorizeGame()
    
    var body: some Scene {
        WindowGroup {
            ViewMemorizeGame(viewModel: game)
        }
    }
}
