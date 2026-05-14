//
//  Pentominoes
//  Starter code for model
//  CMPSC475
//
import Foundation


//Mark:- Shapes models
struct Point: Decodable{
    let x : Int
    let y : Int
}

struct Size: Decodable {
    let width : Int
    let height : Int
}

typealias Outline = [Point]
typealias Outlines = [Outline]

struct PentominoOutline: Decodable {
    let name : String
    let size : Size
    let outline : Outline
}

struct PuzzleOutline: Decodable {
    let name : String
    let size : Size
    let outlines : Outlines
}


// a Piece is the model data that the view uses to display a pentomino
struct Piece: Identifiable {
    let id: UUID = UUID()
    var position : Position = Position()
    var outline : PentominoOutline
    
}

//Mark:- Pieces Model
// identifies placement of a single pentomino on a board, including x/y coordinate and its rotations.
//Order of rotations matters - X, Y, then Z.  Uses unit coordinates on a 14 x 14 board
struct Position: Decodable, Equatable  {
    var x : Int = 0
    var y : Int = 0
    //TODO: extend with orientation information
    var orientation: Orientation = .up
    var next_orientation: Orientation {
        switch orientation {
            case .up: return .left
            case .left: return .down
            case .down: return .right
            case .right: return .up
            case .upMirrored: return .downMirrored
            case .leftMirrored: return .rightMirrored
            case .downMirrored: return .upMirrored
            case .rightMirrored: return .leftMirrored
        }
    }
    
    mutating func checkTapGestureOrientation() {
        if self.orientation == .up {
            self.orientation = .upMirrored
        } else if self.orientation == .down {
            self.orientation = .downMirrored
        } else if self.orientation == .left {
            self.orientation = .leftMirrored
        } else if self.orientation == .right {
            self.orientation = .rightMirrored
        }
    }
    
    mutating func checkLongGestureOrientation() {
        if self.orientation == .upMirrored {
            self.orientation = .up
        } else if self.orientation == .downMirrored {
            self.orientation = .down
        } else if self.orientation == .leftMirrored {
            self.orientation = .left
        } else if self.orientation == .rightMirrored {
            self.orientation = .right
        }
    }
    
    var rotation: (CGFloat, CGFloat, CGFloat) {
        switch orientation {
            case .up: return (0,0,0)
            case .left: return (0,0,90)
            case .down: return (0,0,180)
            case .right: return (0,0,270)
            case .upMirrored: return (0,180,0)
            case .leftMirrored: return (0,180,90)
            case .downMirrored: return (0,180,180)
            case .rightMirrored: return (0,180,270)
        }
    }
}


// This Orientation type is identical to UIImage.Orientation.  We define it to avoid needing UIKit in the model.  See documentation for this type to see what each value means in terms of rotations and flips.
enum Orientation : String, Decodable {
    case up, left, down, right
    case upMirrored, leftMirrored, downMirrored, rightMirrored
}

typealias Solutions = [String: [String: Position]]
