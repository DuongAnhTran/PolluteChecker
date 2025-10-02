//
//  SavedLocation.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 28/9/2025.
//


import SwiftUI
import Foundation
import MapKit

///SavedLocation -> LocationView

//The view that show all saved location that is saved by the user
struct SavedLocation: View {
    
    //Receive env object from parent view(s)
    @EnvironmentObject var locationManager: LocationCacher
    
    //A variable to observe the filter search textfield
    @State var searchText: String = ""
    
    //A varibale that holds a sub-set of LocationData, this will be used to apply filter
    //If there is input, filter the saved data, if there is not, show all of the saved locations
    var filteredLocation: [LocationData] {
        if searchText.isEmpty {
            return locationManager.locationList
        } else {
            return locationManager.filter(searchText: searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            //The list that will show user saved locations
            List{
                ForEach(filteredLocation, id: \.id) { location in
                    //Each list item has a link that gopes into the location's air quality forecast info
                    NavigationLink {
                        LocationView(lat: location.lat, lon: location.lon, locationTitle: location.locationName, id: location.id)
                            .presentationDragIndicator(.visible)
                            .environmentObject(locationManager)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(location.locationName)
                                .font(.headline)
                            Text("Latitude: \(String(format: "%.4f", location.lat)), Longitude: \(String(format: "%.4f", location.lon))")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            
                            
                            //A preview map in each of the list item to display where the location is
                            Map(position: .constant(.region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon),
                                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
                            ) {
                                let locationPin = LocationPin(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon))
                                Annotation("Current Position", coordinate: locationPin.coordinate) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title)
                                        .foregroundStyle(.blue)
                                }
                            }
                            .frame(height: 150)
                            .cornerRadius(10)
                            .padding(.top, 5)
                        }
                    }
                }
                //Saved location can be dleted with a swipe
                .onDelete(perform: locationManager.deleteLocation)
            }
            //Allow the list to be searchable/filterable
            .searchable(text: $searchText, prompt: "Search saved locations")
            //When the view appear, load the information first
            .onAppear {
                Task {
                    locationManager.loadLocation()
                    //print("\(locationManager.locationList.count)") (This is for debugging)
                }
            }
            .navigationTitle("Your saved location")
        }
        
        
            
    }
    
}

#Preview {
    SavedLocation()
        .environmentObject(LocationCacher())
}
