//
//  GraphView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 29/9/2025.
//

import Foundation
import Charts
import SwiftUI

/**
    This is a child view of **DatafieldView**, also a part of **LocationView**
    Receive from **DatafieldView**:
        - label == y-axis label
        - valueArray == array for the values of the air quality element
        - dateArray == array containing date and time of the forecast
        - color == color of the line graph
 */
struct GraphView: View {
    let label: String
    let dateArray: [Date]
    let valueArray: [Float]
    let color: Color
    
    
    var body: some View {
        //Use .map to connect each time and element data point in both array together and create a instance of GraphData
        let graphData = zip(dateArray, valueArray).map {
            GraphData(label: label, date: $0.0, value: Float($0.1))
        }
        
        //Create the line chart with x-axis = time and y-axis = value of element
        Chart(graphData) { point in
            LineMark(
                x: .value("Time", point.date),
                y: .value(label, point.value)
            )
        }
        .foregroundStyle(color)
        //Remove the values shown in the x-axis (needed due to UTC conflict with swift)
        .chartXAxis {
            AxisMarks(preset: .aligned) { _ in
                AxisGridLine()
                AxisTick()
            }
        }
        //Set label for x and y axis
        .chartXAxisLabel("Time of the day (00:00 to 23:00)", alignment: .center)
        .chartYAxisLabel("\(label)", position: .trailing, alignment: .center)
            .font(.caption)
            .padding(.leading, 8)
        .frame(maxWidth: .infinity, maxHeight: 300)
        .padding()
    }
}
