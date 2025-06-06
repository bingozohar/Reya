//
//  Persona.swift
//  Reya
//
//  Created by Romaryc Pelissie on 05/06/2025.
//

import Foundation

struct Persona: Identifiable, Codable {
    let id: String
    let description: String
    let prompt: String
    let model: String
    
    init(id: String, description: String, prompt: String, model: String) {
        self.id = id
        self.description = description
        self.prompt = prompt
        self.model = model
    }
}
