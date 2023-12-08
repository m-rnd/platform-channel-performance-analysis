//
//  ListItemView.swift
//  PlatformChannelPerformance
//
//  Created by Markus Reinhold on 24.10.23.
//

import SwiftUI

struct ListItemView: View {
    let item: ScrollItem
    var body: some View {
        HStack(spacing: 15) {
            Text("\(item.id)")
            Text(item.header).frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.horizontal, 20).padding(.vertical, 10)
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(item: ScrollItem(id: 1, header: "Überschrift 1"))
    }
}
