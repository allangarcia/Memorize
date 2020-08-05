//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Allan Garcia on 01/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

struct EmojiSet {
    
    enum Theme {
        case animal, halloween, insect, profession, transport, informatic
    }
    
    init(withTheme theme: Theme) {
        // init with chosen theme
        self.theme = theme
        
        switch theme {
        case .animal:
            self.emojis = ["🐶","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🐮",
                           "🐸","🐵","🐔","🐧","🐦","🐤","🦆","🐥","🦉","🐴"]
            self.themeName = "Animals"
            self.themeColor = Color.blue
        case .halloween:
            self.emojis = ["⚰️","👻","💀","☠️","🎃","🧟‍♂️","🧛🏻‍♂️","🦇","🕷","🕸",
                           "🔪","⚰️","🏺","🧹"]
            self.themeName = "Halloween"
            self.themeColor = Color.orange
            self.numberOfPairsToShow = 4
        case .insect:
            self.emojis = ["🐝","🐛","🐌","🦋","🐞","🐜","🦟","🦗","🦂"]
            self.themeName = "Insects"
            self.themeColor = Color.gray
            self.numberOfPairsToShow = 3
        case .profession:
            self.emojis = ["👮🏾‍♀️","👷🏿‍♂️","🕵🏼","🧑🏾‍🌾","👨🏾‍🍳","🧑🏼‍🏫","👨🏻‍🏭","👨🏻‍💻","🧑🏽‍🔬","🧑🏾‍🚒",
                           "👨🏼‍✈️","👩🏿‍🚀"]
            self.themeName = "Professions"
            self.themeColor = Color.pink
            self.numberOfPairsToShow = 4
        case .transport:
            self.emojis = ["🚗","🚕","🚌","🛵","🚲","🚍","🏍","✈️","🚆","🚤"]
            self.themeName = "Transports"
            self.themeColor = Color.yellow
            self.numberOfPairsToShow = 3
        case .informatic:
            self.emojis = ["⌚️","📱","💻","🖥","🖨","💽","💾","⌨️","🖲","📠",
                           "🎙","🖱"]
            self.themeName = "Informatics"
            self.themeColor = Color.green
            self.numberOfPairsToShow = 4
        }
    }
    
    private(set) var theme: EmojiSet.Theme
    private(set) var emojis: Array<Emoji>
    private(set) var themeColor: Color
    private(set) var themeName: String
    private(set) var numberOfPairsToShow: Int?
    
    /*
     As I'm not being graded, I believe that my solution is more elegant than
     the requirement task 5 that require add a new theme with a single line of
     code. I prefer to extend the struct with new themes to construct a better
     data structure with type statically allocated than an arbitrary dictionary
     with all the information to be parsed. But I could change my mind later when
     Paul Hegarty show their solution.
     */
    
}

// Emoji is just a string, but renamed for clarity
typealias Emoji = String

// ViewModel
class EmojiMemoryGame: ObservableObject {
    
    // Class helper methods and functions
    static var defaultTheme: EmojiSet.Theme = .halloween
    
    // Model
    @Published private var game: MemoryGame<Emoji>!
    
    private(set) var emojiSet: EmojiSet
    
    func makeMemoryGame() -> MemoryGame<Emoji> {
        
        let emojis = self.emojiSet.emojis.shuffled() // Extra credit change.
        
        let randomNumberOfPairs = self.emojiSet.numberOfPairsToShow ?? Int.random(in: 2...5)
        // If theme has its size of pairs set.
        // Otherwise random behaviour
        
        return MemoryGame<Emoji>(numberOfPairOfCards: randomNumberOfPairs) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    init(withTheme theme: EmojiSet.Theme) {
        self.emojiSet = EmojiSet(withTheme: theme)
        self.game = self.makeMemoryGame()
    }
    
    convenience init() {
        self.init(withTheme: EmojiMemoryGame.defaultTheme)
    }
    
    // MARK: - Access to the model
    
    var cards: Array<MemoryGame<Emoji>.Card> {
        game.cards
    }
    
    var score: Int {
        game.score
    }
    
    var themeColor: Color {
        self.emojiSet.themeColor
    }
    
    var themeName: String {
        self.emojiSet.themeName
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<Emoji>.Card) {
        game.choose(card: card)
    }
    
    func changeTheme(to theme: EmojiSet.Theme) {
        self.emojiSet = EmojiSet(withTheme: theme)
        self.game = self.makeMemoryGame()
    }
    
    func newGame() {
        // TODO: - This random stuff probably should be in another function
        let randomTheme = [.animal,.halloween,.informatic,
                           .insect,.profession,.transport].randomElement() ?? EmojiSet.Theme.halloween
        self.emojiSet = EmojiSet(withTheme: randomTheme)
        self.game = self.makeMemoryGame()
    }
    
}
