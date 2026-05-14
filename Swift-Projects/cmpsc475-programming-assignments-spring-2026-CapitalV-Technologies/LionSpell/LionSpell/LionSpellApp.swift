//
//  LionSpellApp.swift
//  LionSpell
//
//  Created by LiasPub on 1/21/26.
//

import SwiftUI

@main
struct LionSpellApp: App {
    @State var manager: LionSpellViewModel = LionSpellViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(manager.self)
        }
    }
}
