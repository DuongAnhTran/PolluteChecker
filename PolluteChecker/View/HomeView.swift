//
//  HomeView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 30/9/2025.
//

import SwiftUI

///This is the first view that will be showed after the app finish initialising
///Receive an environment variable that is fed at initially at the start of the app in PolluteCheckerApp
///The 4 main views of this app is: MapView, DataExplainView, SavedLocation View and LocationView (the rest will be child view of these 4 views)
struct HomeView: View {
    @StateObject var apiFetch = APIFetcher()
    @EnvironmentObject var locationManager: LocationCacher
    
    var body: some View {
        //Contains the tab that allows navigation between map search, saved location info and app info views
        TabView {
            MapView().environmentObject(locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            SavedLocation().environmentObject(locationManager)
                .tabItem {
                    Label("Saved Location", systemImage: "list.bullet.clipboard.fill")
                }
            
            DataExplainView()
                .tabItem {
                    Label("App Instruction", systemImage: "info.circle")
                }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationCacher())
}
