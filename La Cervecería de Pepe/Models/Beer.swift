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
    var preferentialIngestion: String
    var cateNote: String
    var ibu: Int
    var alcohol: Float
    var imagePath: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, manufacturer, nationality, capacity, ibu, alcohol
        case preferentialIngestion = "preferential_ingestion"
        case cateNote = "cate_note"
        case imagePath = "image"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decode(ContainerType.self, forKey: .type)
        manufacturer = try values.decode(String.self, forKey: .manufacturer)
        nationality = try values.decode(String.self, forKey: .nationality)
        preferentialIngestion = try values.decode(String.self, forKey: .preferentialIngestion)
        cateNote = try values.decode(String.self, forKey: .cateNote)
        imagePath = try values.decode(String.self, forKey: .imagePath)
        
        var finalCapacity: Int = 0
        do {
            // Se intenta convertir de String a Int. En el caso de que no sea String y sea directamente Int, va a catch.
            if let capacityInt = Int(try values.decode(String.self, forKey: .capacity)) { finalCapacity = capacityInt }
        } catch {
            finalCapacity = try values.decode(Int.self, forKey: .capacity)
        }
        capacity = finalCapacity
        
        var finalAlcohol: Float = 0
        do {
            // Se intenta convertir de String a Int. En el caso de que no sea String y sea directamente Int, va a catch.
            if let alcoholInt = Float(try values.decode(String.self, forKey: .alcohol)) { finalAlcohol = alcoholInt }
        } catch {
            finalAlcohol = try values.decode(Float.self, forKey: .alcohol)
        }
        alcohol = finalAlcohol
        
        var finalIbu: Int = 0
        do {
            // Se intenta convertir de String a Int. En el caso de que no sea String y sea directamente Int, va a catch.
            if let ibuInt = Int(try values.decode(String.self, forKey: .ibu)) { finalIbu = ibuInt }
        } catch {
            finalIbu = try values.decode(Int.self, forKey: .ibu)
        }
        
        ibu = finalIbu
    }
    
    internal init(id: String, name: String, type: ContainerType, manufacturer: String, nationality: String, capacity: Int, preferentialIngestion: String, cateNote: String, ibu: Int, alcohol: Float, imagePath: String) {
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

extension Array where Element == Beer {
    func unique() -> [String] {
        var uniqueManufacturers = [String]()
        self.forEach({ if !uniqueManufacturers.contains($0.manufacturer) { uniqueManufacturers.append($0.manufacturer) } })
        
        return uniqueManufacturers
    }
}
