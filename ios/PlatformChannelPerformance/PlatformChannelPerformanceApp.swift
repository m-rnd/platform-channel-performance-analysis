//
//  PlatformChannelPerformanceApp.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.05.23.
//

import SwiftUI

@main
struct PlatformChannelPerformanceApp: App {
    @StateObject var flutterDependencies = FlutterDependencies()
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: NavDestination.self, destination: { destination in
                        switch(destination) {
                        case .Scroll:
                            ScrollScreen()
                        case .InfiniteScroll:
                            InfiniteScrollScreen()
                        }
                    })
            }
            .environmentObject(router)
            .environmentObject(flutterDependencies)
        }
    }
}
