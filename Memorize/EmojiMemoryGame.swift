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
class EmojiMemoryGame: ObservableObject {
    
    // Struct for the theme
    
    struct Theme {
        var name: String
        var emojis: Array<Emoji>
        var color: Color
        var numberOfPairs: Int?
    }
    
    // Class helper methods and functions

    static var themes: Array<Theme> = {
        var themes = Array<Theme>()
        
        themes.append(Theme(name: "Animals",
                            emojis: ["🐶","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🐮",
                                     "🐸","🐵","🐔","🐧","🐦","🐤","🦆","🐥","🦉","🐴"],
                            color: Color.blue))
        
        themes.append(Theme(name: "Halloween",
                            emojis: ["⚰️","👻","💀","☠️","🎃","🧟‍♂️","🧛🏻‍♂️","🦇","🕷","🕸",
                                     "🔪","⚰️","🏺","🧹"],
                            color: Color.orange,
                            numberOfPairs: 6))
        
        themes.append(Theme(name: "Insects",
                            emojis: ["🐝","🐛","🐌","🦋","🐞","🐜","🦟","🦗","🦂"],
                            color: Color.gray,
                            numberOfPairs: 4))
        
        themes.append(Theme(name: "Professions",
                            emojis: ["👮🏾‍♀️","👷🏿‍♂️","🕵🏼","🧑🏾‍🌾","👨🏾‍🍳","🧑🏼‍🏫","👨🏻‍🏭","👨🏻‍💻","🧑🏽‍🔬","🧑🏾‍🚒",
                                     "👨🏼‍✈️","👩🏿‍🚀"],
                            color: Color.pink,
                            numberOfPairs: 6))
        
        themes.append(Theme(name: "Transports",
                            emojis: ["🚗","🚕","🚌","🛵","🚲","🚍","🏍","✈️","🚆","🚤"],
                            color: Color.yellow,
                            numberOfPairs: 4))
        
        themes.append(Theme(name: "Informatics",
                            emojis: ["⌚️","📱","💻","🖥","🖨","💽","💾","⌨️","🖲","📠",
                                     "🎙","🖱"],
                            color: Color.green,
                            numberOfPairs: 6))
        
        return themes
    }()
    
    // Model
    @Published private var game: MemoryGame<Emoji>!
    
    private(set) var theme: Theme
    
    func makeMemoryGame() -> MemoryGame<Emoji> {
        
        let emojis = self.theme.emojis.shuffled()
        
        let randomNumberOfPairs = self.theme.numberOfPairs ?? Int.random(in: 2...self.theme.emojis.count) // Conformance to hints
        // If theme has its size of pairs set.
        // Otherwise random behaviour
        
        return MemoryGame<Emoji>(numberOfPairOfCards: randomNumberOfPairs) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    init() {
        self.theme = EmojiMemoryGame.themes.randomElement() ?? EmojiMemoryGame.themes[0]
        self.game = self.makeMemoryGame()
    }
    
    // MARK: - Access to the model
    
    var cards: Array<MemoryGame<Emoji>.Card> {
        game.cards
    }
    
    var score: Int {
        game.score
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<Emoji>.Card) {
        game.choose(card: card)
    }
    
    func newGame() {
        if let theme = EmojiMemoryGame.themes.randomElement() {
            self.theme = theme
            self.game = self.makeMemoryGame()
        }
    }
    
}
