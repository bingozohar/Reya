//
//  ContentView.swift
//  Reya
//
//  Created by Romaryc Pelissie on 30/05/2025.
//

import SwiftUI
import SwiftData

import Defaults
import MarkdownUI
import ViewCondition

struct PersonaView: View {
    @Environment(\.modelContext) private var modelContext
    private let baseURL: URL? = Defaults[.host]

    @State private var prompt: String = ""
    @State private var reyaModel: ReyaModel?
    @State private var conversation: Conversation?
    @State private var showingPersonaSwichSheet = false
    
    // L'animation suit automatiquement l'état de l'AI
    private var shouldAnimateHeader: Bool {
        reyaModel?.status == .busy
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PersonaHeaderView(
                name: conversation?.personaName ?? "",
                description: conversation?.personaDescription ?? "",
                model: conversation?.model ?? "",
                isAnimationActive: .constant(shouldAnimateHeader)) {
                    self.showingPersonaSwichSheet = true
                }
            if let reyaModel = self.reyaModel, let conversation = self.conversation {
                ConversationView(conversation: conversation, tempResponse: reyaModel.tempResponse)
                WriteMessageView(prompt: $prompt, status: reyaModel.status, sendMessage: sendMessage)
                    .border(width: 2, edges: [.top], color: .mint)
                    .padding()
            }
        }
        .sheet(isPresented: $showingPersonaSwichSheet) {
            PersonaSwiftView { persona, reset in
                switchPersona(persona, reset: reset)
            }
        }
        .onAppear {
            if reyaModel == nil {
                reyaModel = ReyaModel(
                    modelContext: self.modelContext,
                    baseURL: self.baseURL!
                )
            }
            
            if let lastConversation = loadConversation() {
                self.conversation = lastConversation
            }
            else {
                self.showingPersonaSwichSheet = true
            }
        }
    }
    
    private func loadConversation(personaName: String? = nil) -> Conversation? {
        let descriptor : FetchDescriptor<Conversation>
        
        if let personaName {
            descriptor = FetchDescriptor<Conversation>(predicate: #Predicate { conversation in conversation.personaName == personaName}, sortBy: [SortDescriptor(\.timestamp)])
        } else {
            descriptor = FetchDescriptor<Conversation>(sortBy: [SortDescriptor(\.timestamp)])
        }
        
        let conversations = try? modelContext.fetch(descriptor)
        return conversations?.last ?? nil
    }
    
    private func copyAction(_ content: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)
    }
    
    private func sendMessage() {
        guard prompt.isNotEmpty, let reyaModel = reyaModel else { return }
        //Créer une copie du prompt
        let prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        reyaModel.sendUserPrompt(conversation: conversation!, prompt: prompt)
        //Ré-initialise la valeur du prompt
        self.prompt = ""
    }
    
    private func switchPersona(_ persona: Persona, reset: Bool) {
        self.conversation = nil
        if let lastConversation = loadConversation(personaName: persona.id) {
            if reset {
                modelContext.delete(lastConversation)
            } else {
                lastConversation.timestamp = Date.now
                lastConversation.model = persona.model
                lastConversation.personaPrompt = persona.prompt
                self.conversation = lastConversation
            }
        }
        
        if self.conversation == nil {
            let newConversation = Conversation(
                model: persona.model,
                personaName: persona.id,
                personaDescription: persona.description,
                personaPrompt: persona.prompt
            )
            modelContext.insert(newConversation)
            self.conversation = newConversation
        }
    }
}
/*
#Preview {
    PersonaView()
}
*/
