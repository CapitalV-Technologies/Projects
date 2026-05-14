//
//  MembersView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct MembersView: View {
    var email: String
    @State var showSheet: Bool = false
    var body: some View {
        let shadowRadius: CGFloat = 4
        let radius: CGFloat = 16
        let height: CGFloat = 80
        let width: CGFloat = 360
        let spacing: CGFloat = 5
        HStack {
            Text(email)
                .bold()
                .font(.title2)
            Spacer()
            Button {
                showSheet.toggle()
                // Make this pull up AddTaskView, but then add the task for the other users account
                // Will try to reuse views here, but might just recreate them if too difficult
            } label: {
                VStack (spacing: spacing){
                    Text("Add Task to this member's account")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .padding()
        .frame(width: width, height: height)
        .background(RoundedRectangle(cornerRadius: radius).fill(.white).shadow(color: .black, radius: shadowRadius))
        .sheet(isPresented: $showSheet) {
            AddGroupMemberTaskView(email: email)
        }
    }
}
