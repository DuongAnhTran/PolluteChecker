//
//  ContentView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var apiFetch = APIFetcher()
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        TabView {
            MapView().environmentObject(locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            SavedLocation()
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
}
