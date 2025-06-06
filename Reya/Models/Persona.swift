//
//  Persona.swift
//  Reya
//
//  Created by Romaryc Pelissie on 05/06/2025.
//

import Foundation

struct Persona: Identifiable, Codable {
    var id: String
    var details: String
    var prompt: String
    var model: String
    
    init(id: String, description: String, prompt: String, model: String) {
        self.id = id
        self.details = description
        self.prompt = prompt
        self.model = model
    }
}
