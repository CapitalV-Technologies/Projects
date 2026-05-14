//
//  MainView.swift
//

import SwiftUI

struct TaskView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @State private var tasks: [TasklyItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showAddTask = false
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    @State private var newDifficulty: Double = 1.0
    
    // Make it so that if one is filled but the other isn't, then you can't submit or something like that.
    @State private var longitude: Double?
    @State private var latitude: Double?
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading && tasks.isEmpty {
                    LoadingView(text: "tasks")
                } else if tasks.isEmpty {
                    EmptyStateView(text: "Tasks")
                } else {
                    TaskListView(
                        tasks: tasks,
                        onToggleTask: markTaskAs,
                        onDeleteTask: deleteTask
                    )
                }
            }
            .background { backgroundGradient }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.pennStateBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar { toolbar }
            .onAppear { loadTasks() }
            .refreshable { await loadTasksAsync() }
            .alert("Error", isPresented: $showError) {
                Button("OK") { showError = false }
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
            .sheet(isPresented: $showAddTask) { addTaskSheet }
        }
        .tint(.pennStateBlue)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.pennStateBlue.opacity(0.03), Color.pennStateLightBlue.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        let spacing: CGFloat = 16
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: spacing) {
                Button {
                    showAddTask = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
    }
    
    private var addTaskSheet: some View {
        AddTaskView(
            title: $newTaskTitle,
            description: $newTaskDescription,
            difficulty: $newDifficulty,
            longitude: $longitude,
            latitude: $latitude,
            onSave: createNewTask,
            onCancel: {
                resetNewTaskForm()
                showAddTask = false
            }
        )
    }
    
    // MARK: - Actions
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
        } catch {
            handleError("Failed to load tasks", error: error)
        }
    }
    
    private func markTaskAs(taskId: String, completed: Bool) {
        Task {
            do {
                // Optimistically update UI
                updateTaskLocally(taskId: taskId, completed: completed)
                
                // Make the API call
                try await networkManager.markTaskAs(completed: completed, taskId: taskId)
                
                // Refresh to get the latest state from server
                await loadTasksAsync()
            } catch {
                // Revert the optimistic update
                await loadTasksAsync()
                handleError("Failed to update task", error: error)
            }
        }
    }
    
    private func createNewTask() {
        Task {
            do {
                _ = try await networkManager.createTask(
                    title: newTaskTitle,
                    description: newTaskDescription,
                    difficulty: newDifficulty,
                    longitude: longitude ?? 0.0,
                    latitude: latitude ?? 0.0
                )
                
                await loadTasksAsync()
                
                resetNewTaskForm()
                showAddTask = false
            } catch {
                handleError("Failed to create task", error: error)
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let task = tasks[index]
                
                // Optimistically remove from UI
                tasks.remove(atOffsets: offsets)
                
                do {
                    try await networkManager.deleteTask(taskId: task.id)
                    await loadTasksAsync()
                } catch {
                    // Revert the optimistic update by refreshing
                    await loadTasksAsync()
                    handleError("Failed to delete task", error: error)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateTaskLocally(taskId: String, completed: Bool) {
        guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        
        tasks[index] = TasklyItem(
            id: tasks[index].id,
            title: tasks[index].title,
            description: tasks[index].description,
            completed: completed,
            ownerId: tasks[index].ownerId
        )
    }
    
    private func resetNewTaskForm() {
        newTaskTitle = ""
        newTaskDescription = ""
        //Maybe add reset of longitude and lattiude and difficulty
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

#Preview {
    let networkManager = NetworkManager()
    let authManager = AuthManager()
    authManager.setToken("set token")
    networkManager.configure(authManager: authManager)
    return TaskView()
        .environment(authManager)
        .environment(networkManager)
        .environment(LocoTasksViewModel())
        
}
