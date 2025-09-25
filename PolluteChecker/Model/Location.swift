//
//  Location.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//


import Foundation


// This will be used for saving favourite location
struct Location: Codable, Identifiable {
    let id: UUID
    let locationName: String
    let lan: Double
    let lon: Double
}
