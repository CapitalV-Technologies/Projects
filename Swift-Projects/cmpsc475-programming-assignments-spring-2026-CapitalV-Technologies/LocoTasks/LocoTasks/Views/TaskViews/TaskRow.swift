//
//  TaskRow.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct TaskRow: View {
    let task: TasklyItem
    let onToggle: () -> Void
    
    var body: some View {
        let spacing: CGFloat = 16
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 12
        Button(action: onToggle) {
            HStack(spacing: spacing) {
                checkmarkCircle
                taskContent
                Spacer()
                if task.completed {
                    completedBadge
                }
            }
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private var checkmarkCircle: some View {
        let lineWidth: CGFloat = 2.5
        let width: CGFloat = 32
        let height: CGFloat = 32
        let size: CGFloat = 14
        let response = 0.3
        let dampingFraction = 0.7
        return ZStack {
            Circle()
                .stroke(task.completed ? Color.pennStateBlue : Color.pennStateAccent, lineWidth: lineWidth)
                .frame(width: width, height: height)
            
            if task.completed {
                Image(systemName: "checkmark")
                    .font(.system(size: size, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .background(
            Circle()
                .fill(task.completed ? Color.pennStateBlue : Color.clear)
                .frame(width: width, height: height)
        )
        .contentTransition(.symbolEffect(.replace))
        .animation(.spring(response: response, dampingFraction: dampingFraction), value: task.completed)
    }
    
    private var taskContent: some View {
        let spacing: CGFloat = 6
        return VStack(alignment: .leading, spacing: spacing) {
            Text(task.title)
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(task.completed ? .secondary : Color.pennStateBlue)
                .strikethrough(task.completed, color: .secondary)
            
            if !task.description.isEmpty {
                Text(task.description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            HStack {
                Text("Difficulty: \(Int(task.difficulty))")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text("Latitude: \(task.latitude)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text("Longitude: \(task.longitude)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
    
    private var completedBadge: some View {
        Image(systemName: "checkmark.seal.fill")
            .font(.title3)
            .foregroundStyle(Color.pennStateBlue)
            .symbolEffect(.pulse, value: task.completed)
    }
}

#Preview {
    List {
        TaskRow(task: TasklyItem(
            id: "1",
            title: "Sample Task",
            description: "This is a sample task description",
            completed: false
        )) {
            print("Toggle tapped")
        }
        
        TaskRow(task: TasklyItem(
            id: "2",
            title: "Completed Task",
            description: "This task is completed",
            completed: true
        )) {
            print("Toggle tapped")
        }
    }
}
