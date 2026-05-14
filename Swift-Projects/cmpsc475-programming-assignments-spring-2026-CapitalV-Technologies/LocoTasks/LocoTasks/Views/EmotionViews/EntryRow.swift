//
//  TaskRow.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct EntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        let spacing: CGFloat = 16
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 12
        HStack(spacing: spacing) {
            taskContent
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .contentShape(Rectangle())
    }
    
    private var taskContent: some View {
        let spacing: CGFloat = 6
        return VStack(alignment: .leading, spacing: spacing) {
            Text(entry.title)
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(Color.pennStateBlue)
            if !entry.journalEntry.isEmpty {
                Text(entry.journalEntry)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            HStack {
                Text(entry.emotion.str)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text("Latitude: \(entry.latitude)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text("Longitude: \(entry.longitude)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    List {
        EntryRow(entry: JournalEntry(
            id: "1",
            title: "Sample Entry",
            journalEntry: "This is a sample Entry description",
        ))
        EntryRow(entry: JournalEntry(
            id: "1",
            title: "Sample Entry",
            journalEntry: "This is a sample Entry description",
        ))
    }
}
