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
    var personaPrompt: String?
    var timestamp: Date
    
    @Relationship(deleteRule: .cascade)
    var items: [ConversationItem] = []
    
    init(timestamp: Date = Date.now, model: String, personaPrompt: String?) {
        self.timestamp = timestamp
        self.model = model
        self.items = []
        
        self.personaPrompt = personaPrompt
    }
}

extension Conversation {
    func toOllamaChatRequest() -> OllamaChatRequest {
        var messages: [OllamaChatRequest.Message] = []
        
        // Fournit le contexte par defaut
        let context: OllamaChatRequest.Message = .init(role: .user, content: self.personaPrompt ?? "")
        messages.append(context)
        // Parcours les messages pour redonner l'historique
        for item in items {
            if item.role != .system {
                let message: OllamaChatRequest.Message = .init(role: item.role, content: item.content)
                messages.append(message)
            }
        }
        return .init(model: model, messages: messages)
    }
}

extension Conversation {
    var sortedItems: [ConversationItem] {
        return items.sorted { $0.timestamp < $1.timestamp }
    }
}
