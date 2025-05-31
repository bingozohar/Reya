//
//  OllamaChatResponse.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import Foundation

struct OllamaChatResponse: Decodable, Sendable {
    let model: String
    //Remettre au format date
    let createdAt: Date
    let message: Message?
    let done: Bool
    let doneReason: String?
    let totalDuration: Int?
    let loadDuration: Int?
    let promptEvalCount: Int?
    let promptEvalDuration: Int?
    let evalCount: Int?
    let evalDuration: Int?
 
    struct Message: Decodable, Sendable {
        let role: Role
        let content: String
    }
}
