//
//  ScrollView.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.10.23.
//

import SwiftUI

struct InfiniteScrollScreen: View {
    @ObservedObject var getItemsUseCase = GetItemUseCase()
    
    var body: some View {
        InfiniteList(items: getItemsUseCase.items, loadNewItems: getItemsUseCase.loadContent)
    }
}

struct InfiniteScrollView_Preview: PreviewProvider {
    static var previews: some View {
        InfiniteScrollScreen()
    }
}


