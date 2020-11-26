//
//  Data+UTF8.swift
//  Memorize
//
//  Created by Allan Garcia on 18/11/2020.
//  Copyright © 2020 Allan Garcia. All rights reserved.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
