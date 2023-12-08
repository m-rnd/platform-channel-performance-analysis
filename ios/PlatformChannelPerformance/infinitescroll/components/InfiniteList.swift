//
//  InfiniteList.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.10.23.
//

import Foundation
import SwiftUI
// https://www.donnywals.com/implementing-an-infinite-scrolling-list-with-swiftui-and-combine/
// https://betterprogramming.pub/build-an-infinite-list-with-swiftui-and-combine-f9ea1e83a4a7
struct InfiniteList: View {
    
    var items: [ScrollItem]
    var loadNewItems : (Int) -> ()
    @State var lastPage = 0

    var body: some View {
        VStack {
            Text("\(items.count) Items geladen, letzte Seite: \(lastPage)")
            ScrollView {
                LazyVStack() {
                    ForEach(items, id: \.self) { item in
                        ListItemView(item: item).onAppear {
                            let targetPage = max(lastPage, (item.id + PAGE_SIZE) / PAGE_SIZE + PAGE_PRELOAD_COUNT)
                            if (lastPage < targetPage) {
                                loadNewItems(targetPage)
                                lastPage = targetPage
                            }
                        }
                    }
                }
            }
        }
    }
}
