//
//  OwnerView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/16/26.
//

import SwiftUI

struct OwnerView: View {
    @Environment(AuthManager.self) var authManager
    @Environment(NetworkManager.self) var networkManager
    @Environment(LocoTasksViewModel.self) var manager
    
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var newGroupTitle = ""
    @State private var deleteGroupTitle = ""
    
    @State private var inviteEmail = ""
    @Binding var currentGroup: GroupItem?
    @FocusState private var isTitleFocused: Bool
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack {
                Text("Your Groups")
                    .bold()
                    .font(.largeTitle)
                Text("Currently Selected Group: \(currentGroup?.title ?? "" )")
                    .font(.caption)
                    .bold()
                formContent
            }
        }
    }
    
    private var formContent: some View {
        let width: CGFloat = 360
        let height: CGFloat = 50
        let cornerRadius: CGFloat = 12
        return Form {
                Button {
                    createNewGroup()
                } label: {
                    Text("Add Group")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: width, height: height)
                        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.pennStateLightBlue))
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .disabled(isAddGroupDisabled)
                titleSection
                Button {
                    addNewMember()
                } label: {
                    Text("Invite Member")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: width, height: height)
                        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.pennStateLightBlue))
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .disabled(isInviteMemberDisabled || (currentGroup == nil))
                inviteMember
                Button {
                    deleteGroup()
                } label: {
                    Text("Delete Group")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: width, height: height)
                        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(.red))
                }
                .disabled(isDeleteGroupDisabled)
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                titleSectionDelete
            }
        .scrollContentBackground(.hidden)
    }
    
    private func createNewGroup() {
        Task {
            do {
                _ = try await networkManager.createGroup(
                    title: newGroupTitle
                )
                
                //await loadTasksAsync()
                
                resetNewGroupForm()
                
            } catch {
                handleError("Failed to create task", error: error)
            }
        }
    }
    
    private func addNewMember() {
        Task {
            do {
                _ = try await networkManager.addMember(
                    email: inviteEmail, with: currentGroup!)
                
                
                //await loadTasksAsync()
                
                resetIniteEmailForm()
                
            } catch {
                handleError("Failed to add group member", error: error)
            }
        }
    }
    
    
    // Delete by title
    private func deleteGroup() {
        Task {
                do {
                    try await networkManager.deleteGroup(groupTitle: deleteGroupTitle)
                    resetdeleteForm()
                } catch {
                    // Revert the optimistic update by refreshing
                    resetdeleteForm()
                    handleError("Failed to delete task", error: error)
                }
            }
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
    
    private func resetNewGroupForm() {
        newGroupTitle = ""
    }
    
    private func resetdeleteForm() {
        deleteGroupTitle = ""
    }
    
    private func resetIniteEmailForm() {
        inviteEmail = ""
    }
    
    let backgroundColor: LinearGradient = LinearGradient(
       gradient: Gradient(colors: [
        Color(red: 0.95, green: 0.94, blue: 0.88),
        Color(red: 0.93, green: 0.91, blue: 0.85),
        Color(red: 0.90, green: 0.89, blue: 0.83)
       ]),
       startPoint: .topLeading,
       endPoint: .bottomTrailing
   )
    
    private var titleSection: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Group Title", text: $newGroupTitle)
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
    
    private var titleSectionDelete: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Group Title", text: $deleteGroupTitle)
                .focused($isTitleFocused)
                .font(.body)
        } header: {
            Text("Title of Group you want to Delete")
                .foregroundStyle(Color.pennStateBlue)
                .fontWeight(.semibold)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
        )
    }
    
    private var inviteMember: some View {
        let cornerRadius: CGFloat = 12
        return Section {
            TextField("Enter their email", text: $inviteEmail)
                .focused($isTitleFocused)
                .font(.body)
                .textInputAutocapitalization(.never)
        } header: {
            Text("Invite Member")
                .foregroundStyle(Color.pennStateBlue)
                .fontWeight(.semibold)
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
        )
    }
    
    private var isAddGroupDisabled: Bool {
        newGroupTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var isDeleteGroupDisabled: Bool {
        deleteGroupTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var isInviteMemberDisabled: Bool {
        inviteEmail.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
