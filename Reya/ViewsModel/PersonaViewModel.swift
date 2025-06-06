//
//  ReyaModel.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import Foundation
import SwiftData

@MainActor
@Observable
class PersonaViewModel {
    //private var modelContext: ModelContext
    private var generationTask: Task<Void, Never>?
    private var baseURL: URL
    
    var status: ReyaStatus = .busy
    var tempResponse: String = ""
    
    init(/*modelContext: ModelContext, */baseURL: URL) {
        //self.modelContext = modelContext
        self.baseURL = baseURL
    
        //débloque le bouton "submit"
        self.status = .ready
        
        #if DEBUG
        //print("SQLite command: ", self.modelContext.sqliteCommand)
        #endif
    }
    
    func sendUserPrompt(conversation: Conversation, prompt: String) {
        self.status = .busy
        
        //ajoute la saisie de l'utilisateur à la collection
        let userItem: Message = .user(prompt)
        userItem.conversation = conversation
        conversation.items.append(userItem)

        generationTask = Task {
            defer {
                self.status = .ready
            }
            
            do {
                let userRequest = conversation.toOllamaChatRequest()
                let request = OllamaRouter.chat(data: userRequest).asURLRequest(with: baseURL)
                
                //Création d'un item vide pour le mettre à jour à la fin du traitement
                let item : Message = .assistant("")
                conversation.items.append(item)
                
                for try await response: OllamaChatResponse in OllamaService.stream(request: request) {
                    tempResponse += response.message?.content ?? ""
                }
                item.content = tempResponse
                tempResponse = ""
            } catch {
                print(error)
            }
        }
    }
}

enum ReyaStatus: String, Codable {
    case ready
    case busy
}
