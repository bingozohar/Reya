//
//  ContentView.swift
//  Reya
//
//  Created by Romaryc Pelissie on 30/05/2025.
//

import SwiftUI

struct MessageBubble: View {
    var message: ConversationItem
    
    var body: some View {
        Text(message.content)
    }
}

struct ConversationView: View {
    @Environment(\.modelContext) private var modelContext
    
    let baseURL: URL
    let conversation: Conversation
    
    @State private var reyaModel: ReyaModel?
    @State private var prompt: String = ""
    
    /*init(baseURL: URL, conversation: Conversation) {
        self._reyaModel = StateObject(wrappedValue: ReyaModel(baseURL: baseURL,
                                                              conversation: conversation))
        print("REYA MODEL STATUS: \(self.reyaModel.status)")
    }*/
    
    var body: some View {
        VStack(alignment: .leading, spacing:4) {
            if let reyaModel = reyaModel {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(reyaModel.conversation.items) { message in
                                MessageBubble(message: message)
                                Divider()
                            }
                            
                        }
                    }
                    .onChange(of: reyaModel.conversation.items.count) { _, _ in
                        if let lastItem = reyaModel.conversation.items.last {
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(lastItem.id, anchor: .bottom)
                            }
                        }
                    }
                    
                }
                Spacer()
                Divider()
                Spacer()
                HStack {
                    TextField("Tapez vous message...", text: $prompt)
                        .onSubmit(sendMessage)
                    
                    Button(action: sendMessage) {
                        if reyaModel.status == .generate {
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
        .onAppear {
            if reyaModel == nil {
                reyaModel = ReyaModel(baseURL: baseURL,
                                      conversation: conversation)
            }
        }
        .padding()
    }
    
    func sendMessage() {
        guard !prompt.isEmpty, let reyaModel = reyaModel else { return }
        
        let userItem = ConversationItem(type: .user, content: prompt)
        reyaModel.conversation.items.append(userItem)
        
        // Sauvegarder immédiatement
        try? modelContext.save()
        
        reyaModel.sendUserPrompt(prompt: prompt)
    }
}

/*#Preview {
 ConversationView(baseURL: URL(string: "http://localhost")!, model: "model")
 }*/
