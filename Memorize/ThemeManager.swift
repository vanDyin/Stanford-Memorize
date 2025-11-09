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
                    ThemeEditor(theme: $store.themes[index])
                }
            }
            .navigationDestination(for: Theme.self) { theme in
                ViewMemorizeGame(viewModel: EmojiMemorizeGame(theme: theme))
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
            
        } label: {
            Image(systemName: "plus")
        }
    }
    
    func colorView(_ color: Color) -> some View {
        return color
            .frame(width: 15, height: 15)
            .cornerRadius(10)
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
                    .onChange(of: emojisToAdd) { _, emojisToAdd in
                        theme.emojis = (emojisToAdd + theme.emojis)
                            .filter{ $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
            
            startPlay
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
        .disabled(theme.emojis.count < 2)
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
