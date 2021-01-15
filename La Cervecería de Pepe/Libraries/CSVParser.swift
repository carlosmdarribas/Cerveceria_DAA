//
//  CSVParser.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 15/01/2021.
//

import Foundation

class CSVParser {
    // https://gist.github.com/algal/ceb17773bbc01e9b6bb1 actualizado.
    
    static func JSONObjectFromTSV(tsvInputString:String, columnNames optionalColumnNames:[String]? = nil) -> Data?
    {
        let lines = tsvInputString.components(separatedBy: "\n")
        guard lines.isEmpty == false else { return nil }
        
        let columnNames = optionalColumnNames ?? lines[0].components(separatedBy: "\t")
        var lineIndex = (optionalColumnNames != nil) ? 0 : 1
        let columnCount = columnNames.count
        var result = Array<NSDictionary>()
        
        for inline in lines[lineIndex ..< lines.count] {
            let line = inline.replacingOccurrences(of: "\n", with: "")
            
            let fieldValues = line.components(separatedBy: "\t")
            if fieldValues.count != columnCount {
                //      NSLog("WARNING: header has %u columns but line %u has %u columns. Ignoring this line", columnCount, lineIndex,fieldValues.count)
            } else {
                result.append(NSDictionary(objects: fieldValues, forKeys: columnNames as [NSCopying]))
            }
            
            lineIndex = lineIndex + 1
        }
        
        do {
            let jsonObject = try JSONSerialization.data(withJSONObject: result, options: .sortedKeys)
            return jsonObject
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
}
