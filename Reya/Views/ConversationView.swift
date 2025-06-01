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

struct MessageBubble: View {
    var content: String
    
    var body: some View {
        Markdown(content)
    }
}

struct ConversationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Conversation.timestamp) var conversations: [Conversation]
    
    private let baseURL: URL? = Defaults[.host]
    
    @State private var conversation: Conversation?
    @State private var reyaModel: ReyaModel?
    @State private var prompt: String = ""
    @State private var showingNewConversationSheet = false
    
    //@State private var scrollProxy: ScrollViewProxy? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing:4) {
            if let reyaModel = reyaModel {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(reyaModel.conversation.sortedItems) { message in
                            MessageBubble(content: message.content.isNotEmpty ? message.content : reyaModel.tempResponse)
                                .id(message.id)
                            Divider()
                        }
                    }
                    /*.onAppear {
                     self.scrollProxy = proxy
                     }*/
                    //TODO: remplacer par une meilleure solution car ne fonctionne pas à 100%
                    .defaultScrollAnchor(.bottom)
                }
                
                Spacer()
                HStack {
                    TextField("Tapez vous message...", text: $prompt)
                        .onSubmit(sendMessage)
                    
                    Button(action: sendMessage) {
                        if reyaModel.status == .busy {
                            ProgressView()
                                .scaleEffect(0.4)
                        } else {
                            Image(systemName: "paperplane.fill")
                        }
                    }
                    .disabled(prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                              || reyaModel.status != .ready)
                }
                
                Button("Nouvelle conversation") {
                }
                .keyboardShortcut("r", modifiers: .command)
                .visible(if: false)
            }
        }
        .sheet(isPresented: $showingNewConversationSheet) {
            NewConversationView { newConversation in
                handleNewConversation(newConversation)
            }
        }
        .onAppear {
            if let lastConversation = conversations.last {
                handleNewConversation(lastConversation)
            }
            else {
                self.showingNewConversationSheet = true
            }
            
        }
        .padding()
    }
    
    func sendMessage() {
        guard prompt.isNotEmpty, let reyaModel = reyaModel else { return }
        //Créer une copie du prompt
        let prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        reyaModel.sendUserPrompt(prompt: prompt)
        //Ré-initialise la valeur du prompt
        self.prompt = ""
    }
    
    private func handleNewConversation(_ newConversation: Conversation) {
        if self.conversation != nil {
            print("Delete existing one")
            modelContext.delete(self.conversation!)
        }
        self.conversation = newConversation
        if reyaModel == nil {
            reyaModel = ReyaModel(
                modelContext: self.modelContext,
                baseURL: self.baseURL!,
                conversation: self.conversation!)
        }
        self.reyaModel?.conversation = newConversation
    }
}

/*#Preview {
 ConversationView(baseURL: URL(string: "http://localhost")!, model: "model")
 }*/
