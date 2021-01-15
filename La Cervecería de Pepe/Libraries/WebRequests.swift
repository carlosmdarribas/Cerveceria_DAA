//
//  WebRequests.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 15/01/2021.
//

import Foundation
import Alamofire

class WebRequests {
    static let http: String = "http://" // Tambien puede ser https. Dependerá de servidor.
    static var cotiServerIP:String = http + "maxus.fis.usal.es/HOTHOUSE/daa/2020beer/"
    static var cotiPicturesPath:String = cotiServerIP + "fotos/"
    
    static var backServerIP:String = http + "192.168.8.6:5000/beer/v1/beer/"
    static var backServerPicturesPath:String = backServerIP + "fotos/"
    
    static func updateBeers(completion: @escaping ([Beer]) -> Void) {
         // Con la intención de hacer asíncronos ambos miembros, pero esperar a su ejecución completa para llamar al callback, se inician dispatgroups.
        let taskGroup = DispatchGroup()
        taskGroup.enter()
        
        var beerCollection = [Beer]()
    
        updateBeersFromCotiCSV { (beers) in
            beerCollection += beers
            taskGroup.leave()
        } fail: { (error) in
            print(error)
            taskGroup.leave()
        }
        
        taskGroup.enter()
        updateBeers { (beers) in
            beerCollection += beers
            taskGroup.leave()
            
        } fail: { (error) in
            print(error)
            taskGroup.leave()
        }
        
        taskGroup.notify(queue: .main) {
            completion(beerCollection)
        }

    }
    
    private static func updateBeers(completion: @escaping ([Beer]) -> Void, fail: @escaping (_ error: String) -> Void) {
        let url = backServerIP + "all"
        
        Alamofire.request(url).responseData { (data) in
            guard let responseData = data.data else {
                print("Error receiving from server")
                return
            }
            
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: responseData)
                completion(beers)
            } catch {
                print(error)
                return
            }
        }
    }
    
    private static func updateBeersFromCotiCSV(completion: @escaping ([Beer]) -> Void, fail: @escaping (_ error: String) -> Void) {
        let url = cotiServerIP + "defaultbeer.csv"
        
        Alamofire.request(url).responseString { (response) in
            guard let csvString = response.result.value else {
                fail("Error getting result")
                return
            }
            
            guard let jsonObject = CSVParser.JSONObjectFromTSV(tsvInputString: csvString, columnNames: ["name", "type", "manufacturer", "nationality", "capacity", "preferential_ingestion", "cate_note", "id", "ibu", "alcohol", "image"]) else {
                fail("Error parsing CSV to JSON")
                return
            }
            
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: jsonObject)
                beers.forEach({$0.imagePath = cotiPicturesPath + $0.imagePath})
                
                completion(beers)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        
    }
}
