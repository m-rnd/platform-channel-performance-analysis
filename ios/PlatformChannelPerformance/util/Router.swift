//
//  Router.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 24.10.23.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    @Published var navPath: NavigationPath = .init()
}

enum NavDestination {
    case Scroll, InfiniteScroll
}

