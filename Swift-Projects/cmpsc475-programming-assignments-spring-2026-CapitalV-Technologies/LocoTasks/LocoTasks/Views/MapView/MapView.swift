//
//  MapView.swift
//  Campus App
//
//  Created by LiasPub on 3/8/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @State private var tasks: [TasklyItem] = []
    @State private var journalEntries: [JournalEntry] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    @Binding var showTasks: Bool
    @Binding var showJournalEntries: Bool
    
    @State private var droppedPin: CLLocationCoordinate2D?
    @State private var showSheet: Bool = false
    var body: some View {
        @Bindable var manager = manager
        MapReader { proxy in
            Map(position: $manager.cameraPosition) {
                UserAnnotation()
                if showTasks {
                    ForEach(tasks) { task in
                        Annotation("",coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(task.latitude), longitude: CLLocationDegrees(task.longitude))) {
                            AnnotationView(task: task, isTask: true)
                                .environment(manager)
                        }
                    }
                }
                
                if showJournalEntries {
                    ForEach(journalEntries) { entry in
                        Annotation("",coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(entry.latitude), longitude: CLLocationDegrees(entry.longitude))) {
                            AnnotationView(entry: entry, isTask: false)
                                .environment(manager)
                        }
                    }
                }
                
                if droppedPin != nil {
                    Annotation("Pin", coordinate: droppedPin!) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .onTapGesture {
                                showSheet.toggle()
                            }
                    }
                }
            }
            .gesture(
                SpatialTapGesture()
                    .onEnded { value in
                        if let coordinate = proxy.convert(value.location, from: .local) {
                            droppedPin = coordinate
                        }
                    }
                )
            .mapStyle(manager.mapInfo.mapStyle.style)
            .onAppear { loadTasks(); loadEntries() }
            .refreshable { await loadTasksAsync(); await loadEntriesAsync() }
            .alert("Error", isPresented: $showError) {
                Button("OK") { showError = false }
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
        }
        .sheet(isPresented: $showSheet) {
            AddTaskMapView(longitude: droppedPin?.longitude, latitude: droppedPin?.latitude)
        }
    }
    
    private func loadEntries() {
        Task {
            await loadEntriesAsync()
        }
    }
    
    private func loadEntriesAsync() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            journalEntries = try await networkManager.getJournalEntries()
        } catch {
            handleError("Failed to load tasks", error: error)
        }
    }
    
    private func loadTasks() {
        Task {
            await loadTasksAsync()
        }
    }
    
    private func loadTasksAsync() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            tasks = try await networkManager.getTasks()
            for task in tasks {
                        print("Task: \(task.id) at Lat: \(task.latitude), Lon: \(task.longitude)")
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
