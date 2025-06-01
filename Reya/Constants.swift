//
//  Constans.swift
//  Reya
//
//  Created by Romaryc Pelissie on 01/06/2025.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let model = Key<String>("model", default: "gemma3")
    static let personaPrompt = Key<String>("personaPrompt", default: """
        Tu es un assistant virtuel nommé Reya.
        Utilise le français comme langue principale.
        Utilise Markdown pour tes réponses.
        """)
    static let host = Key<URL?>("host", default: URL(string:"http://localhost:11434"))
    
}
