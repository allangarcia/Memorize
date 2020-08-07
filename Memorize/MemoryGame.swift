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
    
    private(set) var score: Int = 0

    // Extra Credit - Timely score
    private var timeOfTheLastChoose: Date = Date()
    // Extra Credit - Timely score
    private var secondsSinceLastChoose: Int {
        abs(Int(self.timeOfTheLastChoose.timeIntervalSinceNow))
    }
    
    private(set) var cards: Array<Card>
    
    private var indexOnlyFaceUpCard: Int? {
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
                    // score += 2
                    score += 2 * max(10 - secondsSinceLastChoose, 1) // Extra Credit - Timely score
                    self.timeOfTheLastChoose = Date() // Extra Credit - Timely score
                } else {
                    /*
                     The logic is:
                     1. I'm only decreacing points after seeing both cards and they not match so
                        is the else case for the if that actually matches two cards and summup 2 points
                     2. Then I have to look through all cards that are not yet matched but already seen
                        and mismatched and compare with the two faceup cards that is not currently being
                        matched if I found any correspondence then I have to penalize -1 point for each.
                     */
                    let cardsFiltered = cards.filter { $0.wasSeen && !$0.isMatched }
                    for card in cardsFiltered {
                        if card.content == cards[alreadyFaceUpCardIndex].content || card.content == cards[matchingIndex].content {
                            // score -= 1
                            score -= 1 * min(1 + secondsSinceLastChoose, 10) // Extra Credit - Timely score
                            self.timeOfTheLastChoose = Date() // Extra Credit - Timely score
                        }
                    }
                    cards[alreadyFaceUpCardIndex].wasSeen = true
                    cards[matchingIndex].wasSeen = true
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
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var wasSeen: Bool = false
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        /*
         This was typed-in code from the video (Lecture 6)
         */
        
        // this could give matching points bonus
        // if the user matches the card
        // before a certain amount of time passes during which card if face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if its currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
    
}
