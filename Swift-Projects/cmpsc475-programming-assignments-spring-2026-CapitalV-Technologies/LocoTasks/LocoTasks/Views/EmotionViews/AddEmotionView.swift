//
//  AddTaskView.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct AddEmotionView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @Binding var title: String
    @Binding var journalEntry: String
    @Binding var emotion: Emotion
    @Binding var longitude: Double?
    @Binding var latitude: Double?
    let onSave: () -> Void
    let onCancel: () -> Void
    
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                formContent
            }
            .navigationTitle("New Journal Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.pennStateBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onSave()
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
            getLocationSection
            longitudeSection
            latitudeSection
            emotionSection
        }
        .scrollContentBackground(.hidden)
    }
    
    private var titleSection: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Journal Entry Title", text: $title)
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
            TextField("Journal Entry Description", text: $journalEntry, axis: .vertical)
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
                Text("Emotions are hard, but that's what makes you strong.")
            }
            .foregroundStyle(.secondary)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
    }
    
    private var emotionSection: some View {
        let height: CGFloat = 10
        return Picker("Emotion", selection: $emotion) {
            ForEach(Emotion.allCases) { emotion in
                Text(emotion.rawValue)
                    .tag(emotion)
                    .foregroundStyle(.black)
                
            }
        }
        .pickerStyle(.inline)
        .foregroundColor(.white)
        .font(.title3)
        .frame(height: height)
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
        .listRowBackground(Color.clear)
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.pennStateNavy))
    }
    
    
    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

#Preview {
    AddEmotionView(
        title: .constant(""),
        journalEntry: .constant(""),
        emotion: .constant(.happiness),
        longitude: .constant(0.0),
        latitude: .constant(0.0),
        onSave: { print("Save tapped") },
        onCancel: { print("Cancel tapped") }
    )
    .environment(AuthManager())
    .environment(NetworkManager())
    .environment(LocoTasksViewModel())
}
