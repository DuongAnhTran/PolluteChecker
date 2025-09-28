//
//  MapView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import Foundation
import SwiftUI
import MapKit

//initial map and pin for the

struct MapView: View {
    @StateObject private var mapSearch = MapSearcher()
    @State private var queryText = ""
    @State private var locSelect: Bool = false
    
    var body: some View {
        VStack {
            TextField("Search for location", text: $queryText, onCommit: {
                mapSearch.locationSearch(query: queryText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Map(position: $mapSearch.camPos) {
                if let pin = mapSearch.locationPin {
                    Annotation("Destination", coordinate:pin.coordinate) {
                        Button(action: {
                            locSelect = true
                        }) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                        }
                        .sheet(isPresented: $locSelect) {
                            LocationView()
                        }
                    }
                }
            }
            .mapStyle(.standard)
               
        }
    }
}

#Preview {
    MapView()
}

