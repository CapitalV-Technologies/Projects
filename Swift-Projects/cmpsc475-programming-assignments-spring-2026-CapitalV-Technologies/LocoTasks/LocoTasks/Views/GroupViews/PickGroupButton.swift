//
//  PickGroupButton.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct PickGroupButton: View {
    var group: GroupItem
    @Binding var currentGroup: GroupItem?
    var body: some View {
        let cornerRadius: CGFloat = 16
        let side: CGFloat = 100
        Button {
            currentGroup = group
        } label: {
            Text(group.title)
                .foregroundStyle(.white)
                .bold()
                .font(.title3)
                .frame(width: side, height: side)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill((currentGroup?.title == group.title) ? .yellow : Color.pennStateLightBlue))
        }
    }
}
