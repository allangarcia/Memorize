//
//  EmojiThemesStore.swift
//  Memorize
//
//  Created by Allan Garcia on 26/11/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI
import Combine

class EmojiThemesStore: ObservableObject {
    
    let name: String

    @Published var themes = Array<EmojiMemoryGame.Theme>()
    
    private var autosave: AnyCancellable?
    
    init(named name: String = "Themes") {
        let defaultsKey = "Memorize.\(name)"

        self.name = name
        
        if let blob = UserDefaults.standard.object(forKey: defaultsKey) {
            self.themes = Array(fromPropertyList: blob)
        } else {
            self.themes = EmojiMemoryGame.defaultThemes
        }

        autosave = $themes.sink { themes in
            UserDefaults.standard.set(themes.asPropertyList, forKey: defaultsKey)
        }
    }

    func addRandomTheme() {
        if let theme = EmojiMemoryGame.defaultThemes.randomElement() {
            self.themes.append(theme)
        }
    }

}

extension Array where Element == EmojiMemoryGame.Theme {
    
    var asPropertyList: [Data] {
        self.map { element -> Data in
            element.json! // crash if can't get a json representation from theme struct
        }
    }
    
    init(fromPropertyList plist: Any?) {
        self.init()
        if let dataArray = plist as? [Data] {
            for data in dataArray {
                if let theme = EmojiMemoryGame.Theme(json: data) {
                    self.append(theme)
                }
            }
        }
    }
}

