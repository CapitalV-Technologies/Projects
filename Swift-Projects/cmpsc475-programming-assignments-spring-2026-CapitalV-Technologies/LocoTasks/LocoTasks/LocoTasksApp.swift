//
//  LocoTasksApp.swift
//  LocoTasks
//
//  Created by LiasPub on 4/12/26.
//

import SwiftUI

@main
struct LocoTasksApp: App {
    @State var authManager = AuthManager()
    @State var networkManager = NetworkManager()
    @State var manager = LocoTasksViewModel()
    var body: some Scene {
        WindowGroup {
                    AuthContainerView()
                        .environment(authManager)
                        .environment(networkManager)
                        .environment(manager)
                        .onAppear {
                            networkManager.configure(authManager: authManager)
                        }
                }
    }
}
