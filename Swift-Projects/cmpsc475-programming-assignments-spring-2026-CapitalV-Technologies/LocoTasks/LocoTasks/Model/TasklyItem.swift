//
//  TasklyItem.swift
//  Taskly
//
//  Created by Nader Alfares on 3/1/26.
//
import Foundation

//Updated Task Item on Backend API as well
struct TasklyItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String = ""
    var description: String = ""
    var difficulty: Double = 1.0
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var completed: Bool = false
    var ownerId: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case difficulty
        case longitude
        case latitude
        case completed
        case ownerId = "owner_id"
    }
}
