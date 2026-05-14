//
//  JournalEntry.swift
//  LocoTasks
//
//  Created by LiasPub on 4/17/26.
//

import Foundation


struct JournalEntry: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String = ""
    var date: String = Date().formatted()
    var journalEntry: String = ""
    var emotion: Emotion = .happiness
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var ownerId: String = ""
   
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case journalEntry
        case emotion
        case longitude
        case latitude
        case ownerId = "owner_id"
    }
}

// Only give these possible options for emotions due to needed to calculate graph
enum Emotion: String, Decodable, Encodable, CaseIterable, Identifiable {
    case happiness = "Happiness"
    case anger = "Anger"
    case disgust = "Disgust"
    case fear = "Fear"
    case sadness = "Sadness"
    case surprise = "Surprise"
    
    var id : Self { self }
    
    var str : String {
        switch self {
        case .happiness: return "Happiness"
        case .anger: return "Anger"
        case .disgust: return  "Disgust"
        case .fear: return  "Fear"
        case .sadness: return  "Sadness"
        case .surprise: return  "Surprise"
        }
    }
}
