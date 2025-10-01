//
//  DataExplainView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 1/10/2025.
//

import SwiftUI
import Foundation

//This view is mainly instruction, information on the app and extra information explanation for data thresholding in this app
struct DataExplainView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Divider()
                    //App instruction starts here
                    Text("App Instruction")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 30) {
                            Image(systemName: "magnifyingglass")
                                .symbolEffect(.bounce.up.wholeSymbol, options:  .repeat(.periodic(delay: 2.0)))
                            
                            Text("To start using the app, user can choose to search a query (location, address, etc) using the text field in the **Query** search option, or use **Current Location** option if the app is given location access. Depends on the user's needs, a coordination search will also be available.")
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(spacing: 29.5) {
                            Image(systemName: "pin.fill")
                                .symbolEffect(.bounce.up.wholeSymbol, options:  .repeat(.periodic(delay: 2.0)))
                            
                            Text("After receiving the result of the search, user can click on the pin to get information on the **air quality forecast** of the current day")
                                
                        }
                        .padding(.horizontal)
                        
                        
                        
                        HStack(spacing: 30) {
                            Image(systemName: "square.and.arrow.down.fill")
                                .symbolEffect(.bounce.up.wholeSymbol, options:  .repeat(.periodic(delay: 2.0)))
                            
                            Text("User can save their desired location for quick access to air quality forecast in the **Saved Locations** tab. The user can choose names for the saved location for their own comprehension (which is also modifiable). **Saved location** also provide a filter for even better access and delete can be done with a swipe.")
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal, 5)
                    .padding(.bottom)
                    
                    Divider()
                    
                    
                    
                    //App information starts here
                    Text("App Information")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    
                    VStack(spacing: 15) {
                        Text("This app utilises [Open-Meteo's SDK package for SwiftUI](https://github.com/open-meteo/sdk.git) to fetch information and data directly from the API. The data is then displayed and graphed using **SwiftUI Charts** for each pair of latitude and longitude.")
                        
                        Text("**SwiftUI MapKit** \(Image(systemName: "map.fill")) and **Core Location** \(Image(systemName: "location.fill")) is the main method used to receive latitude and longitude from a user's searched location. The app allows users to manually search for the location they want, but Core Location allows users to access air quality forecast for current location directly *(The app will ask for permission when first opened)*.")
                        
                        Text("Data of user's saved location is also cached locally with **User Defaults \(Image(systemName: "square.and.arrow.down.fill"))** to ensure that user can have access to their saved information all the time.")
                    }
                    .padding(.horizontal, 6)
                    .padding(.bottom)
                    

                    Divider()
                    
                    
                    
                    //Data explanation section starts here
                    Text("Data Explanation")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    
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
                            
                            Text("This indicates a high amount of certain element in the air. Outdoor activities should be avoided")
                                .frame(maxWidth: 300)
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(spacing: 30) {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(.brown))
                            
                            Text("This indicates extremely high amount of a certain element in the air, outdoor activities are dangerous. Prtotection are needed when outside")
                                .frame(maxWidth: 300)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 5)
                    
                    
                    Text("More information can be found on [NSW Air Quality Categories](https://www.airquality.nsw.gov.au/health-advice/air-quality-categories) and [Carbon Dioxide Levels Chart](https://www.co2meter.com/en-au/blogs/news/carbon-dioxide-indoor-levels-chart?srsltid=AfmBOorbhDCjzRIA-vT0CbPk4djeLpNS0KyCKH-zV_ackgMONl8W3Bwy). These two websites provide information on different thresholds of each element presented in the quality, which is used for this app.")
                        .padding(.horizontal, 10)
                    
                    Divider()
                }
                
                
                
                //Bottom note for important information on the app
                VStack(spacing: 12) {
                    Text("**Important:**")
                        .font(.title3)
                    
                    Text("The app **needs** to be connected to wifi to work with the API. Without internet, user can still see the coordination of their saved location, but they won't be able to see the air quality forecast.")
                }
                .frame(maxHeight: 150)
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .navigationTitle("App Info and Data Explanation")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}


#Preview {
    DataExplainView()
}
