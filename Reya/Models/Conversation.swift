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
    var context: String?
    
    @Relationship(deleteRule: .cascade)
    var items: [ConversationItem] = []
    
    init(model: String) {
        self.model = model
        self.items = []
        
        self.context = "Je suis un assistant virtuel nommé Reya. Je vais vous parler en français."
    }
}
