//
//  OllamaChatRequest.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import Foundation

struct OllamaChatRequest: Encodable, Sendable {
    let stream: Bool
    let model: String
    let messages: [ChatMessage]
    
    init(stream: Bool = true, model: String, messages: [ChatMessage]) {
        self.stream = stream
        self.model = model
        self.messages = messages
    }
    
    struct ChatMessage: Encodable {
        let role: Role
        let content: String
        let images: [String]?
        
        init(role: Role, content: String, images: [String]? = nil) {
            self.role = role
            self.content = content
            self.images = images
        }
    }
}
