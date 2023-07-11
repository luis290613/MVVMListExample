//
//  Extensiones.swift
//  MVVMExample
//
//  Created by Luis Diego Ruiz Bautista on 10/07/23.
//

import Foundation


extension Encodable {
    func encode(using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Data {
    var prettyPrintedJSONString: NSString {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject,
                                                       options: [.prettyPrinted]),
              let prettyJSON = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                  return ""
               }

        return prettyJSON
    }
    
    func decode<T: Decodable>(as type: T.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(type, from: self)
    }
    
    func toString(encoding: String.Encoding = .utf8) -> String {
        return String(data: self, encoding: encoding) ?? ""
    }

}
