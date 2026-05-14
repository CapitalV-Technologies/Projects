//
//  PentominoGridView.swift
//  Pentominoes
//
//  Created by LiasPub on 2/23/26.
//

import SwiftUI

struct PieceView: View {
    @Environment(PentominoesViewModel.self) var manager: PentominoesViewModel
    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero
    
    @State private var isTapped = false
    @Binding var piece: Piece
    
    var body: some View {
        let scaleEffect = 1.2
        let opacity = 0.5
        let dragGesture = DragGesture()
            .onChanged { value in
                withAnimation {
                    isDragging = true
                }
                dragOffset = value.translation
            }
            .onEnded { value in
                let blockSize = CGFloat(manager.blockSize)
                    

                    let currentX = CGFloat(piece.position.x) + value.translation.width
                    let currentY = CGFloat(piece.position.y) + value.translation.height
                    var addhalfU1 = false
                    var addhalfU2 = false
                var addhalfP = false
                if piece.outline.name == "U" && (piece.position.orientation == .up ||  piece.position.orientation == .down){
                    addhalfU1 = false
                }
                
                if piece.outline.name == "U" && (piece.position.orientation == .right ||  piece.position.orientation == .left){
                    addhalfU2 = true
                }
                
                if piece.outline.name == "P" && (piece.position.orientation == .right ||  piece.position.orientation == .left){
                    addhalfP = true
                }
                let snappedX = (currentX / blockSize).rounded() * blockSize + (addhalfU1 ? (blockSize / 2) : 0) + (addhalfU2 ? (blockSize / 2) : 0) + (addhalfP ? (blockSize / 2) : 0)
                let snappedY = (currentY / blockSize).rounded() * blockSize + (addhalfU2 ? (blockSize / 2) : 0) + (addhalfP ? (blockSize / 2) : 0)
                    
                    withAnimation(.spring(response: 0.3)) {
                        piece.position.x = Int(snappedX)
                        piece.position.y = Int(snappedY)
                        dragOffset = .zero
                        isDragging = false
                    }
            }
        
        let tapGesture = TapGesture()
            .onEnded { _ in
                piece.position.checkLongGestureOrientation()
                piece.position.orientation = piece.position.next_orientation
                
                let blockSize = CGFloat(manager.blockSize)
                let currentX = CGFloat(piece.position.x)
                let currentY = CGFloat(piece.position.y)
                var addhalfU1 = false
                var addhalfU2 = false
            var addhalfP = false
            if piece.outline.name == "U" && (piece.position.orientation == .up ||  piece.position.orientation == .down){
                addhalfU1 = false
            }
            
            if piece.outline.name == "U" && (piece.position.orientation == .right ||  piece.position.orientation == .left){
                addhalfU2 = true
            }
            
            if piece.outline.name == "P" && (piece.position.orientation == .right ||  piece.position.orientation == .left){
                addhalfP = true
            }
            let snappedX = (currentX / blockSize).rounded() * blockSize + (addhalfU1 ? (blockSize / 2) : 0) + (addhalfU2 ? (blockSize / 2) : 0) + (addhalfP ? (blockSize / 2) : 0)
            let snappedY = (currentY / blockSize).rounded() * blockSize + (addhalfU2 ? (blockSize / 2) : 0) + (addhalfP ? (blockSize / 2) : 0)
                
                withAnimation(.spring(response: 0.3)) {
                    piece.position.x = Int(snappedX)
                    piece.position.y = Int(snappedY)
                }
            }
        
        
        let longPressGesture = LongPressGesture()
            .onEnded { _ in
                piece.position.checkTapGestureOrientation()
                piece.position.orientation = piece.position.next_orientation
                
            }
        
        let combinedGestures = dragGesture.exclusively(before: longPressGesture.simultaneously(with: tapGesture))
        
            PentominoView(pentomino: piece.outline)
            .opacity(manager.checkIfCorrect(piece: piece) ? opacity : 1.0)
        // X Axis
            .rotation3DEffect(
                            .degrees(piece.position.rotation.0),
                            axis: (x: 1.0, y: 0, z: 0)
                        )
        // Y Axis
            .rotation3DEffect(
                            .degrees(piece.position.rotation.1),
                            axis: (x: 0, y: 1.0, z: 0)
                        )
        // Z Axis
            .rotation3DEffect(
                            .degrees(piece.position.rotation.2),
                            axis: (x: 0, y: 0, z: 1.0)
                        )
            .offset(dragOffset)
            // Make piece snap on Grid View
            .offset(x: CGFloat(piece.position.x),y: CGFloat(piece.position.y))
            //.animation(.easeIn(duration:1))
            .gesture(combinedGestures)
            .scaleEffect(isDragging ? scaleEffect : 1.0)
            
            .shadow(color: .black.opacity(isDragging ? 0.4 : 0), radius: isDragging ? 10 : 0)
            .zIndex(isDragging ? 100 : 0)
            .animation(.easeInOut(duration: 0.5), value: piece.position)
    }
}
