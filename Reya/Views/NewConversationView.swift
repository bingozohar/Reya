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
    @State private var availableModels: [String] = [
        "gemma3",
        "gemma3:12b",
        "llama3.2",
        "mistral:7b",
        "qwen3:8b",
        "llava"
    ]
    
    let onConversationCreated: (Conversation) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Choose your model") {
                    Picker("Model", selection: $selectedModel) {
                        ForEach(availableModels, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Configure prompt used as persona") {
                    TextEditor(text: $personaPrompt)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 10)
            .navigationTitle(Text("Start a new Conversation"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        createNewConversation()
                    }
                }
            }
        }
    }
    
    private func createNewConversation() {
        let newConversation = Conversation(
            model: selectedModel.trimmingCharacters(in: .whitespacesAndNewlines),
        )
        // Assigner le persona prompt s'il n'est pas vide
        if !personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newConversation.personaPrompt = personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        onConversationCreated(newConversation)
        dismiss()
    }
}
