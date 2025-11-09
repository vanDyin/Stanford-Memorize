//
//  ViewMemorizeGame.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 11.07.2025.
//

import SwiftUI

struct ViewMemorizeGame: View {
    typealias Card = ModelMemorizeGame<String>.Card
    
    var viewModel: EmojiMemorizeGame
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 2
    private let deckWidth: CGFloat = 50
    private let dealInterval: TimeInterval = 0.15
    private let dealAnimation: Animation = .easeIn(duration: 0.5)
    
    var body: some View {
        VStack {
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
        .navigationTitle(viewModel.theme.name)
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(viewModel: viewModel, card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
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
    
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(viewModel: viewModel, card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
}

#Preview {
    ViewMemorizeGame(viewModel: EmojiMemorizeGame(theme: ThemeStore().themes.first!))
}

