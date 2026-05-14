//
//  ListView.swift
//  Campus App
//
//  Created by LiasPub on 3/9/26.
//

import SwiftUI

struct ListView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    @State var userInput = ""
    //Based on enum, set current list
    var items: [BuildingEntry] {
        switch manager.buildingList {
        case .all: return manager.buildings.buildingLists
        case .favorited: return manager.favoritedBuildings
        case .selected: return manager.selectedBuildings
        }
    }
    
    // Create computed variable for searching
    var filtered: [BuildingEntry] {
        let results: [BuildingEntry]
        if userInput == "" {
            results = items
        } else {
            results = items.filter { word in
                word.name.localizedCaseInsensitiveContains(userInput)
            }
        }
        // Make results return in order Alphabetically
        return results.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        @Bindable var manager = self.manager
        Text("Buildings")
            .font(.title)
            .bold()
        Picker("BuildingList", selection: $manager.buildingList) {
            ForEach(Lists.allCases) { list in
                Text(list.rawValue)
                    .tag(list)
            }
        }
        .pickerStyle(.segmented)
        
        List(filtered, id: \.self) { building in
            BuildingEntryView(building: building)
            
            
        }
        // Looked this up to find how to remove the default background for the List View
        .scrollContentBackground(.hidden)
        // Search bar not showing up in preview, but will show from Main View due to Navigation Link
        .searchable(text: $userInput, prompt: "Search Buildings")
    }
}

#Preview {
    ListView()
        .environment(CampusAppViewModel())
}
