//
//  EmptyStateView.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct EmptyStateView: View {
    var text: String
    var body: some View {
        let padding: CGFloat = 275
        ScrollView {
            ContentUnavailableView {
                Label("No \(text)", systemImage: "checklist")
                    .foregroundStyle(Color.pennStateBlue)
            } description: {
                Text("Tap the + button to create your first entry")
                    .foregroundStyle(.secondary)
            }
            .padding(.top, padding)
        }
    }
}

#Preview {
    EmptyStateView(text: "Tasks")
}
