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
                        .symbolEffect(.bounce.up.wholeSymbol, options:  .repeat(.periodic(delay: 2.0)))
                }
            
            SavedLocation().environmentObject(locationManager)
                .tabItem {
                    Label("Saved Location", systemImage: "list.bullet.clipboard.fill")
                        .symbolEffect(.bounce.up.wholeSymbol, options:  .repeat(.periodic(delay: 2.0)))
                }
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
}
