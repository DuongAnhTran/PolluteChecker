//
//  LocationCacher.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 28/9/2025.
//

import Foundation
import Combine
import SwiftUI

//This class provide functions related to User Defaults to save, modify and delete saved location info
class LocationCacher: ObservableObject {
    @Published var locationList: [LocationData] = []    //Variable to hold the saved locations data
    
    //Variable to hold the name of a specific location if the new location being added has the same coordinate
    @Published var existingName: String = ""
    
    //Function to add location data into exisitng data in User Defaults
    //Load current data -> add a new instnace into the list -> overwrite the saved data
    func addLocation(location: LocationData) {
        self.loadLocation()
        self.locationList.append(location)
        self.saveLocation()
    }
    
    //Function to encode data and save into User Defaults
    func saveLocation() {
        let encoder = JSONEncoder()
        if let encodeData = try? encoder.encode(self.locationList) {
            UserDefaults.standard.set(encodeData, forKey: "SavedLocation")
        }
    }
    
    //Function to load and decode the data saved in User Defaults
    func loadLocation() {
        if let data = UserDefaults.standard.value(forKey: "SavedLocation") {
            let decoder = JSONDecoder()
            if let decodeData = try? decoder.decode([LocationData].self, from: data as! Data)  {
                self.locationList = decodeData
            } else {
                //if decode fails, return empty list :<
                self.locationList = []
            }
        }
    }
    
    
    //Function to modify an existing location
    //Find the data instance through UUID -> apply changes -> Overwrite the saved data in User Defaults
    func modifyLocation(id: UUID, newName: String) {
        if let index = self.locationList.firstIndex(where: { $0.id == id }) {
            self.locationList[index].locationName = newName
            saveLocation()
        } else {
            print("not found")
        }
    }
    
    
    //Function to delete a location from saved data
    //Get offset (this is done through the list - swipe to delete) -> Get the saved data -> Delete the specific data -> overwrite
    func deleteLocation(at offsets: IndexSet) {
        self.loadLocation()
        self.locationList.remove(atOffsets: offsets)
        self.saveLocation()
    }
    
    
    //Function to check if the location is already existing through latitude and longitude
    func isPlaceExist(lat: Double, lon: Double) -> Bool {
        for location in self.locationList {
            if location.lat == lat && location.lon == lon  {
                return true
            }
        }
        return false
    }
    
    //Get the saved name of the location that has the same coordinate with the one getting add
    //This is mainly used to display and guide the user to find the exisitng instance, without allowing duplicates in UserDefaults
    func storeExistingName(lat: Double, lon: Double) {
        for location in self.locationList {
            if location.lat == lat && location.lon == lon  {
                self.existingName = location.locationName
            }
        }
    }
    
    //Function to check if the name that is going to be used for a new location is already taken
    func checkNameExist(name: String) -> Bool {
        for location in self.locationList {
            if location.locationName.lowercased() == name.lowercased()  {
                return true
            }
        }
        return false
    }
    
    //Filter function to allow user to search for the location they want to see in their saved data
    //Return a separate array for [LocationData] to use and display
    func filter(searchText: String) -> [LocationData] {
        var filteredLocation: [LocationData] = []
        for location in self.locationList {
            if (location.locationName.lowercased().contains(searchText.lowercased())) == true {
                filteredLocation.append(location)
            }
        }
        return filteredLocation
    }
}
