//
//  DatabaseService.swift
//  InformationApp
//
//  Created by Kem on 11/11/22.
//

import Foundation

public final class DatabaseService {
    
    // MARK: - Convert JSONString to Model
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

    // MARK: - Save Company Detail
    func saveModelDetails<T: Codable>(_ model: T, fileName: String, completion: (Bool) -> Void) {
        JSONEncoder.encode(from: model, fileName: fileName, completion: completion)
    }
    
    // MARK: - Retrieve Companies
    func retrieveModelFromFile<T: Codable>(of type: T.Type = T.self, fileName: String, _ completion: @escaping (Result<T, Error>) -> Void) {
        JSONDecoder.decode(fileName: fileName) { data in
            guard let fileData = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodable = try decoder.decode(T.self, from: fileData)
                completion(.success(decodable))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
