//
//  ContentView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import SwiftUI

struct ContentView: View {
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
        .onAppear {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationCacher())
}
