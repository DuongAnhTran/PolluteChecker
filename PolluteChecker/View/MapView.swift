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
    
    var body: some View {
        VStack {
            TextField("Search for location", text: $queryText, onCommit: {
                mapSearch.locationSearch(query: queryText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Map(position: $mapSearch.cameraPosition) {
                if let pin = mapSearch.locationPin {
                    Annotation("", coordinate: pin.coordinate) {
                        Button(action: {
                            //gotta add a pop up sheet or sth
                        }) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
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

