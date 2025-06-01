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
    @State private var personaPrompt: String = Defaults[.personaPrompt]
    
    let onConversationCreated: (Conversation) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Selectionner votre modèle") {
                    TextField("Modèle", text: $selectedModel)
                        .labelsHidden()
                }
                
                Spacer()
                
                Section("Modifier le prompt par défaut") {
                    TextEditor(text: $personaPrompt)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 10)
            .navigationTitle(Text("Nouvelle conversation"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        createNewConversation()
                    }
                }
            }
        }
        /*VStack(spacing: 20) {
         
         // Contenu du formulaire
         VStack(alignment: .leading, spacing: 20) {
         // Section Modèle
         VStack(alignment: .leading, spacing: 8) {
         Text("Configuration du modèle")
         .font(.headline)
         .fontWeight(.medium)
         
         TextField("Nom du modèle (ex: llama2, mistral...)", text: $selectedModel)
         .textFieldStyle(RoundedBorderTextFieldStyle())
         .frame(maxWidth: .infinity)
         }
         
         // Section Persona Prompt
         VStack(alignment: .leading, spacing: 8) {
         Text("Prompt de personnalité")
         .font(.headline)
         .fontWeight(.medium)
         
         Text("Définissez le comportement et la personnalité de l'assistant")
         .font(.caption)
         .foregroundColor(.secondary)
         
         ScrollView {
         TextEditor(text: $personaPrompt)
         .frame(minHeight: 200)
         .background(Color(NSColor.textBackgroundColor))
         }
         .overlay(
         RoundedRectangle(cornerRadius: 8)
         .stroke(Color.gray.opacity(0.3), lineWidth: 1)
         )
         .frame(height: 220)
         }
         
         Spacer()
         // Header avec titre et boutons
         HStack {
         Button("Annuler") {
         dismiss()
         }
         .keyboardShortcut(.cancelAction)
         
         Spacer()
         
         Text("Nouvelle Conversation")
         .font(.title2)
         .fontWeight(.semibold)
         
         Spacer()
         
         Button("Créer") {
         createNewConversation()
         }
         .disabled(selectedModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
         .buttonStyle(.borderedProminent)
         .keyboardShortcut(.defaultAction)
         }
         .padding()
         }
         .padding(.horizontal)
         .padding(.bottom)
         }
         .frame(width: 500, height: 400) // Taille fixe pour macOS
         .background(Color(NSColor.windowBackgroundColor))*/
    }
    
    private func createNewConversation() {
        let newConversation = Conversation(
            model: selectedModel.trimmingCharacters(in: .whitespacesAndNewlines),
        )
        
        // Assigner le persona prompt s'il n'est pas vide
        if !personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newConversation.personaPrompt = personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Supprimer l'ancienne conversation du contexte si elle existe
        //modelContext.insert(newConversation)
        
        // Appeler le callback avec la nouvelle conversation
        onConversationCreated(newConversation)
        
        dismiss()
    }
}
