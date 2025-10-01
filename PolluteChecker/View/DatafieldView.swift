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
                            
                        Text("\(String(format: "%.2f", minValue(array: valueArray))) \(label)")
                            .bold()
                            .padding(.trailing, 2)
                        
                        Image(systemName: "circle.fill")
                            .foregroundStyle(categorise(dataTitle: dataTitle, value: minValue(array: valueArray)))
                    }
                    Divider()
                    Text("Starts at: \(minTime(valueArray: valueArray, dateArray: dateArray))")
                }
                
                HStack {
                    HStack(spacing: 0.1) {
                        Text("Max Value: ")
                        
                        Text("\(String(format: "%.2f", maxValue(array: valueArray))) \(label)")
                            .bold()
                            .padding(.trailing, 2)
                        
                        Image(systemName: "circle.fill")
                            .foregroundStyle(categorise(dataTitle: dataTitle, value: maxValue(array: valueArray)))
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
    
    
    //Extra function:
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
    
    func categorise(dataTitle: String, value: Float) -> Color{
        switch dataTitle {
            case "PM 2.5":
                if value < 25 {
                    return Color.green
                } else if (value >= 25 && value < 50) {
                    return Color.yellow
                } else if (value >= 50 && value < 100) {
                    return Color.orange
                } else if (value >= 100 && value < 300) {
                    return Color.red
                } else {
                    return Color.brown
                }
                
            case "Carbon Monoxide (CO)":
            if value <= 6900 {
                    return Color.green
                } else if (value > 6900 && value <= 10350) {
                    return Color.yellow
                } else if (value > 10350 && value <= 15525) {
                    return Color.orange
                } else if (value > 15525 && value <= 20700) {
                    return Color.red
                } else {
                    return Color.brown
                }
                
            case "Carbon Dioxide (CO₂)":
                if value <= 1000 {
                    return Color.green
                } else if (value > 1000 && value <= 2000) {
                    return Color.yellow
                } else if (value > 2000 && value <= 5000) {
                    return Color.orange
                } else if (value > 5000 && value <= 30000) {
                    return Color.red
                } else {
                    return Color.brown
                }
                
            case "Nitrogen Dioxide (NO₂)":
                if value < 101 {
                    return Color.green
                } else if (value >= 101 && value <= 150) {
                    return Color.yellow
                } else if (value > 150 && value <= 225) {
                    return Color.orange
                } else if (value > 225 && value <= 300) {
                    return Color.red
                } else {
                    return Color.brown
                }
                
            case "Sulphur Dioxide (SO₂)":
                if value < 134 {
                    return Color.green
                } else if (value >= 134 && value <= 200) {
                    return Color.yellow
                } else if (value > 200 && value <= 300) {
                    return Color.orange
                } else if (value > 300 && value <= 400) {
                    return Color.red
                } else {
                    return Color.brown
                }
                
            case "Ozone (O₃)":
                if value < 134 {
                    return Color.green
                } else if (value >= 134 && value <= 200) {
                    return Color.yellow
                } else if (value > 200 && value <= 300) {
                    return Color.orange
                } else if (value > 300 && value <= 400) {
                    return Color.red
                } else {
                    return Color.brown
                }
                
            case "PM 10":
            if value < 50 {
                return Color.green
            } else if (value >= 50 && value <= 100) {
                return Color.yellow
            } else if (value > 100 && value <= 200) {
                return Color.orange
            } else if (value > 200 && value <= 600) {
                return Color.red
            } else {
                return Color.brown
            }
                
        default:
            return Color.black
        }
    }
    
}
