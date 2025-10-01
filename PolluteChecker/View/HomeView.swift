//
//  HomeView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 30/9/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var apiFetch = APIFetcher()
    @EnvironmentObject var locationManager: LocationCacher
    
    var body: some View {
        TabView {
            MapView().environmentObject(locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            SavedLocation().environmentObject(locationManager)
                .tabItem {
                    Label("Saved Location", systemImage: "list.bullet.clipboard.fill")
                }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationCacher())
}
