//
//  TaskListView.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct EntryListView: View {
    let entries: [JournalEntry]
    let onDeleteEntry: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(entries) { entry in
                EntryRow(entry: entry)
                .listRowBackground(entryRowBackground)
            }
            .onDelete(perform: onDeleteEntry)
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Subviews
    
    private var entryRowBackground: some View {
        let cornerRadius: CGFloat = 12
        let opacity = 0.1
        let radius: CGFloat = 2
        let x: CGFloat = 0
        let y: CGFloat = 1
        let padding: CGFloat = 4
        return RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white)
            .shadow(color: Color.pennStateBlue.opacity(opacity), radius: radius, x: x, y: y)
            .padding(.vertical, padding)
    }
}

#Preview {
    EntryListView(
        entries: [
            JournalEntry(
                id: "1",
                title: "Sample Entry",
                journalEntry: "This is a sample Entry description",
            ),
            JournalEntry(
                id: "1",
                title: "Sample Entry",
                journalEntry: "This is a sample Entry description",
            )
        ],
        onDeleteEntry: { offsets in
            print("Delete at \(offsets)")
        }
    )
}
