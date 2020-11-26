//
//  Grid.swift
//  Memorize
//
//  Created by Allan Garcia on 02/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

struct Grid<Item, itemView>: View where Item: Identifiable, itemView: View {
    
    private var items: Array<Item>
    private var viewForItem: (Item) -> itemView
    
    init(_ items: Array<Item>, viewForItem: @escaping (Item) -> itemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            self.body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width,
                   height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
    
}
