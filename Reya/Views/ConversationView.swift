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
    var role: Role
    var content: String
    
    private var color: Color {
        switch role {
        case .user:
            return .mint
        case .assistant:
            return .purple
        default:
            return .gray
        }
    }
    
    private var edge: Edge {
        switch role {
        case .user:
            return .trailing
        default:
            return .leading
        }
    }
    
    var body: some View {
        
        
        HStack(alignment: .center) {
            if (role == .assistant) {
                Spacer()
                Rectangle().fill(
                    Color.mint)
                .frame(width: 2)
            }
            Markdown(content)
                .textSelection(.enabled)
            //.border(width: 2, edges: [edge], color: color)
                .padding(10)
            if (role == .user) {
                Rectangle().fill(
                    Color.purple)
                .frame(width: 2)
                Spacer()
            }
        }
        .padding(5)
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
    let personaInfo: String = "**Je suis Reya,** *comment puis-je vous aider aujourd'hui?*"
    
    // L'animation suit automatiquement l'état de l'AI
    private var shouldAnimateHeader: Bool {
        reyaModel?.status == .busy
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ConversationHeaderView(
                assistantName: personaInfo,
                model: conversation?.model ?? "",
                isAnimationActive: .constant(shouldAnimateHeader)) {
                    self.showingNewConversationSheet = true
                }
            if let reyaModel = reyaModel {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(reyaModel.conversation.sortedItems) { message in
                            MessageBubble(role: message.role, content: message.content.isNotEmpty ? message.content : reyaModel.tempResponse)
                                .id(message.id)
                            //Divider()
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
                    Spacer()
                    TextField("Write your message here", text: $prompt, axis: .vertical)
                        .padding()
                        .onSubmit {
                            //prompt.appendNewLine()
                            sendMessage()
                        }
                    
                    Button(action: sendMessage) {
                        if reyaModel.status == .busy {
                            ProgressView()
                                .scaleEffect(0.4)
                        } else {
                            Image(systemName: "arrowtriangle.up.fill")
                                .foregroundStyle(.mint)
                                .imageScale(.large)
                                .fontWeight(.bold)
                        }
                    }
                    .controlSize(.extraLarge)
                    .clipShape(.circle)
                    .overlay {
                        Circle().stroke(.mint, lineWidth: 2)
                    }
                    .disabled(prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                              || reyaModel.status != .ready)
                    Spacer()
                }
                .border(width: 2, edges: [.top], color: .mint)
                //.padding(.horizontal,)
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
        //.padding()
    }
    
    private func copyAction(_ content: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)
    }
    
    private func sendMessage() {
        guard prompt.isNotEmpty, let reyaModel = reyaModel else { return }
        //Créer une copie du prompt
        let prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        reyaModel.sendUserPrompt(prompt: prompt)
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
                baseURL: self.baseURL!,
                conversation: self.conversation!)
        }
        self.reyaModel?.conversation = newConversation
    }
}

#Preview {
    ConversationView()
}
