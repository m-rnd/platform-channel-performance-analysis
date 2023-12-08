//
//  ScrollItem.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 23.10.23.
//

import Foundation

class ScrollItem: ObservableObject, Identifiable, Hashable {
    static func == (lhs: ScrollItem, rhs: ScrollItem) -> Bool {
        return lhs.id == rhs.id && lhs.header == rhs.header
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(header)
    }
    
    let id: Int
    let header: String
    
    init(id: Int, header: String) {
        self.id = id
        self.header = header
    }
}
