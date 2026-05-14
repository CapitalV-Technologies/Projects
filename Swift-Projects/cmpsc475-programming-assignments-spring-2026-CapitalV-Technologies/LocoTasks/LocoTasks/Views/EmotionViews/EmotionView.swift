//
//  MainView.swift
//

import SwiftUI

struct EmotionView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @State private var journalEntries: [JournalEntry] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showAddEntry = false
    @State private var newEntryTitle = ""
    @State private var newJournalEntry = ""
    @State private var newEmotion: Emotion = .happiness
    @State private var longitude: Double?
    @State private var latitude: Double?
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading && journalEntries.isEmpty {
                    LoadingView(text: "emotions")
                } else if journalEntries.isEmpty {
                    EmptyStateView(text: "Emotions")
                } else {
                    EntryListView(
                        entries: journalEntries,
                        onDeleteEntry: deleteEntry
                    )
                }
            }
            .background { backgroundGradient }
            .navigationTitle("Emotions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.pennStateBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar { toolbar }
            .onAppear { loadEntries() }
            .refreshable { await loadEntriesAsync() }
            .alert("Error", isPresented: $showError) {
                Button("OK") { showError = false }
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
            .sheet(isPresented: $showAddEntry) { addEmotionSheet }
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
        ToolbarItem(placement: .topBarLeading) {
                    NavigationLink{
                        GraphView(journalEntries: $journalEntries)
                    } label: {
                        Image(systemName: "chart.pie")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: spacing) {
                Button {
                    showAddEntry = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
    }
    
    private var addEmotionSheet: some View {
        AddEmotionView(
            title: $newEntryTitle,
            journalEntry: $newJournalEntry,
            emotion: $newEmotion,
            longitude: $longitude,
            latitude: $latitude,
            onSave: createNewEntry,
            onCancel: {
                resetNewEntryForm()
                showAddEntry = false
            }
        )
    }

// MAKE ALL THIS LOGIC FOR EMOTIONS
    
    
    // MARK: - Actions
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
    
  
    private func createNewEntry() {
        Task {
            do {
                _ = try await networkManager.createEntry(title: newEntryTitle, date: Date().formatted(), journalEntry: newJournalEntry, emotion: newEmotion.str, longitude: longitude ?? 0, latitude: latitude ?? 0)
                
                await loadEntriesAsync()
                
                resetNewEntryForm()
                showAddEntry = false
            } catch {
                handleError("Failed to create task", error: error)
            }
        }
    }
    
    private func deleteEntry(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let entry = journalEntries[index]
                
                // Optimistically remove from UI
                journalEntries.remove(atOffsets: offsets)
                
                do {
                    try await networkManager.deleteEntry(entryId: entry.id)
                    await loadEntriesAsync()
                } catch {
                    // Revert the optimistic update by refreshing
                    await loadEntriesAsync()
                    handleError("Failed to delete task", error: error)
                }
            }
        }
    }
    
 
    private func resetNewEntryForm() {
        newEntryTitle = ""
        newJournalEntry = ""
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
    return EmotionView()
        .environment(authManager)
        .environment(networkManager)
        .environment(LocoTasksViewModel())
        
}
