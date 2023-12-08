//
//  ScrollScreen.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.10.23.
//

import SwiftUI

struct ScrollScreen: View {
    @ObservedObject var getItemsUseCase = GetItemsUseCase()
    let targetPage = 100
    
    init() {
        getItemsUseCase.loadContent(targetPage: targetPage)
    }
    
    var body: some View {
        VStack {
            Text("\(getItemsUseCase.items.count) Items geladen, letzte Seite: \(targetPage)")
            ScrollView {
                LazyVStack() {
                    ForEach(getItemsUseCase.items, id: \.self) { item in
                        ListItemView(item: item)
                    }
                }
            }
        }
        .onAppear {
            FpsMonitor.start(experimentName: "T2a")
        }
        .onDisappear {
            FpsMonitor.stop()
        }
    }
}

struct ScrollScreen_Preview: PreviewProvider {
    static var previews: some View {
        ScrollScreen()
    }
}


