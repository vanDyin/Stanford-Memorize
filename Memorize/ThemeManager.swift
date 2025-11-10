//
//  ThemeManager.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 02.11.2025.
//

import SwiftUI

struct ThemeManager: View {
    @Bindable var store: ThemeStore
    @State private var editingTheme: Theme?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(value: theme.id) {
                        themeRow(theme: theme)
                    }
                    .disabled(theme.emojis.count < 2)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = store.themes.firstIndex(where: { $0.id == theme.id }) {
                                store.themes.remove(at: index)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button { editingTheme = theme } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                .onMove { indexSet, offset in
                    store.themes.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
            }
            .navigationDestination(for: Theme.ID.self) { themeId in
                if let index = store.themes.firstIndex(where: { $0.id == themeId}) {
                    ViewMemorizeGame(viewModel: EmojiMemorizeGame(theme: store.themes[index]))
                }
            }
            .sheet(item: $editingTheme) { theme in
                if let index = store.themes.firstIndex(where: { $0.id == theme.id }) {
                    ThemeEditor(theme: $store.themes[index])
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    addButton
                }
            }
            .navigationTitle("Themes")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    var addButton: some View {
        Button {
            withAnimation {
                let newTheme = store.insertNewElement()
                editingTheme = newTheme
            }
        } label: {
            Image(systemName: "plus")
        }
    }
    
    func themeRow(theme: Theme) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(theme.name)
                colorView(Color(rgba: theme.color))
            }
            Text(theme.emojis)
                .lineLimit(1)
            Text("Number of emojis displayed: \(theme.numberOfPairs)")
            
        }
    }
    
    func colorView(_ color: Color) -> some View {
        return color
            .frame(width: 15, height: 15)
            .cornerRadius(10)
    }
}

#Preview {
    ThemeManager(store: ThemeStore())
}
