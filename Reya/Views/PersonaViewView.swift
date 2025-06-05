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
    @Query(sort: \Conversation.timestamp) var conversations: [Conversation]
    
    private let baseURL: URL? = Defaults[.host]
    
    @State private var conversation: Conversation?
    @State private var reyaModel: ReyaModel?
    @State private var prompt: String = ""
    @State private var showingPersonaSwichSheet = false
    
    //@State private var scrollProxy: ScrollViewProxy? = nil
    let personaInfo: String = "**Je suis Reya,** *comment puis-je vous aider aujourd'hui?*"
    
    // L'animation suit automatiquement l'état de l'AI
    private var shouldAnimateHeader: Bool {
        reyaModel?.status == .busy
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PersonaHeaderView(
                assistantName: personaInfo,
                model: conversation?.model ?? "",
                isAnimationActive: .constant(shouldAnimateHeader)) {
                    self.showingPersonaSwichSheet = true
                }
            if let reyaModel = reyaModel {
                ConversationView(conversation: conversation!, tempResponse: reyaModel.tempResponse)
                Spacer()
                HStack {
                    Spacer()
                    WriteMessageView(prompt: $prompt, status: reyaModel.status, sendMessage: sendMessage)
                    Spacer()
                }
                .border(width: 2, edges: [.top], color: .mint)
            }
        }
        .sheet(isPresented: $showingPersonaSwichSheet) {
            PersonaSwiftView { newConversation in
                handleNewConversation(newConversation)
            }
        }
        .onAppear {
            if let lastConversation = conversations.last {
                handleNewConversation(lastConversation)
            }
            else {
                self.showingPersonaSwichSheet = true
            }
        }
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
    
    private func handleNewConversation(_ newConversation: Conversation) {
        if self.conversation != nil {
            modelContext.delete(self.conversation!)
        }
        modelContext.insert(newConversation)
        self.conversation = newConversation
        if reyaModel == nil {
            reyaModel = ReyaModel(
                modelContext: self.modelContext,
                baseURL: self.baseURL!
            )
        }
    }
}

#Preview {
    PersonaView()
}
