//
//  BuildingEntryView.swift
//  Campus App
//
//  Created by LiasPub on 3/9/26.
//

import SwiftUI

struct BuildingEntryView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    let building: BuildingEntry
    var body: some View {
        let width: CGFloat = 360
        let height: CGFloat = 40
        let shadowRadius: CGFloat = 3
        let radius: CGFloat = 16
        HStack {
            Text(building.name)
                .font(.title2)
                .padding()
            Spacer()
            Button {
                if let index = manager.buildings.buildingLists.firstIndex(where: { $0.id == building.id }) {
                                    manager.buildings.buildingLists[index].isFavorited.toggle()
                                    manager.buildings.save()
                                }
            } label: {
                Image(systemName: building.isFavorited ? "star.fill" : "star")
                    .font(.title)
                    .foregroundColor( building.isFavorited ? .yellow : .black)
            }
            // Looked this up to find how to make the buttons work within the List View
            .buttonStyle(.borderless)
            Button {
                if let index = manager.buildings.buildingLists.firstIndex(where: { $0.id == building.id }) {
                                    manager.buildings.buildingLists[index].isSelected.toggle()
                                    manager.buildings.save()
                                }
            } label: {
                Image(systemName: building.isSelected ? "checkmark.seal.fill" : "checkmark.seal")
                    .font(.title)
                    .foregroundColor(building.isSelected ? .blue : .black)
            }
            .padding()
            .buttonStyle(.borderless)
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color:.black, radius: shadowRadius))
    }
}
