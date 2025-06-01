//
//  ContentView.swift
//  Reya
//
//  Created by Romaryc Pelissie on 30/05/2025.
//

import SwiftUI
import SwiftData

struct MessageBubble: View {
    var content: String
    
    var body: some View {
        Text(content)
    }
}

struct ConversationView: View {
    @Namespace var bottomID
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Conversation.timestamp) var conversations: [Conversation]

    let baseURL: URL
    
    @State private var conversation: Conversation?
    @State private var reyaModel: ReyaModel?
    @State private var prompt: String = ""
    
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing:4) {
            if let reyaModel = reyaModel {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(reyaModel.conversation.sortedItems) { message in
                                MessageBubble(content: message.content.isNotEmpty ? message.content : reyaModel.tempResponse)
                                Divider()
                            }
                        }
                    }
                    .defaultScrollAnchor(.bottom)
                }
                Spacer()
                Divider()
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
            }
        }
        .background(
            Button("RESET CONVERSATION") {
                modelContext.delete(self.conversation!)
                self.conversation = Conversation(model: "gemma3")
                reyaModel?.conversation = self.conversation!
            }.keyboardShortcut("n", modifiers: .command)
            .hidden()
        )
        .onAppear {
            //Si une conversation existe, on va proposer de l'utiliser
            if let conv: Conversation = conversations.last {
                self.conversation = conv
            } else {
                self.conversation = Conversation(model: "gemma3")
            }
            
            if reyaModel == nil {
                reyaModel = ReyaModel(
                    modelContext: self.modelContext,
                    baseURL: baseURL,
                    conversation: self.conversation!)
            }
        }
        .padding()
    }
    
    func sendMessage() {
        guard prompt.isNotEmpty, let reyaModel = reyaModel else { return }
        //reset prompt
        let prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        reyaModel.sendUserPrompt(prompt: prompt)
        self.prompt = ""
    }
}

/*#Preview {
 ConversationView(baseURL: URL(string: "http://localhost")!, model: "model")
 }*/
