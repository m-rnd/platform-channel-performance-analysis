//
//  GetItemsUseCase.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.10.23.
//

import Foundation


let PAGE_SIZE = 10
let PAGE_PRELOAD_COUNT = 3

class GetItemsUseCase: ObservableObject {
    @Published var items = [ScrollItem]()
    private var lastPage = 0
    
    init() {
         loadContent(targetPage: PAGE_PRELOAD_COUNT)
    }
    
    func loadContent(targetPage: Int) {
        guard targetPage > lastPage else {return}
   
        var newItems = [ScrollItem]()
        for newPage in lastPage..<targetPage { // loop to add more than one page
            for i in 0..<PAGE_SIZE { // add items to page
                newItems.append(
                    ScrollItem(
                        id: newPage * PAGE_SIZE + i,
                        header: "Überschrift \(i) auf Seite \(newPage)"
                    )
                )
            }
        }
        FpsMonitor.log(-10.0)
        items.append(contentsOf: newItems)
        lastPage = targetPage
    }
}
