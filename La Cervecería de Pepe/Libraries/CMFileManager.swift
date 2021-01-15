//
//  CMFileManager.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 15/01/2021.
//

import Foundation

class CMFileManager {
    fileprivate static let binaryFile = "binaryData.bin"
    
    public static func saveToFile(beers: [Beer]) -> Bool {
        guard let dir = getDocumentsFolder() else {
            return false
        }
        
        
        let file = dir.appendingPathComponent(binaryFile)
        do {
            guard let encodedJSON = self.beersToJSONString(beers: beers) else {
                return false
            }
            
            let encoded = try NSKeyedArchiver.archivedData(withRootObject: encodedJSON, requiringSecureCoding: false)
            try encoded.write(to: file)
            
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    public static func getBeersFromFile() -> [Beer]? {
        guard let dir = getDocumentsFolder() else {
            return nil
        }
        
        let file = dir.appendingPathComponent(binaryFile)
        
        do {
            let beerData = try Data(contentsOf: file)
            
            //try NSKeyedUnarchiver.unarchivedObject(ofClass: Data, from: beerData)
            guard let beers = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(beerData) as? String else {
                return nil
            }
            
            return stringJSONToBeers(json: beers)
            
        } catch {
            print(error)
            return nil
        }
    }
    
    fileprivate static func getDocumentsFolder() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    fileprivate static func beersToJSONString(beers: [Beer]) -> String? {
        do {
            return String(data: try JSONEncoder().encode(beers), encoding: .utf8)
        } catch {
            print(error)
            return nil
        }
    }
    
    fileprivate static func stringJSONToBeers(json: String) -> [Beer]? {
        do {
            guard let data = json.data(using: .utf8) else {
                return nil
            }
            
            let beers = try JSONDecoder().decode([Beer].self, from: data)
            return beers
        } catch {
            print(error)
            return nil
        }
    }
}
