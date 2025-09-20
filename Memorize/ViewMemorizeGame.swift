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
                scoreBoard
                Spacer()
                deck
                Spacer()
                shuffleButton
            }
        }
        .padding()
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(viewModel: viewModel, card)
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
                    .transition(.offset(
                        x: CGFloat.random(in: -1000...1000),
                        y: CGFloat.random(in: -1000...1000)
                    ))
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
    
    private var title: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            Text("\(viewModel.currentTheme.name)")
                .font(.title2)
        }
    }
    
    private var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    private var scoreBoard: some View {
        Text("Score: \(viewModel.score)")
            .font(.largeTitle)
            .animation(nil)
    }
    
    //MARK: Dealing from a Deck

    @State private var dealt = Set<Card.ID>()
    @Namespace private var dealingNamespace
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private let deckWidth: CGFloat = 50
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(viewModel: viewModel, card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            withAnimation {
                for card in viewModel.cards {
                    dealt.insert(card.id)
                }
            }
        }
    }
}

#Preview {
    ViewMemorizeGame(viewModel: EmojiMemorizeGame())
}

