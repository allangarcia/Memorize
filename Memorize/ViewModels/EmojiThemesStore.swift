//
//  EmojiThemesStore.swift
//  Memorize
//
//  Created by Allan Garcia on 26/11/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

class EmojiThemesStore: ObservableObject {
    
    var themes: Array<EmojiMemoryGame.Theme>
    
    init() {
        self.themes = EmojiMemoryGame.themes
    }

}
