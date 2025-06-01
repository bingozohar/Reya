//
//  Message.swift
//  Reya
//
//  Created by Romaryc Pelissie on 30/05/2025.
//

import Foundation
import SwiftData

@Model
class ConversationItem: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    
    @Relationship
    var conversation: Conversation?
    
    var role: Role
    var timestamp: Date
    var content: String
    
    init(type: Role, timestamp: Date = Date.now, content: String) {
        self.role = type
        self.timestamp = timestamp
        self.content = content
    }
}
