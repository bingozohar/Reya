//
//  Conversation.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import Foundation
import SwiftData

@Model
class Conversation: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    
    var model: String
    var persona: Persona
    //var personaName: String
    //var personaDescription: String
    //var personaPrompt: String
    var timestamp: Date
    
    @Relationship(deleteRule: .cascade)
    var items: [Message] = []
    
    init(timestamp: Date = Date.now, model: String, persona: Persona) {
        self.timestamp = timestamp
        self.model = model
        self.items = []
        self.persona = persona
        //self.personaName = personaName
        //self.personaDescription = personaDescription
        //self.personaPrompt = personaPrompt
    }
}

extension Conversation {
    func toOllamaChatRequest() -> OllamaChatRequest {
        var messages: [OllamaChatRequest.ChatMessage] = []
        
        // Fournit le contexte par defaut
        let context: OllamaChatRequest.ChatMessage = .init(role: .system, content: self.persona.prompt)
        messages.append(context)
        // Parcours les messages pour redonner l'historique
        for item in items {
            if item.role != .system {
                let message: OllamaChatRequest.ChatMessage = .init(role: item.role, content: item.content)
                messages.append(message)
            }
        }
        return .init(model: model, messages: messages)
    }
}

extension Conversation {
    var sortedItems: [Message] {
        return items.sorted { $0.timestamp < $1.timestamp }
    }
}
