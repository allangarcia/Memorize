//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Allan Garcia on 02/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    
    func firstIndex(matching: Element) -> Int? {
        for idx in 0..<self.count {
            if self[idx].id == matching.id {
                return idx
            }
        }
        return nil
    }
    
}
