//
//  MemoryGame.swift
//  Memorize
//
//  Created by Allan Garcia on 01/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import Foundation

// Model wrapper
struct MemoryGame<CardContent> {
    
    var cards: Array<Card>
    
    func choose(card: Card) {
        print("Card chosen is: \(card)")
    }
    
    init(numberOfPairOfCards: Int, makeCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairOfCards {
            let content = makeCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle() // Shuffles inline
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
    
}
