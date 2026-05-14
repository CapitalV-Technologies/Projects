//
//  LeaderBoardView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @Binding var currentGroup: GroupItem?
    @State private var tasks: [TasklyItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    @State private var scores: [(String, Int)] = []
    
    var body: some View {
        let spacing: CGFloat = 20
        let padding: CGFloat = 20
        ZStack {
            backgroundColor.ignoresSafeArea()
            ScrollView (.vertical){
                VStack (alignment: .leading, spacing: spacing){
                    Text("LeaderBoard")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal, padding)
                    let text = "You have not selected a Group!"
                    Text("Group: \(currentGroup?.title ?? text)")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, padding)
                    ForEach(scores.enumerated(), id: \.element.0) {index, element  in
                        LeaderBoardMembersView(user: element.0, totalPoints: element.1, place: index + 1)
                            .frame(maxWidth: .infinity)
                    }
                }
                
            }
        }
        .onAppear { loadScores() }
        //.refreshable { await loadScoresAsync() }
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
    // Create a function that filters through current group and finds total groups for each member, and then orders members based off number of points (most to least).
    
    private func loadScores() {
        Task {
            await loadScoresAsync()
        }
    }
    
    private func loadScoresAsync() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if currentGroup != nil {
                scores = []
                for member in currentGroup!.members {
                    tasks = try await networkManager.getTasksByEmail(email: member)
                    var score = 0.0
                    for t in tasks {
                        if t.completed == true {
                            score += t.difficulty
                        }
                    }
                    scores.append((member, Int(score)))
                }
                scores = scores.sorted { $0.1 > $1.1 }
            }
        } catch {
            handleError("Failed to load tasks", error: error)
        }
    }
    
    private func loadTasks() async {
        
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
