//
//  GroupView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct GroupView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @State var currentGroup: GroupItem?
    
    var body: some View {
        TabView() {
            CurrentGroup(currentGroup: $currentGroup)
                .tabItem {
                    Label("Groups", systemImage: "person.3.fill")
                }
            OwnerView(currentGroup: $currentGroup)
                .tabItem {
                    Label("Owner", systemImage: "plus")
                }
            LeaderBoardView(currentGroup: $currentGroup)
                .tabItem {
                    Label("LeaderBoard", systemImage: "sparkle.text.clipboard")
                }
        }
    }
}

#Preview {
    GroupView()
        .environment(AuthManager())
        .environment(NetworkManager())
        .environment(LocoTasksViewModel())
}
