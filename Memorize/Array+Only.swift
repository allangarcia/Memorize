//
//  Array+Only.swift
//  Memorize
//
//  Created by Allan Garcia on 02/08/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import Foundation

extension Array {
    
    var only: Element? {
        count == 1 ? first : nil
    }
    
}
