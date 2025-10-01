//
//  LocationCacher.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 28/9/2025.
//

import Foundation
import Combine
import SwiftUI

class LocationCacher: ObservableObject {
    @Published var locationList: [LocationData] = []
    @Published var existingName: String = ""
    
    
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
            } else {
                self.locationList = []
            }
        }
    }
    
    func modifyLocation(at index: Int, newName: String) {
        self.locationList[index].locationName = newName
        saveLocation()
    }
    
    
    func deleteLocation(at offsets: IndexSet) {
        self.loadLocation()
        self.locationList.remove(atOffsets: offsets)
        self.saveLocation()
    }
    
    
    func isPlaceExist(lat: Double, lon: Double) -> Bool {
        for location in self.locationList {
            if location.lat == lat && location.lon == lon  {
                return true
            }
        }
        return false
    }
    
    func storeExistingName(lat: Double, lon: Double) {
        for location in self.locationList {
            if location.lat == lat && location.lon == lon  {
                self.existingName = location.locationName
            }
        }
    }
    
    
    func checkNameExist(name: String) -> Bool {
        for location in self.locationList {
            if location.locationName.lowercased() == name.lowercased()  {
                return true
            }
        }
        return false
    }
}
