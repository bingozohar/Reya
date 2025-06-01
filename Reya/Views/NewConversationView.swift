//
//  NewConversationView.swift
//  Reya
//
//  Created by Romaryc Pelissie on 01/06/2025.
//

import SwiftUI
import SwiftData

import Defaults

struct NewConversationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedModel: String = Defaults[.model]
    @State private var personaPrompt: String = Defaults[.persona] ?? ""
    
    let onConversationCreated: (Conversation) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Configuration du modèle") {
                    TextField("Modèle", text: $selectedModel)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section("Prompt de personnalité") {
                    TextEditor(text: $personaPrompt)
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .navigationTitle("Nouvelle Conversation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Créer") {
                        createNewConversation()
                    }
                    .disabled(selectedModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func createNewConversation() {
        let newConversation = Conversation(
            model: selectedModel.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        // Assigner le persona prompt s'il n'est pas vide
        if !personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newConversation.personaPrompt = personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Supprimer l'ancienne conversation du contexte si elle existe
        modelContext.insert(newConversation)
        
        // Appeler le callback avec la nouvelle conversation
        onConversationCreated(newConversation)
        
        dismiss()
    }
}
