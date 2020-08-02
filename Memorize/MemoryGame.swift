//
//  MemoryGame.swift
//  Memorize
//
//  Created by Allan Garcia on 01/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import Foundation

// Model wrapper
struct MemoryGame<CardContent> where CardContent: Equatable {
    
    var cards: Array<Card>
    
    var indexOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for idx in cards.indices {
                cards[idx].isFaceUp = idx == newValue
            }
        }
    }
    
    /*
     Conceptually the game plays as follows:
     
     1. Every card is face-down, then I want to face the touched card face up.
     2. There is only one card face-up, then I want to match over the card is face-up.
     3. Two cards is face up (matched or not), then I want to flip every card face-down
     except the one I just flipped.
     */
    
    mutating func choose(card: Card) {
        // print("Card chosen is: \(card)")
        if let matchingIndex = cards.firstIndex(matching: card),
            !cards[matchingIndex].isFaceUp,
            !cards[matchingIndex].isMatched {
            if let alreadyFaceUpCardIndex = indexOnlyFaceUpCard {
                if cards[matchingIndex].content == cards[alreadyFaceUpCardIndex].content {
                    cards[matchingIndex].isMatched = true
                    cards[alreadyFaceUpCardIndex].isMatched = true
                }
                cards[matchingIndex].isFaceUp = true
            } else {
                indexOnlyFaceUpCard = matchingIndex
            }
        }
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
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
    
}
