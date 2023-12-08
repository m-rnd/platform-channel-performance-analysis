//
//  ContentView.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.05.23.
//

import SwiftUI
import Flutter

struct ContentView: View {
    // Flutter dependencies are passed in an EnvironmentObject.
    @EnvironmentObject var flutterDependencies: FlutterDependencies
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(
            spacing: 30
        ) {
            #if DEBUG
                Text("Debug mode")
            #else
                Text("Release mode")
            #endif
            
            Button("Native scroll") {
                router.navPath.append(NavDestination.Scroll)
            }
            Button("Native infinite scroll") {
                router.navPath.append(NavDestination.InfiniteScroll)
            }
            Button("Show Flutter!") {
                showFlutter()
            }
        }
    }
    
    // TODO: refactor to app-level navigator
    func showFlutter() {
        // Get the RootViewController.
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }
        
        // Create the FlutterViewController.
        let flutterViewController = FlutterViewController(
            engine: flutterDependencies.flutterEngine,
            nibName: nil,
            bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        
        rootViewController.present(flutterViewController, animated: true)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
