//
//  GraphView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 29/9/2025.
//

import Foundation
import Charts
import SwiftUI

struct GraphView: View {
    let label: String
    let dateArray: [Date]
    let valueArray: [Float]
    
    
    var body: some View {
        let graphData = zip(dateArray, valueArray).map {
            GraphData(dataTypes: label, date: $0.0, value: Float($0.1))
        }
        Chart(graphData) { point in
            LineMark(
                x: .value("Time", point.date),
                y: .value(label, point.value)
            )
        }
        .chartXAxis {
            AxisMarks(preset: .aligned) { _ in
                AxisGridLine()
                AxisTick()
            }
        }
        .chartXAxisLabel("Time of the day (00:00 to 23:00)", alignment: .center)
        .chartYAxisLabel("\(label)", position: .trailing, alignment: .center)
            .font(.caption)
            .padding(.leading, 8)
        .frame(maxWidth: .infinity, maxHeight: 300)
        .padding()
        
    }
}
