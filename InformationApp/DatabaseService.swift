//
//  DatabaseService.swift
//  InformationApp
//
//  Created by Kem on 11/11/22.
//

import Foundation

public final class DatabaseService {
    
    // MARK: - Convert JSON to Model
    func convertJSONStringToModel<T: Decodable>(of type: T.Type = T.self, jsonString: String, completion: @escaping (Result<T, Error>) -> Void) {
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        
        do {
            let codable = try decoder.decode(T.self, from: jsonData)
            completion(.success(codable))
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Convert Model to JSON
    func convertModelToJSON<T: Codable>(model: T, completed: (String?) -> Void) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(model)
            let json = String(data: jsonData, encoding: String.Encoding.utf16)
            completed(json)
        } catch {
            completed(nil)
        }
    }
    
    // MARK: - Save Company Detail
    func saveModelDetails<T: Codable>(_ model: T, identifier: String, completion: (Bool?) -> Void) {
        self.convertModelToJSON(model: model) { json in
            guard json != nil else {
                completion(nil)
                return
            }
            UserDefaults.standard.setValue(json, forKey: identifier)
            completion(true)
        }
    }
}
