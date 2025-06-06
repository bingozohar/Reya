//
//  WriteMessageView.swift
//  Reya
//
//  Created by Romaryc Pelissie on 05/06/2025.
//

import SwiftUI

struct WriteMessageView: View {
    @Binding var prompt: String
    var status: ReyaStatus
    var sendMessage: () -> Void
    
    var body: some View {
        HStack {
            TextField("Write your message here", text: $prompt, axis: .vertical)
                .padding()
                .onSubmit {
                    //prompt.appendNewLine()
                    sendMessage()
                }
            
            Button(action: sendMessage) {
                if status == .busy {
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
                      || status != .ready)
        }
    }
}
