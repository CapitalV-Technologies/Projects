//
//  MainView.swift
//  Campus App
//
//  Created by LiasPub on 3/8/26.
//

import SwiftUI
import MapKit


struct MainMapView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @State var showTasks = false
    @State var showJournalEntries = false
    var body: some View {
        let height: CGFloat = 30
        let padding: CGFloat = 20
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack {
                HStack (spacing: padding){
                    // Add functions for buttons later
                    MapButtonView(title: "", isImage: true, perform: centerUser)
                    MapButtonView(title: "Tasks", isImage: false, perform: toggleTasks)
                    MapButtonView(title: "Emotions", isImage: false, perform: toggleJournalEntries)
                }
                MapView(showTasks: $showTasks, showJournalEntries: $showJournalEntries)
                FooterView()
                    .frame(height: height)
            }
        }
    }
    
    let backgroundColor: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.pennStateAccent
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    func centerUser() {
        manager.getCurrentLocation()
    }
    
    func toggleTasks() {
        showTasks.toggle()
    }
    
    func toggleJournalEntries() {
        showJournalEntries.toggle()
    }
}


#Preview {
    MainMapView()
        .environment(AuthManager())
        .environment(NetworkManager())
        .environment(LocoTasksViewModel())
        
}
