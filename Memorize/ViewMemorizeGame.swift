//
//  ViewMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 11.07.2025.
//

import SwiftUI

struct ViewMemorizeGame: View {
    @ObservedObject var viewModel: EmojiMemorizeGame
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            title
            cards
                .animation(.default, value: viewModel.cards)
            HStack {
                restartButton
                Spacer()
                scoreBoard
                Spacer()
                shuffleButton
            }
        }
        .padding()
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(viewModel: viewModel, card)
                .padding(2)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
    }
    
    var title: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            Text("\(viewModel.currentTheme.name)")
                .font(.title2)
        }
    }
    
    var restartButton: some View {
        Button("Restart") {
            viewModel.restart()
        }
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            viewModel.shuffle()
        }
    }
    
    var scoreBoard: some View {
        Text("\(viewModel.score)")
            .font(.largeTitle)
    }
}

struct CardView: View {
    @ObservedObject var viewModel: EmojiMemorizeGame
    let card: ModelMemorizeGame<String>.Card

    init(viewModel: EmojiMemorizeGame, _ card: ModelMemorizeGame<String>.Card) {
        self.card = card
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
        .foregroundStyle(viewModel.currentTheme.color)
    }
}

#Preview {
    ViewMemorizeGame(viewModel: EmojiMemorizeGame())
}

