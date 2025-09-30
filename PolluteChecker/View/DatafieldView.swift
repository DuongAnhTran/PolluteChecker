//
//  DatafieldView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 30/9/2025.
//

import SwiftUI
import Foundation
import Charts

struct DatafieldView: View {
    @Binding var valueArray: [Float]
    @Binding var dateArray: [Date]
    var dataTitle: String
    var graphTitle: String
    var label: String
    var color: Color
    
    var body: some View {
        VStack {
            Divider()
            
            Text("\(dataTitle)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 1)
                .font(.title2)
                .bold()
            
            VStack {
                HStack {
                    HStack(spacing: 0.1) {
                        Text("Min Value: ")
                            
                        Text("\(String(format: "%.2f", minValue(array: valueArray)))")
                            .bold()
                    }
                    
                    Divider()
                    
                    
                    Text("Starts at: \(minTime(valueArray: valueArray, dateArray: dateArray))")
                }
                
                HStack {
                    HStack(spacing: 0.1) {
                        Text("Max Value: ")
                        
                        Text("\(String(format: "%.2f", maxValue(array: valueArray)))")
                            .bold()
                    }
                    Divider()
                    
                    Text("Starts at: \(maxTime(valueArray: valueArray, dateArray: dateArray))")
                }
            }
            .padding(.bottom)
            
            Text("\(graphTitle)")
                .font(.subheadline)
            
            GraphView(label: label, dateArray: dateArray, valueArray: valueArray, color: color)
        }
    }
    
    func minValue(array: [Float]) -> Float {
        return array.min() ?? 0
    }
    
    func maxValue(array: [Float]) -> Float {
        return array.max() ?? 0
    }
    
    func maxTime(valueArray: [Float], dateArray: [Date]) -> String {
        guard let index = valueArray.enumerated().max(by: { $0.element < $1.element })?.offset else {
            return ""
        }
        return formatting(dateArray[index])
    }
    
    func minTime(valueArray: [Float], dateArray: [Date]) -> String {
        guard let index = valueArray.enumerated().min(by: { $0.element < $1.element })?.offset else {
            return ""
        }
        return formatting(dateArray[index])
    }
    
    func formatting(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
    
}
