//
//  GraphData.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 29/9/2025.
//

import Foundation
import Charts

struct GraphData: Identifiable {
    var id = UUID()
    var dataTypes: String
    var date: Date
    var value: Float
}
