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
        ThemeEditor(theme: $store.themes.first!)
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
                    .onChange(of: emojisToAdd) { _, emojiToAdd in
                        //Add emoji in theme 
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
                ForEach(theme.emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            theme.emojis.removeAll(where: { $0 == emoji })
                            emojisToAdd.removeAll(where: { String($0) == emoji })
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

#Preview {
    //ThemeManager(store: ThemeStore())
    struct Preview: View {
        @State var store = ThemeStore()
        var body: some View {
            ThemeEditor(theme: $store.themes.first!)
        }
    }
    return Preview()
}
