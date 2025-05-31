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
    
    var type: ConversationItemType
    var timestamp: Date
    var content: String
    
    init(type: ConversationItemType, timestamp: Date = Date.now, content: String) {
        self.type = type
        self.timestamp = timestamp
        self.content = content
    }
}
