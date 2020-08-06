//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Allan Garcia on 31/07/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.theme.name)
                    .font(Font.title)
            }
            Divider()
            Grid(viewModel.cards) { card in
                CardView(card: card)
                    // .aspectRatio(2/3, contentMode: .fit) -- removed due to GridLayout thing
                    .onTapGesture {
                        self.viewModel.choose(card: card)
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(viewModel.theme.color)
            .accentColor(viewModel.theme.color)
            Divider()
            HStack {
                Text("Score: \(viewModel.score)").font(Font.headline)
                Spacer()
                Button(action: viewModel.newGame) { Text("New Game") }
            }
            .padding()
        }
    }
    
}

struct CardView: View {
    
    var card: MemoryGame<Emoji>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Pie(startAngle: Angle.degrees(0-90),
                    endAngle: Angle.degrees(110-90),
                    clockwise: true)
                    .padding(5)
                    .opacity(0.4)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(gradient:
                                Gradient(colors:
                                    [Color.accentColor.opacity(0.8),
                                     Color.accentColor.opacity(0.2)]
                                ),
                                           startPoint: .top,
                                           endPoint: .bottom
                            )
                    )
                }
            }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    // MARK: - Drawing constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.6
    }
    
}






















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
