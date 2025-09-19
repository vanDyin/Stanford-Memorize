//
//  ViewMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 11.07.2025.
//

import SwiftUI

struct ViewMemorizeGame: View {
    typealias Card = ModelMemorizeGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemorizeGame
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 2
    
    var body: some View {
        VStack {
            title
            cards
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
                .padding(spacing)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                .onTapGesture {
                    choose(card)
                }
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: UUID())
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
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
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    var scoreBoard: some View {
        Text("Score: \(viewModel.score)")
            .font(.largeTitle)
            .animation(nil)
    }
}

#Preview {
    ViewMemorizeGame(viewModel: EmojiMemorizeGame())
}

