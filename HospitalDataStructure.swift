//
//  HospitalDataStructure.swift
//  SudoSui
//
//  Created by lingxinchen on 4/26/22.
//

import Foundation

struct HospitalDataStructure: Codable {
    let results: [Results]
}

struct Results: Codable {
    let poi: Poi
    let address: Address
}

struct Poi: Codable {
    let name: String
    let phone: String?
    let url: String?
}

struct Address: Codable {
    let freeformAddress: String
}
