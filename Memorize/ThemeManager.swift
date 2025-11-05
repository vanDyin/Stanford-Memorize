//
//  ThemeManager.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 02.11.2025.
//

//View of ThemeStore
import SwiftUI

struct ThemeManager: View {
    @Bindable var store: ThemeStore
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(value: theme.id) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                            Text(theme.emojis).lineLimit(1)
                        }
                    }
                }
            }
            .navigationDestination(for: Theme.ID.self) { themeId in
                if let index = store.themes.firstIndex(where: { $0.id == themeId}) {
                    ThemeEditor(theme: $store.themes[index])
                }
            }
        }
    }
}

struct ThemeEditor: View {
    @Binding var theme: Theme
    @State private var emojisToAdd: String = ""
    private let emojiFont = Font.system(size: 40)
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $theme.name)
            }
            Section(header: Text("Emojis")) {
                TextField("Add emojis here", text: $emojisToAdd)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd) { _, emojisToAdd in
                        theme.emojis = (emojisToAdd + theme.emojis)
                            .filter{ $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to remove emoji").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            theme.emojis.remove(emoji.first!)
                            emojisToAdd.remove(emoji.first!)
                        }
                }
            }
        }
        .font(emojiFont)
    }
}

extension Character {
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}

extension String {
    mutating func remove(_ ch: Character) {
        removeAll(where: { $0 == ch })
    }
}

extension String {
    var uniqued: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}

#Preview {
    ThemeManager(store: ThemeStore())
//    struct Preview: View {
//        @State var store = ThemeStore()
//        var body: some View {
//            ThemeEditor(theme: $store.themes.first!)
//        }
//    }
//    return Preview()
}
