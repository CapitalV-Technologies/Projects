//
//  ListView.swift
//  Pokedex
//
//  Created by LiasPub on 3/22/26.
//

import SwiftUI

struct ListView: View {
    @Binding var items: [Pokemon]
    
    // Create computed variable for searching
        var filtered: [Pokemon] {
            var results: [Pokemon] = items
            
            if capturedSelected {
                results = results.filter { pokemon in
                    return pokemon.captured
                }
            }
            
            if !selected.isEmpty {
                results = results.filter { pokemon in
                    var typeFound = false
                    for type in pokemon.types {
                        if selected.contains(type) {
                            typeFound = true
                        }
                    }
                    if typeFound {
                        return true
                    }
                    return false
                }
            }
            
            
            if !userInput.isEmpty {
                results = results.filter { pokemon in
                    pokemon.name.localizedCaseInsensitiveContains(userInput)
                }
            }
            return results
        }
    
    @State var selected: Set<PokemonType> = []
    @State var capturedSelected: Bool = false
    @State var userInput = ""
    var body: some View {
        let searchToolbar = ToolbarItem(placement: .topBarTrailing) {
            ToolbarMenuPicker(systemImage: "magnifyingglass", selected: $selected, capturedSelected: $capturedSelected, options: PokemonType.allCases) { type in
                type.id
            }
        }
        NavigationStack {
            List(filtered, id: \.self) { pokemon in
                PokemonListView(pokemon: pokemon)
            }
            .toolbar {
                searchToolbar
                
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Pokedex")
        }
        .searchable(text: $userInput, placement: .navigationBarDrawer, prompt: "Search Pokemon")
    }
    
    fileprivate struct ToolbarMenuPicker: View {
        let systemImage: String
        @Binding var selected: Set<PokemonType>
        @Binding var capturedSelected: Bool
        let options: [PokemonType]
        let title: (PokemonType) -> String

        var body: some View {
            Menu {
                Button {
                    selected = []
                    capturedSelected = false
                } label: {
                    Text("Clear All filters")
                }
                Button {
                    capturedSelected.toggle()
                } label: {
                    Text("Captured")
                    if capturedSelected {
                        Image(systemName: "checkmark")
                    }
                }
                ForEach(options, id: \.self) { option in
                    Button {
                        selected.insert(option)
                    } label: {
                        Text(title(option))
                        if (selected.contains(option)) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                Image(systemName: systemImage)
            }
        }
    }
}
