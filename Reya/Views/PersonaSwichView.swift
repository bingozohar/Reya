//
//  NewConversationView.swift
//  Reya
//
//  Created by Romaryc Pelissie on 01/06/2025.
//

import SwiftUI
import SwiftData

import Defaults

struct PersonaSwiftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var personas = [Persona]()
    @State private var selectedPersona: String?
    
    @State private var personaName: String = ""
    @State private var personaDescription: String = ""
    @State private var personaModel: String = ""
    @State private var personaPrompt: String = ""
    @State private var resetPersona: Bool = false
    
    @State private var availableModels: [String] = [
        "gemma3",
        "gemma3:12b",
        "llama3.2",
        "mistral:7b",
        "qwen3:8b",
        "llava"
    ]
    
    let onPersonaSwitch: (Persona, Bool) -> Void
    
    var body: some View {
        NavigationStack {
            
            HStack(alignment: .top) {
                List(personas, id: \.self.id, selection: $selectedPersona) { persona in
                    Text(persona.id)
                }
                .onChange(of: selectedPersona, initial: true) { _, _ in
                    if let persona = personas.first(where: { $0.id == selectedPersona}) {
                        personaName = persona.id
                        personaDescription = persona.details
                        personaModel = persona.model
                        personaPrompt = persona.prompt
                    }
                }
                VStack(alignment: .leading) {
                    if selectedPersona != nil {
                        Form {
                            Section() {
                                Toggle("Clear conversation", isOn: $resetPersona)
                            }
                            Section("Choose your model") {
                                Picker("", selection: $personaModel) {
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
                    }
                }
                .padding()
            }
        }
        .navigationTitle(Text("Start a new Conversation"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Start") {
                    switchPersona()
                }
            }
        }
        .onAppear {
            personas = decode("personas.json")
            selectedPersona = personas.first?.id ?? ""
        }
        .frame(minWidth: 200, minHeight: 300)
    }
    
    private func decode(_ file: String) -> [Persona] {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            fatalError("Faliled to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load file from \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedFile = try? decoder.decode([Persona].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle")
        }
        
        return loadedFile
    }
    
    private func switchPersona() {
        /*let newConversation = Conversation(
            model: personaModel.trimmingCharacters(in: .whitespacesAndNewlines),
            personaName: ""
        )
        // Assigner le persona prompt s'il n'est pas vide
        if !personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newConversation.personaPrompt = personaPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        }*/
        onPersonaSwitch(
            Persona(
                id: personaName,
                description: personaDescription,
                prompt: personaPrompt,
                model: personaModel,
            ),
            self.resetPersona
        )
        dismiss()
    }
}
