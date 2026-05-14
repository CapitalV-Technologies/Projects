//
//  Campus_AppApp.swift
//  Campus App
//
//  Created by LiasPub on 3/7/26.
//

import SwiftUI

@main
struct Campus_App: App {
    @State var manager: CampusAppViewModel = CampusAppViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(manager.self)
        }
    }
}
