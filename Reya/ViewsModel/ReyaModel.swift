//
//  ReyaModel.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import Foundation

@MainActor
class ReyaModel: ObservableObject {
    var baseURL: URL
    @Published var status: ReyaStatus = .ready
    @Published var conversation: Conversation
    
    init(baseURL: URL, conversation: Conversation) {
        self.status = .ready
        self.baseURL = baseURL
        self.conversation = conversation
        
        let item = ConversationItem(type: .system, content: "Model: " + conversation.model)
        self.conversation.items.append(item)
    }
    
    func sendUserPrompt(prompt: String) {
        Task {
            defer {
                self.status = .ready
            }
            do {
                self.status = .generate
                var messages: [OllamaChatRequest.Message] = []
                messages.append(OllamaChatRequest.Message(role: .user, content: prompt))
                
                let userRequest = OllamaChatRequest(model: self.conversation.model, messages: messages)
                let request = OllamaRouter.chat(data: userRequest).asURLRequest(with: baseURL)
                
                let item = ConversationItem(type: .assistant, content: "")
                conversation.items.append(item)
                
                for try await response: OllamaChatResponse in OllamaClient.stream(request: request) {
                    item.content += response.message?.content ?? ""
                    objectWillChange.send()
                }
            } catch {
                print(error)
            }
        }
    }
}

enum ReyaStatus {
    case load
    case ready
    case generate
}
