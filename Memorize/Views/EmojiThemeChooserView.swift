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
                ForEach(store.themes, id: \EmojiMemoryGame.Theme.name) { theme in
                    NavigationLink(destination:
                        EmojiMemoryGameView(viewModel: EmojiMemoryGame(with: theme))
                            .navigationBarTitle(Text("\(theme.name)"))
                    ) {
                        ThemeRow(theme: theme)
                    }
                }
//                .onDelete { indexSet in
//                    indexSet.map { self.store.documents[$0] }.forEach { document in
//                        self.store.removeDocument(document)
//                    }
//                }
                
            }
            .navigationBarTitle(Text("Memorize"))
//            .navigationBarItems(
//                leading: EditButton(),
//                trailing: Button(
//                    action: { self.store.addDocument() },
//                    label: { Image(systemName: "plus").imageScale(.large) }
//                )
//            )
//            .listStyle(PlainListStyle())
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        
    }
}

struct EmojiThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiThemeChooserView().environmentObject(EmojiThemesStore())
    }
}

struct ThemeRow: View {
    
    var theme: EmojiMemoryGame.Theme
    
    var body: some View {
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
}
