//
//  Extensions.swift
//  InformationApp
//
//  Created by Kem on 11/14/22.
//

import Foundation

// MARK: - String
extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}

// MARK: - JSONEncoder
extension JSONEncoder {
    
    static func encode<T: Encodable>(from data: T, fileName: String, completion: (Bool) -> Void) {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let json = try jsonEncoder.encode(data)
            let jsonString = String(data: json, encoding: .utf8)
            
            // iOS/Mac: Save to the App's documents directory
            saveToDocumentDirectory(jsonString, fileName: fileName, completion: completion)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    static private func saveToDocumentDirectory(_ jsonString: String?, fileName: String, completion: (Bool) -> Void) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = path.appendingPathComponent(fileName)
        
        do {
            try jsonString?.write(to: fileURL, atomically: true, encoding: .utf8)
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
        
    }
}

// MARK: - JSONDecoder
extension JSONDecoder {
    static func decode(fileName: String, completion: (Data?) -> Void) {
        self.retrieveFromDocumentsDirectory(pathComponent: fileName) { retrievedData in
            guard let data = retrievedData else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    static private func retrieveFromDocumentsDirectory(pathComponent: String, _ completion: (Data?) -> Void) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = path.appendingPathComponent(pathComponent)
        do {
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            completion(data)
        } catch let error {
            print("parse error: \(error.localizedDescription)")
            completion(nil)
        }
    }
}
