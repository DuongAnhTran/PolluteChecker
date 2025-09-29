//
//  LocationManager.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 28/9/2025.
//

import Foundation
import Combine
import SwiftUI

class LocationManager: ObservableObject {
    @Published var locationList: [LocationData] = []
    
    
    func addLocation(location: LocationData) {
        self.loadLocation()
        self.locationList.append(location)
        self.saveLocation()
    }
    
    
    func saveLocation() {
        let encoder = JSONEncoder()
        if let encodeData = try? encoder.encode(self.locationList) {
            UserDefaults.standard.set(encodeData, forKey: "SavedLocation")
        }
    }
    
    func loadLocation() {
        if let data = UserDefaults.standard.value(forKey: "SavedLocation") {
            let decoder = JSONDecoder()
            if let decodeData = try? decoder.decode([LocationData].self, from: data as! Data)  {
                self.locationList = decodeData
            }
        }
    }
    
    
    func deleteLocation(at offsets: IndexSet) {
        self.loadLocation()
        self.locationList.remove(atOffsets: offsets)
        self.saveLocation()
    }
}
