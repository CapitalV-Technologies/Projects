//
//  FavoritedView.swift
//  Campus App
//
//  Created by LiasPub on 3/19/26.
//

import SwiftUI

struct FavoritedView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    let building: BuildingEntry
    var body: some View {
        // Need this due to this being in a sheet view and not a LIST view
        // Thus, must find index based on id and not full building struct (since we are changing the isFavorited var of the struct
        // This took awhile to figure out!
        let index = manager.buildings.buildingLists.firstIndex(where: { $0.id == building.id })
        let isFavorited: Bool = manager.buildings.buildingLists[index!].isFavorited
        let opacity = 0.1
        Button {
            manager.buildings.buildingLists[index!].isFavorited.toggle()
            manager.buildings.save()
        } label: {
            Image(systemName: isFavorited ? "star.fill" : "star")
                .font(.largeTitle)
                .foregroundColor( isFavorited  ? .yellow : .black)
                .background(Circle().fill(.opacity(opacity)))
        }
        .buttonStyle(.borderless)
    }
}
