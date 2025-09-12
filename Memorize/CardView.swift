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
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: Constants.lineWidth)
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.inser)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
        .foregroundStyle(viewModel.currentTheme.color)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inser: CGFloat = 5
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 20
            static let scaleFactor = smallest / largest
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
