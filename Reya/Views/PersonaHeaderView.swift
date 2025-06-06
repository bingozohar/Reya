//
//  Header.swift
//  Reya
//
//  Created by Romaryc Pelissie on 02/06/2025.
//

import SwiftUI
import ViewCondition

import MarkdownUI

struct PersonaHeaderView: View {
    //Variables locales requises
    private let customPointBegin = UnitPoint(x: UnitPoint.center.x + 0.3, y: UnitPoint.center.y)
    @State private var animateGradient: Bool = false
    
    //Parametres dynamiques
    var persona: Persona
    var model: String
    @Binding var isAnimationActive: Bool
    var switchPersona: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .purple],
                startPoint: animateGradient ? .trailing : .trailing,
                endPoint: animateGradient ? .leading : customPointBegin,
            )
            
            HStack() {
                VStack(alignment: .leading) {
                    Markdown(persona.details)
                    Text("Model: " + model)
                        .fontWeight(.light)
                        .italic(true)
                }
                Spacer()
                Button {
                    switchPersona()
                } label: {
                    Image(systemName: "heart.slash")
                        .symbolVariant(.fill)
                        .foregroundStyle(.purple)
                        .imageScale(.large)
                        .fontWeight(.bold)
                        .padding(8)
                }
                .controlSize(.large)
                .clipShape(.circle)
                .keyboardShortcut("r", modifiers: .command)
                .hide(if: isAnimationActive, removeCompletely: true)
            }
            .padding(16)
        }
        .onChange(of: isAnimationActive) { oldValue, newValue in
            toggleAnimation(active: newValue)
        }
        .onAppear {
            if isAnimationActive {
                toggleAnimation(active: true)
            }
        }
        .frame(height: 70)
    }
    
    init(persona: Persona, model: String, isAnimationActive: Binding<Bool>, switchPersona: @escaping () -> Void) {
        self.persona = persona
        self.model = model
        self._isAnimationActive = isAnimationActive
        self.switchPersona = switchPersona
    }
    
    private func toggleAnimation(active: Bool) {
        if active {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        } else {
            withAnimation(.easeInOut(duration: 3)) {
                animateGradient = false
            }
        }
    }
}

/*
#Preview {
    PersonaHeaderView(assistantName: "Reya", model: "gemma3", isAnimationActive: .constant(true)) {
    }
}
*/
