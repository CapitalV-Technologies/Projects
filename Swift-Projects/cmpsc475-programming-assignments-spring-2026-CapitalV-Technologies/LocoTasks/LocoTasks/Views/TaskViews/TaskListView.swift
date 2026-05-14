//
//  TaskListView.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct TaskListView: View {
    let tasks: [TasklyItem]
    let onToggleTask: (String, Bool) -> Void
    let onDeleteTask: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                TaskRow(task: task) {
                    onToggleTask(task.id, !task.completed)
                }
                .listRowBackground(taskRowBackground)
            }
            .onDelete(perform: onDeleteTask)
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Subviews
    
    private var taskRowBackground: some View {
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
    TaskListView(
        tasks: [
            TasklyItem(id: "1", title: "Sample Task", description: "Description", completed: false),
            TasklyItem(id: "2", title: "Completed Task", description: "Done!", completed: true)
        ],
        onToggleTask: { id, completed in
            print("Toggle task \(id) to \(completed)")
        },
        onDeleteTask: { offsets in
            print("Delete at \(offsets)")
        }
    )
}
