//
//  DatafieldView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 30/9/2025.
//

import SwiftUI
import Foundation
import Charts

///This view is a childView of **LocationView** that shows the forecasted information of the air quality
///Will be called multiple time for multiple air quality element of the forecast
/**
    Receive from LocationView:
        - Data array for each air quality element (CO2, SO2, etc)
        - The array of time (Contains time from 00:00 to 23:00)
        - dataTitle == Name of the current element
        - graphTitle == title of the line graph
        - label == label of the y-axis (x-axis label is the same for every graph)
        - color == color for the line in line graph
 */
struct DatafieldView: View {
    @Binding var valueArray: [Float]
    @Binding var dateArray: [Date]
    var dataTitle: String
    var graphTitle: String
    var label: String
    var color: Color
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            Divider()
            //Title for each of the air element
            HStack(spacing: 10) {
                Text("\(dataTitle): Avg: \(String(format: "%.2f", averageValue(array: valueArray)))")
                    .font(.title3)
                    .bold()
                
                Image(systemName: "circle.fill")
                    .foregroundStyle(categorise(dataTitle: dataTitle, value: averageValue(array: valueArray)))
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //Min and max value of the element and what time does this occur
            VStack {
                //Min value and time occur
                HStack {
                    HStack(spacing: 0.1) {
                        Text("Min Value: ")
                            
                        Text("\(String(format: "%.2f", minValue(array: valueArray))) \(label)")
                            .bold()
                            .padding(.trailing, 2)
                        
                        //A colored circle indicating the safetiness of the element's value to human health
                        Image(systemName: "circle.fill")
                            .foregroundStyle(categorise(dataTitle: dataTitle, value: minValue(array: valueArray)))
                    }
                    Divider()
                    Text("Starts at: \(minTime(valueArray: valueArray, dateArray: dateArray))")
                }
                
                //Max value and time occur
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
            
            //Graph title and graph (will have indicator when loading)
            Text("\(graphTitle)")
                .font(.subheadline)
            
            if !isLoading {
                GraphView(label: label, dateArray: dateArray, valueArray: valueArray, color: color)
            } else {
                Text("**Loading...**")
            }
        }
    }
    
    
    //Extra function section:
    //Find min value
    func minValue(array: [Float]) -> Float {
        return array.min() ?? 0
    }
    
    //Find max value
    func maxValue(array: [Float]) -> Float {
        return array.max() ?? 0
    }
    
    //Find average value
    func averageValue(array: [Float]) -> Float {
        return array.reduce(0, +) / Float(array.count)
    }
    
    //Find time when max value occur
    func maxTime(valueArray: [Float], dateArray: [Date]) -> String {
        guard let index = valueArray.enumerated().max(by: { $0.element < $1.element })?.offset else {
            return ""
        }
        return formatting(dateArray[index])
    }
    
    //Find time when min value occur
    func minTime(valueArray: [Float], dateArray: [Date]) -> String {
        guard let index = valueArray.enumerated().min(by: { $0.element < $1.element })?.offset else {
            return ""
        }
        return formatting(dateArray[index])
    }
    
    //Format for date to show time in HH:mm format
    func formatting(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
    
    
    /*A function to manually categorise data based on information from:
        (https://www.co2meter.com/en-au/blogs/news/carbon-dioxide-indoor-levels-chart?srsltid=AfmBOorbhDCjzRIA-vT0CbPk4djeLpNS0KyCKH-zV_ackgMONl8W3Bwy)
        AND
        (https://www.airquality.nsw.gov.au/health-advice/air-quality-categories)
     */
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
