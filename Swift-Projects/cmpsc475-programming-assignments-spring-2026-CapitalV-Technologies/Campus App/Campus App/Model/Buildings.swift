//
//  Buildings.swift
//  Campus App
//
//  Created by LiasPub on 3/16/26.
//

import Foundation


enum Lists: String, CaseIterable, Identifiable {
    case all = "All"
    case selected = "Selected"
    case favorited = "Favorited"
    
    var id : String { rawValue }
}

struct BuildingEntry: Decodable, Hashable, Identifiable, Encodable {
    var id: UUID = UUID()
    var latitude: Double
    var longitude: Double
    var name: String
    var opp_bldg_code: Double
    var photo: String?
    var year_constructed: Int?
    var isSelected: Bool
    var isFavorited: Bool
    
    // Use custom decoder with decodeIfPresent since some values might be NULL
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            latitude = try container.decode(Double.self, forKey: .latitude)
            longitude = try container.decode(Double.self, forKey: .longitude)
            name = try container.decode(String.self, forKey: .name)
            opp_bldg_code = try container.decode(Double.self, forKey: .opp_bldg_code)
            // Optional decoding: returns nil if not found
            photo = try container.decodeIfPresent(String.self, forKey: .photo)
            year_constructed = try container.decodeIfPresent(Int.self, forKey: .year_constructed)
            
        // try to decode isSelected and isFavorited
        // If error, then just set them as false because then this is first load
        do {
            isSelected = try container.decode(Bool.self, forKey: .isSelected)
        } catch {
            isSelected = false
        }
        do {
            isFavorited = try container.decode(Bool.self, forKey: .isFavorited)
        } catch {
            isFavorited = false
        }
            
        }

        enum CodingKeys: String, CodingKey {
            case latitude, longitude, name, opp_bldg_code, photo, year_constructed, isSelected, isFavorited
        }
}

// Used MindFlip App to help structure this architecture
struct BuildingList {
    var buildingLists: [BuildingEntry] = []
    
    private let filename = "buildings"
    
    init() {
        loadFromJSON(filename: filename)
    }

    mutating func loadFromJSON(filename: String) {
        // First try to load from documents directory (user's saved data)
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("\(filename).json")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    buildingLists = try decoder.decode([BuildingEntry].self, from: data)
                    print("Successfully loaded buildings from: \(fileURL.path)")
                    return
                } catch {
                    print("Failed to load buildings from documents: \(error)")
                }
            }
        }
        
        // Fallback: Try to load from bundle (initial data)
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("JSON file not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            buildingLists = try decoder.decode([BuildingEntry].self, from: data)
            print("Successfully loaded buildings from bundle")
        } catch {
            print("Failed to load buildings: \(error)")
        }
        
    }
    
    
    // Save current entries of buildings
    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self.buildingLists)
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectory.appendingPathComponent(filename + ".json")
            
            try data.write(to: fileURL)
            
            
        } catch {
            print("Failed save json", error)
            
        }
    }
}
