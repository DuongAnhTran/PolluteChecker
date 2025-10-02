//
//  ContentView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import SwiftUI

//This will trigger when the app is run. This is a minor loading screen when the app is opened
struct ContentView: View {
    //Getting the env object fed to the app
    @EnvironmentObject var locationManager: LocationCacher
    @State var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                VStack {
                    ProgressView("App is Loading. Please wait...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            } else {
                HomeView()
                    .environmentObject(locationManager)
            }
        }
        //When the app first opened, the time for this loading screen is 1 second
        .onAppear {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationCacher())
}
