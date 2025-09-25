//
//  ContentView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var apiFetch = APIFetcher()
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .task{
            let object = await apiFetch.fetchAirQuality(latitude: -33.8678, longitude: 151.2073)
            print(object.hourly.ozone)
            print(object.hourly.time)
        }
        //.padding()
    }
}

#Preview {
    ContentView()
}
