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
    
    // I'm leaving Theme and themes public (not private)
    // becouse someone outside this class could create a new
    // theme for this game and set the array
    
    struct Theme {
        var name: String
        var emojis: Array<Emoji>
        var color: Color
        var numberOfPairs: Int
    }
    
    // Class helper methods and functions

    static var themes: Array<Theme> = {
        var themes = Array<Theme>()
        
        themes.append(Theme(name: "Animals",
                            emojis: ["🐶","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🐮",
                                     "🐸","🐵","🐔","🐧","🐦","🐤","🦆","🐥","🦉","🐴"],
                            color: Color.blue,
                            numberOfPairs: 10))
        
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
    
    private func makeMemoryGame() -> MemoryGame<Emoji> {
        
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
        // TODO: - Make external theme be importable to this game.
        if let theme = EmojiMemoryGame.themes.randomElement() {
            self.theme = theme
            self.game = self.makeMemoryGame()
        }
    }
    
}
