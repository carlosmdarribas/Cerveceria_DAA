//
//  Beer.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 13/01/2021.
//

import Foundation

class Beer: Codable {
    var id: String
    var name: String
    var type: ContainerType
    var manufacturer: String
    var nationality: String
    var capacity: Int
    var preferentialIngestion: Date
    var cateNote: String
    var ibu: String
    var alcohol: Int
    var imagePath: String
    
    
    internal init(id: String, name: String, type: ContainerType, manufacturer: String, nationality: String, capacity: Int, preferentialIngestion: Date, cateNote: String, ibu: String, alcohol: Int, imagePath: String) {
        self.id = id
        self.name = name
        self.type = type
        self.manufacturer = manufacturer
        self.nationality = nationality
        self.capacity = capacity
        self.preferentialIngestion = preferentialIngestion
        self.cateNote = cateNote
        self.ibu = ibu
        self.alcohol = alcohol
        self.imagePath = imagePath
    }
}


enum ContainerType: String, Codable {
    case bottle = "Botella", can = "Lata", other = "Otro"
}
