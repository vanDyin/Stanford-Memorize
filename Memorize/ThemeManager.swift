//
//  ThemeManager.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 02.11.2025.
//

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
                            Text(theme.emojis)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .navigationDestination(for: Theme.ID.self) { themeId in
                if let index = store.themes.firstIndex(where: { $0.id == themeId}) {
                    ThemeEditor(theme: $store.themes[index])
                }
            }
            .navigationDestination(for: Theme.self) { theme in
                ViewMemorizeGame(viewModel: EmojiMemorizeGame(theme: theme))
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
            Section(header: Text("Color")) {
                ColorPicker("Choose theme color", selection: Binding(
                    get: { Color(rgba: theme.color) },
                    set: { newColor in
                        theme.color = RGBA(color: newColor)
                    }
                ))
            }
            startPlay
        }
        .frame(minWidth: 300, minHeight: 350)
        .navigationTitle(theme.name)
    }
    
    var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to remove emoji").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            if let firstEmoji = emoji.first {
                                theme.emojis.remove(firstEmoji)
                                emojisToAdd.remove(firstEmoji)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
    
    var startPlay: some View {
        NavigationLink(value: theme) {
            Text("Start play!")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .font(.largeTitle)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20))
       }
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

//RGBA -> Color
extension Color {
    init(rgba: RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
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
