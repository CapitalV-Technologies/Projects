//
//  AddTaskView.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct AddTaskMapView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = ""
    @State var description: String = ""
    @State var difficulty: Double = 1
    @State var longitude: Double?
    @State var latitude: Double?
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showAddTask = false
    
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                formContent
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { showError = false }
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.pennStateBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        resetNewTaskForm()
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        createTask()
                        dismiss()
                    }
                    .disabled(isSaveDisabled)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
            }
            .onAppear {
                isTitleFocused = true
            }
        }
        .tint(.pennStateBlue)
    }
    
    // MARK: - Subviews
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.pennStateBlue.opacity(0.03), Color.pennStateLightBlue.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var formContent: some View {
        Form {
            titleSection
            descriptionSection
            difficultySection
            getLocationSection
            longitudeSection
            latitudeSection
        }
        .scrollContentBackground(.hidden)
    }
    
    private var titleSection: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Task Title", text: $title)
                .focused($isTitleFocused)
                .font(.body)
        } header: {
            Text("Title")
                .foregroundStyle(Color.pennStateBlue)
                .fontWeight(.semibold)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
        )
    }
    
    private var descriptionSection: some View {
        let spacing: CGFloat = 4
        return Section {
            TextField("Task Description", text: $description, axis: .vertical)
                .lineLimit(3...8)
                .font(.body)
        } header: {
            Text("Description")
                .foregroundStyle(Color.pennStateBlue)
                .fontWeight(.semibold)
        } footer: {
            HStack(spacing: spacing) {
                Image(systemName: "info.circle.fill")
                    .font(.caption2)
                Text("Optional - Add more details about this task")
            }
            .foregroundStyle(.secondary)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
    }
    
    private var difficultySection: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Enter Difficulty", value: $difficulty, format: .number)
                .font(.body)
        } header: {
            Text("Difficulty of Task")
                .foregroundStyle(Color.pennStateBlue)
                .fontWeight(.semibold)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
        )
    }
    
    private var getLocationSection: some View {
        let width: CGFloat = 350
        let height: CGFloat = 50
        let cornerRadius: CGFloat = 12
        return Button {
            latitude = manager.getLat()
            longitude = manager.getLong()
            
        } label: {
            Text("Add current Location")
                .foregroundStyle(.white)
                .bold()
                .font(.body)
        }
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.pennStateNavy))
    }
    
    private var longitudeSection: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Enter longitude", value: $longitude, format: .number)
                .font(.body)
        } header: {
            Text("Longitude")
                .foregroundStyle(Color.pennStateBlue)
                .fontWeight(.semibold)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
        )
    }
    private var latitudeSection: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Enter latitude", value: $latitude, format: .number)
                .font(.body)
        } header: {
            Text("Latitude")
                .foregroundStyle(Color.pennStateBlue)
                .fontWeight(.semibold)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
        )
    }
    
    // MARK: - Computed Properties
    
    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespaces).isEmpty || longitude == nil || latitude == nil
    }
    
    private func createTask() {
        
        // If I continued this app, I would create a way for the member to know who this task was made by.
        Task {
            do {
                _ = try await networkManager.createTask(
                    title: title,
                    description: description,
                    difficulty: difficulty,
                    longitude: longitude ?? 0,
                    latitude: latitude ?? 0,
                )
                
                resetNewTaskForm()
                showAddTask = false
            } catch {
                handleError("Failed to create task", error: error)
            }
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
    
    private func resetNewTaskForm() {
        title = ""
        description = ""
        difficulty = 1
        longitude = nil
        latitude = nil
    }
}
