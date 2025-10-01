//
//  SavedLocation.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 28/9/2025.
//


import SwiftUI
import Foundation
import MapKit

struct SavedLocation: View {
    @EnvironmentObject var locationManager: LocationCacher
    
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(Array(locationManager.locationList.enumerated()), id: \.element.id) { index, location in
                    NavigationLink {
                        LocationView(lat: location.lat, lon: location.lon, locationTitle: location.locationName, locOffset: index)
                            .presentationDragIndicator(.visible)
                            .environmentObject(locationManager)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(location.locationName)
                                .font(.headline)
                            Text("Latitude: \(String(format: "%.4f", location.lat)), Longitude: \(String(format: "%.4f", location.lon))")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            
                            
                            
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
                .onDelete(perform: locationManager.deleteLocation)
            }
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
