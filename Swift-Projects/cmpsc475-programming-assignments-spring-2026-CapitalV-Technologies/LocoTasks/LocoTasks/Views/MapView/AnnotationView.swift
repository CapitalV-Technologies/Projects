//
//  AnnotationView.swift
//  Campus App
//
//  Created by LiasPub on 3/16/26.
//

import SwiftUI

struct AnnotationView: View {
//    @Environment(AuthManager.self) var authManager
//    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    var task: TasklyItem?
    var entry: JournalEntry?
    var isTask: Bool
    var body: some View {
        let width: CGFloat = 40
        let height: CGFloat = 40
        // If I continued this project, I could add a sheet view where when this annotation gets clicked, the specific task pops up. However, due to time and scope, I will not implement this.
        Button {
            
        } label: {
            VStack() {
                // Main annotation bubble
                ZStack {
                    // Background
                    Circle()
                        .fill(isTask ? Color.pennStateLightBlue : Color.pennStateNavy)
                        .frame(width: width + 4, height: height + 4)
                    // Category icon with colored background
                    ZStack {
                        Image(systemName: isTask ? (task!.completed ? "checkmark" : "rectangle.and.pencil.and.ellipsis.rtl" ) : "figure.stand")
                            .foregroundColor(isTask ? Color.pennStateLightBlue : Color.pennStateNavy)
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: width, height: height))
                    }
                }
                Text((isTask ? task?.title : entry?.emotion.str)!)
            }
        }
    }
}

