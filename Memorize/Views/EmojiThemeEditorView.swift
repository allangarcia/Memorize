//
//  EmojiThemeEditorView.swift
//  Memorize
//
//  Created by Allan Garcia on 27/11/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

struct EmojiThemeEditorView: View {
    
    @EnvironmentObject var store: EmojiThemesStore
    
    @State var theme: EmojiMemoryGame.Theme
    @Binding var isShowing: Bool
    
    @State private var themeName: String = ""
    @State private var emojisToAdd: String = ""
    @State private var numberOfPairs: Int = -1
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Theme Editor")
                    .font(.headline)
                    .padding()
                HStack {
                    Button(
                        action: { self.isShowing = false },
                        label: { Text("Cancel") }
                    )
                    .padding()
                    Spacer()
                    Button(
                        action: {
                            self.save()
                            self.isShowing = false
                        },
                        label: { Text("Done") }
                    )
                    .padding()
                }
            }
            Divider()
            Form {
                Section(header: Text("Theme Name")) {
                    TextField("Theme Name", text: $themeName)
                }
                Section(header: Text("Add Emoji")) {
                    HStack {
                        TextField("Add Emoji", text: $emojisToAdd)
                        Button {
                            self.addEmojisLocal()
                        } label: {
                            Text("Add")
                        }
                    }
                }
                Section(
                    header: Text("Tap to remove an emoji from the theme")) {
                    Grid(self.theme.emojis.map { String($0) }, id: \.self ) { emoji in
                        Text(emoji).font(Font.system(size: 40))
                            .onTapGesture {
                                if self.theme.emojis.count > 2 {
                                    if let index = self.theme.emojis.firstIndex(of: emoji) {
                                        self.theme.emojis.remove(at: index)
                                        if self.numberOfPairs > self.theme.emojis.count {
                                            self.numberOfPairs = self.theme.emojis.count
                                        }
                                    }
                                }
                            }
                    }
                    .frame(height: self.height)
                }
                Section(header: Text("Number of pairs of cards")) {
                    Stepper("\(self.numberOfPairs) Pairs", value: self.$numberOfPairs, in: 2...self.theme.emojis.count)
                }
//                Section {
//                    Text("Color of the theme")
//                }
            }
        }
        .onAppear {
            self.themeName = self.theme.name
            self.numberOfPairs = self.theme.numberOfPairs
        }
    }
    
    private func addEmojisLocal() {
        // save emojis added
        self.emojisToAdd.forEach { emoji in
            let emojiString = String(emoji)
            if let index = self.theme.emojis.firstIndex(of: emojiString) {
                self.theme.emojis.remove(at: index)
            }
            self.theme.emojis.append(emojiString)
        }
        self.emojisToAdd = ""
    }
    
    private func save() {
        
        // save the name
        self.theme.name = self.themeName
        
        // save the numbers of pairs of the game
        self.theme.numberOfPairs = self.numberOfPairs

        // find in store the theme being edited
        if let index = self.store.themes.firstIndex(matching: self.theme) {
            self.store.themes[index] = self.theme
        }
    }
    
    private var height: CGFloat {
        CGFloat((self.theme.emojis.count - 1) / 6) * 70 + 70
    }

}
