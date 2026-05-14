//
//  Pokemon.swift
//  Pokedex
//
//  Created by Nader Alfares on 3/6/26.
//
import Foundation

enum PokemonType: String, Codable, Identifiable, CaseIterable  {
    var id: String { self.rawValue }
    
    case bug = "Bug"
    case dragon = "Dragon"
    case electric = "Electric"
    case fighting = "Fighting"
    case fire = "Fire"
    case flying = "Flying"
    case ghost = "Ghost"
    case grass = "Grass"
    case ground = "Ground"
    case ice = "Ice"
    case normal = "Normal"
    case poison = "Poison"
    case psychic = "Psychic"
    case rock = "Rock"
    case water = "Water"
}

struct Pokemon : Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var types: [PokemonType]
    var height: Float
    var weight: Float
    var weaknesses: [PokemonType]
    var prev_evolution: [Int]?
    var next_evolution: [Int]?
    var captured: Bool

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.types = try container.decode([PokemonType].self, forKey: .types)
        self.height = try container.decode(Float.self, forKey: .height)
        self.weight = try container.decode(Float.self, forKey: .weight)
        self.weaknesses = try container.decode([PokemonType].self, forKey: .weaknesses)
        self.next_evolution = try container.decodeIfPresent([Int].self, forKey: .next_evolution)
        self.prev_evolution = try container.decodeIfPresent([Int].self, forKey: .prev_evolution)
        self.captured = try container.decodeIfPresent(Bool.self, forKey: .captured) ?? false
    }
    
    init(id: Int, name: String, types: [PokemonType], height: Float, weight: Float, weaknesses: [PokemonType], next_evolution: [Int]?, prev_evolution: [Int]?, captured: Bool = true) {
        self.id = id
        self.name = name
        self.types = types
        self.height = height
        self.weight = weight
        self.weaknesses = weaknesses
        self.captured = captured
    }
    
    static let standard = Pokemon(id: 001, name: "Bulbasaur", types: [.grass,.poison], height: 0.71, weight: 6.9, weaknesses: [.fire,.ice,.flying,.psychic], next_evolution: nil, prev_evolution: [2,3])
    
    
    
}

