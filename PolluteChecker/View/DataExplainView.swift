//
//  DataExplainView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 1/10/2025.
//

import SwiftUI
import Foundation

struct DataExplainView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Divider()
                    Text("All data displayed for the air quality forecast of the chosen location is taken from the [Open Meteo API](https://open-meteo.com/en/docs/air-quality-api).")
                    Text("Each component of air quality will be classified as: **Good**, **Fair**, **Poor**, **Very Poor** and **Extremely Poor**.")
                    
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 30) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(.green))
                            
                            Text("This indicates safe amount of a certain element in the air, which is suitable for outside activities")
                                .frame(maxWidth: 300)
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(spacing: 30) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(.yellow))
                            
                            Text("This indicates a moderate amount of a certain element in the air, which is fairly suitable for outdoor activities")
                                .frame(maxWidth: 300)
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(spacing: 30) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(.orange))
                            
                            Text("This indicates a moderate/high amount of a certain element in the air, outdoor activities need to be carefully considered")
                                .frame(maxWidth: 300)
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(spacing: 30) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(.red))
                            
                            Text("Thjis indicates a high amount of certain element in the air. Outdoor activities should be avoided")
                                .frame(maxWidth: 300)
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(spacing: 30) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(.brown))
                            
                            Text("This indicates extremely high amount of a certain element in the air, outdoor activities are dangerous. Prtotection are needed when outdie")
                                .frame(maxWidth: 300)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 5)
                }
                
                
                VStack {
                    Spacer()
                    Text("This is an explaination for the air quality prediction data")
                }
                .frame(maxHeight: 70)
            }
            .navigationTitle("Data Explanation")
        }
    }
}


#Preview {
    DataExplainView()
}
