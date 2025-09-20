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
        TimelineView(.animation) { timeline in
            if card.isFaceUp || !card.isMatched {
                Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay(cardContents.padding(Constants.Pie.inset))
                    .padding(Constants.inser)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale)
                    .foregroundStyle(viewModel.currentTheme.color)
            } else {
                Color.clear
            }
        }
    }
    
    var cardContents: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)
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

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
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
