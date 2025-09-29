//
//  SavedLocation.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 28/9/2025.
//


import SwiftUI
import Foundation

struct SavedLocation: View {
    @StateObject var manager = LocationManager()
    
    var body: some View {
        Text("\(manager.locationList.count)")
            .onAppear {
                Task {
                    manager.loadLocation()
                    print("\(manager.locationList.count)")
                }
            }
    }
    
}

#Preview {
    SavedLocation(manager: LocationManager())
}
