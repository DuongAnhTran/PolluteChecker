//
//  LocationView.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 27/9/2025.
//

import Foundation
import SwiftUI

struct LocationView: View {
    @StateObject var fetcher = APIFetcher()
    @State var lat: Double
    @State var lon: Double
    
    var body: some View {
        Text("\(lat)")
        Text("\(lon)")
    }
}
