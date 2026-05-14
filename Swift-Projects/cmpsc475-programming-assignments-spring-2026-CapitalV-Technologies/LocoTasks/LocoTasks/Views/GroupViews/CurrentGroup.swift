//
//  CurrentGroup.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct CurrentGroup: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @State private var groups: [GroupItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    @Binding var currentGroup: GroupItem?
    var body: some View {
        let padding: CGFloat = 20
        ZStack {
            backgroundColor.ignoresSafeArea()
            ScrollView (.vertical) {
                VStack (alignment: .leading){
                    Text("Groups:")
                        .bold()
                        .font(.largeTitle)
                        .padding(.horizontal, padding)
                    ScrollView (.horizontal) {
                        HStack (spacing: padding){
                            // Add a ForEach here for all groups this user is in.
                            // Make one group appear different when it's selected
                            Spacer()
                            ForEach(groups) { group in
                                PickGroupButton(group: group, currentGroup: $currentGroup)
                            }
                        }
                    }
                    Text("Note: Yellow means currently selected Group")
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .padding()
                    Text("Current Group Members: ")
                        .bold()
                        .font(.title)
                        .padding(.horizontal, padding)
                    if (currentGroup != nil) {
                        ForEach(currentGroup!.members, id:\.self) { email in
                            MembersView(email: email)
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear { loadGroups() }
        .refreshable { await loadGroupsAsync() }
    }
    let backgroundColor: LinearGradient = LinearGradient(
           gradient: Gradient(colors: [
            Color(red: 0.95, green: 0.94, blue: 0.88),
            Color(red: 0.93, green: 0.91, blue: 0.85),
            Color(red: 0.90, green: 0.89, blue: 0.83)
           ]),
           startPoint: .topLeading,
           endPoint: .bottomTrailing
       )
    
    private func loadGroups() {
        Task {
            await loadGroupsAsync()
        }
    }
    
    private func loadGroupsAsync() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            groups = try await networkManager.getGroups()
            if !groups.isEmpty {
                if currentGroup == nil {
                    currentGroup = groups[0]
                }
            }
        } catch {
            handleError("Failed to load tasks", error: error)
        }
    }
    
    private func handleError(_ message: String, error: Error) {
        // Check if error is unauthorized
        if case NetworkManager.NetworkError.unauthorized = error {
            authManager.logout()
            return
        }
        errorMessage = "\(message): \(error.localizedDescription)"
        showError = true
    }
}
