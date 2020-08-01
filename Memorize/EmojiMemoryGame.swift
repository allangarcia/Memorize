//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Allan Garcia on 01/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

// Emoji is just a string, but renamed for clarity
typealias Emoji = String

// ViewModel
class EmojiMemoryGame {
    
    // Model
    private var game: MemoryGame<Emoji> = EmojiMemoryGame.makeMemoryGame()
    
    static func makeMemoryGame() -> MemoryGame<Emoji> {
        let emojis = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼",
                      "🐨","🐯","🐮","🐽","🐸","🐵","🐔","🐧",
            "🐦","🐤","🦆","🐥","🦉","🐴","🐝","🐛"].shuffled() // Extra credit change.
        let randomNumberOfPairs = Int.random(in: 2...5)

        return MemoryGame<Emoji>(numberOfPairOfCards: randomNumberOfPairs) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the model
    
    var cards: Array<MemoryGame<Emoji>.Card> {
        game.cards
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<Emoji>.Card) {
        game.choose(card: card)
    }
    
}
