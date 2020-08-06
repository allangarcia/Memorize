//
//  Cardify.swift
//  Memorize
//
//  Created by Allan Garcia on 06/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.8),
                                                                     Color.accentColor.opacity(0.2)]),
                                         startPoint: .top,
                                         endPoint: .bottom))
            }
        }
    }
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
