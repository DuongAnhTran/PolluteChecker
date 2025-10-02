//
//  PolluteCheckerApp.swift
//  PolluteChecker
//
//  Created by Dương Anh Trần on 25/9/2025.
//

import SwiftUI

//Package imported for package dependencies in this app: https://github.com/open-meteo/sdk.git
///It will contain **FlatBuffers** and **OpenMeteoSdk**

//This will be run when the app is opened, feed the env object for the app and open the first view
@main
struct PolluteCheckerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocationCacher())
        }
    }
}
