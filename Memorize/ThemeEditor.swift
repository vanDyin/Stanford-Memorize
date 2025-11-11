//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 10.11.2025.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @State private var emojisToAdd: String = ""
    @FocusState private var isTextFieldFocused: Bool
    private let emojiFont = Font.system(size: 40)
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $theme.name)
                    .focused($isTextFieldFocused)
            }
            
            Section(header: Text("Number of Pairs")) {
                Stepper("\(theme.numberOfPairs)", value: $theme.numberOfPairs, in: 2...max(2, theme.emojis.count))
            }
            
            Section(header: Text("Color")) {
                ColorPicker("Choose theme color", selection: Binding(
                    get: { Color(rgba: theme.color) },
                    set: { newColor in
                        theme.color = RGBA(color: newColor)
                    }
                ))
            }
            
            Section(header: Text("Emojis")) {
                TextField("Add emojis here", text: $emojisToAdd)
                    .font(emojiFont)
                    .focused($isTextFieldFocused)
                    .onChange(of: emojisToAdd) { _, emojisToAdd in
                        theme.emojis = (emojisToAdd + theme.emojis)
                            .filter{ $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .onTapGesture {
            isTextFieldFocused = false
        }
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
    struct Preview: View {
        @State var store = ThemeStore()
        var body: some View {
            ThemeEditor(theme: $store.themes.first!)
        }
    }
    return Preview()
}
