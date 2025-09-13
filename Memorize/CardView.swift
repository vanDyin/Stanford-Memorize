//
//  CardView.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 12.09.2025.
//

import SwiftUI

struct CardView: View {
    typealias Card = ModelMemorizeGame<String>.Card
    let card: Card
    
    @ObservedObject var viewModel: EmojiMemorizeGame

    init(viewModel: EmojiMemorizeGame, _ card: Card) {
        self.card = card
        self.viewModel = viewModel
    }
    
    var body: some View {
        Pie(endAngle: .degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay {
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.Pie.inset)
            }
            .padding(Constants.inser)
            .cardify(isFaceUp: card.isFaceUp)
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
            .foregroundStyle(viewModel.currentTheme.color)
    }
    
    private struct Constants {
        static let inser: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 20
            static let scaleFactor = smallest / largest
        }
        
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 5
        }
    }
}

#Preview {
    typealias Card = CardView.Card
    return VStack {
        HStack {
            CardView(viewModel: EmojiMemorizeGame(), Card(content: "X"))
            CardView(viewModel: EmojiMemorizeGame(), Card(isFaceUp: true, content: "X"))
        }
        HStack {
            CardView(viewModel: EmojiMemorizeGame(), Card(isFaceUp: true, isMatched: true, content: "X"))
            CardView(viewModel: EmojiMemorizeGame(), Card(isMatched: true, content: "X"))
        }
    }
    .padding()
}
