//
//  BeerSection.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 15/01/2021.
//

import Foundation

class Section: Codable, Equatable {
    let title: String
    var active: Bool = false
    
    internal init(title: String, active: Bool = false) {
        self.title = title
        self.active = active
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.title == rhs.title
    }
}
