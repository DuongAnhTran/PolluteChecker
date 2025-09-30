//
//  GraphData.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 29/9/2025.
//

import Foundation
import Charts

// This Model presents a Data Point in a graph, which will be used for graphing
/**
    Include:
        - A separate id for each data point
        - The label for the datapoint (this is the graph's label)
        - The date data
        - The value data corresponding to the date
**/
struct GraphData: Identifiable {
    var id = UUID()
    var label: String
    var date: Date
    var value: Float
}
