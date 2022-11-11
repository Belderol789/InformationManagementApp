//
//  Company.swift
//  InformationApp
//
//  Created by Kem on 11/11/22.
//

import Foundation

struct Company: Codable {
    let id: String
    let name: String
    let employees: [Employee]
}
