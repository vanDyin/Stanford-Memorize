//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 11.07.2025.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @State var themeStore = ThemeStore()
    
    var body: some Scene {
        WindowGroup {
            ThemeManager(store: themeStore)
                .environment(themeStore)
        }
    }
}
