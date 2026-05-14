//
//  ContentView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/19/26.
//

import SwiftUI

struct MainView: View {
    // Notes from Lecture
    // For concurrency: Anything UI related happens on the main thread.
    // Wrapping a call to an async function with a Task wrapper tells the compiler, create a new thread here and run simultaneously and wait till that function completes (with an await) and then do this post-processing instructions. (all within the Task Wrapper)
    // Your async code could be running on the main thread if the main thread isn't busy!! So you don't always know where your async code is running
    
    @Environment(PentominoesViewModel.self) var manager: PentominoesViewModel
    let padding: CGFloat = 40
    let lineWidth: CGFloat = 1
    var body: some View {
        @Bindable var manager = manager
        ZStack {
            backgroundColor.ignoresSafeArea()
            ScrollView {
                VStack (spacing: 5){
                    TitleView(text: "PENTOMINOES")
                    HStack (alignment: .top){
                        VStack (alignment: .leading) {
                            PuzzleButtonsView(image: "Board0", index: -1)
                            PuzzleButtonsView(image: "Board1", index: 0)
                            PuzzleButtonsView(image: "Board2", index: 1)
                            PuzzleButtonsView(image: "Board3", index: 2)
                        }
                        .padding(.horizontal, padding)
                        ZStack (alignment: .topLeading) {
                            GridShapeView(rows: manager.gameBoardSize, columns: manager.gameBoardSize)
                                .stroke(.black, lineWidth: lineWidth)
                                .frame(width: CGFloat(manager.frame), height: CGFloat(manager.frame))
                                .background(RoundedRectangle(cornerRadius: 1).fill(.white))
                            if manager.showPuzzle {
                                PuzzleView(puzzle: manager.currentPuzzle!)
                                    .position(x: CGFloat(manager.puzzleCenter), y: CGFloat(manager.puzzleCenter))
                            }
                            
                            
                            ForEach ($manager.pentominoPieces) { $piece in
                                PieceView(piece: $piece)
                            }
                        }
                        .padding(.vertical, padding)
                        VStack {
                            PuzzleButtonsView(image: "Board4", index: 3)
                            PuzzleButtonsView(image: "Board5", index: 4)
                            PuzzleButtonsView(image: "Board6", index: 5)
                            PuzzleButtonsView(image: "Board7", index: 6)
                        }
                        .padding(.horizontal, padding)
                    }
                    HStack (alignment: .bottom) {
                        GameButtonsView(text: "Reset", color: .orange, function: manager.resetPositions)
                        Spacer()
                        GameButtonsView(text: "Solve", color: .pink, function: manager.solveSolution)
                            .disabled(manager.showPuzzle ? false : true)
                            .opacity(manager.showPuzzle ? 1.0 : 0.5)
                    }
                    .padding(.horizontal, padding * 2)
                    .padding(.top, padding)
                }
            }
            .frame(width: .infinity, height: .infinity)
        }
    }
    
    let backgroundColor : LinearGradient = LinearGradient(
                gradient: Gradient(colors: [
                    Color(.blue),
                    Color(red: 0.36, green: 0.24, blue: 0.66)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
}

#Preview {
    MainView()
        .environment(PentominoesViewModel())
}
