//
//  Message.swift
//  Reya
//
//  Created by Romaryc Pelissie on 30/05/2025.
//

import Foundation
import SwiftData

@Model
class Message: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    
    @Relationship
    var conversation: Conversation?
    
    var role: Role
    var timestamp: Date
    var content: String
    
    init(role: Role, timestamp: Date = Date.now, content: String) {
        self.role = role
        self.timestamp = timestamp
        self.content = content
    }
}

extension Message {
    static func user(_ content: String) -> Message {
        Message(role: .user, content: content)
    }
    
    static func assistant(_ content: String) -> Message {
        Message(role: .assistant, content: content)
    }
    
    static func system(_ content: String) -> Message {
        Message(role: .system, content: content)
    }
}
