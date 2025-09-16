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
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }

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
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    var scoreBoard: some View {
        Text("\(viewModel.score)")
            .font(.largeTitle)
    }
}

#Preview {
    ViewMemorizeGame(viewModel: EmojiMemorizeGame())
}

