//
//  PentominoesApp.swift
//  Pentominoes
//
//  Created by LiasPub on 2/19/26.
//

import SwiftUI

@main
struct PentominoesApp: App {
    @State var manager: PentominoesViewModel = PentominoesViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(manager.self)
        }
    }
}
