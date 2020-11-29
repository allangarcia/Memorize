//
//  EmojiThemeChooserView.swift
//  Memorize
//
//  Created by Allan Garcia on 26/11/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

struct EmojiThemeChooserView: View {
    
    @EnvironmentObject var store: EmojiThemesStore
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination:
                        EmojiMemoryGameView(viewModel: EmojiMemoryGame(with: theme))
                            .navigationBarTitle(Text("\(theme.name)"))
                    ) {
                        ThemeRow(theme: theme, editMode: $editMode)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { self.store.themes.remove(at: $0) }
                }
            }
            .navigationBarTitle(Text("Memorize"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(
                    action: { self.store.addRandomTheme() },
                    label: { Image(systemName: "plus").imageScale(.large) }
                )
            )
            .listStyle(PlainListStyle())
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ThemeRow: View {
    
    @EnvironmentObject var store: EmojiThemesStore
    
    var theme: EmojiMemoryGame.Theme
    @Binding var editMode: EditMode
    
    @State private var isEditingTheme: Bool = false
    
    var body: some View {
        HStack {
            Group {
                if editMode == .active {
                    Image(systemName: "pencil.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.yellow)
                        .padding(.trailing, 8)
                        .onTapGesture {
                            self.isEditingTheme = true
                        }
                }
            }
            VStack {
                HStack {
                    Text("\(theme.name)")
                        .font(.title)
                        .foregroundColor(Color(theme.color))
                    Spacer()
                    Text("\(theme.numberOfPairs) Pairs")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("\(theme.emojis.joined())")
                        .lineLimit(1)
                        .font(.title)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: self.$isEditingTheme, onDismiss: {
            self.editMode = .inactive
        }, content: {
            EmojiThemeEditorView(theme: theme, isShowing: $isEditingTheme)
                .environmentObject(self.store)
        })
    }
}
