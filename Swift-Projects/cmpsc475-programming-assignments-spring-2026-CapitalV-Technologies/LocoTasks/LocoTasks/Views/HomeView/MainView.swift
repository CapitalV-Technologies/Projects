//
//  HomeView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/12/26.
//

import SwiftUI

struct MainView: View {
    
    //NOTE: Would clean up code also if I had more time on this project.
    //I would also do my best to create some code modularity to make it easier and more clean
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    var body: some View {
        let padding: CGFloat = 20
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                //ScrollView (.vertical) {
                    VStack (spacing: padding) {
                        Text("LocoTasks")
                            .bold()
                            .font(.largeTitle)
                        HStack (spacing: padding * 2){
                            SquareView(title: "Tasks", view: TaskView())
                            SquareView(title: "Emotions", view: EmotionView())
                        }
                        .padding()
                        HStack (spacing: padding * 2){
                            SquareView(title: "Groups", view: GroupView())
                            SquareView(title: "Map", view: MainMapView())
                        }
                        Spacer()
                        AccountButtonView()
                    //}
                }
            }
        }
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
}

#Preview {
    MainView()
        .environment(AuthManager())
        .environment(NetworkManager())
        .environment(LocoTasksViewModel())
}
