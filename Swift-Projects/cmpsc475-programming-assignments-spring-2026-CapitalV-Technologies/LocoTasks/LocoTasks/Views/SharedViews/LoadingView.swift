//
//  LoadingView.swift
//  Taskly
//
//  Created by Nader Alfares on 3/5/26.
//

import SwiftUI

struct LoadingView: View {
    var text: String
    var body: some View {
        let padding: CGFloat = 16
        let scaleEffect = 1.5
        VStack(spacing: padding) {
            ProgressView()
                .scaleEffect(scaleEffect)
                .tint(Color.pennStateBlue)
            Text("Loading \(text)...")
                .foregroundStyle(Color.pennStateBlue)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView(text: "tasks")
}
