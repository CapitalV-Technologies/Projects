//
//  Groups.swift
//  LocoTasks
//
//  Created by LiasPub on 4/30/26.
//

import Foundation

struct GroupItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String = ""
    var ownerId: String = ""
    var members: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case ownerId = "owner_id"
        case members
    }
}
