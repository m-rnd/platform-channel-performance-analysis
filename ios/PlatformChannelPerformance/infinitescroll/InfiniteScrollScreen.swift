//
//  InfiniteScrollScreen.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.10.23.
//

import SwiftUI

struct InfiniteScrollScreen: View {
    @ObservedObject var getItemsUseCase = GetItemsUseCase()
    
    var body: some View {
        InfiniteList(items: getItemsUseCase.items, loadNewItems: getItemsUseCase.loadContent)
            .onAppear {
                FpsMonitor.start(experimentName: "T2b")
            }
            .onDisappear {
                FpsMonitor.stop()
            }
    }
}

struct InfiniteScrollScreen_Preview: PreviewProvider {
    static var previews: some View {
        InfiniteScrollScreen()
    }
}


