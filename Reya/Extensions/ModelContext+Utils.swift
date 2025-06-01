//
//  ModelContext+Utils.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import SwiftData

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
