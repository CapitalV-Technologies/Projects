//
//  AnnotationView.swift
//  Campus App
//
//  Created by LiasPub on 3/16/26.
//

import SwiftUI

struct AnnotationView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    let building: BuildingEntry
    var body: some View {
        let width: CGFloat = 40
        let height: CGFloat = 40
        Button {
            manager.selectedBuilding = building
            manager.sheetView.toggle()
        } label: {
            VStack() {
                // Main annotation bubble
                ZStack {
                    // Background
                    Circle()
                        .fill(building.isFavorited ? .yellow : .blue)
                        .frame(width: width + 4, height: height + 4)
                    // Category icon with colored background
                    ZStack {
                        Image(systemName: building.isFavorited ? "star.fill" : "building.columns")
                            .foregroundColor(building.isFavorited ? .yellow : .blue)
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: width, height: height))
                    }
                }
                Text(building.name)
            }
        }
    }
}

