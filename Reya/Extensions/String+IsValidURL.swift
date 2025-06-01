//
//  String+ValidUrl.swift
//  Reya
//
//  Created by Romaryc Pelissie on 01/06/2025.
//

import Foundation

extension String {
    var isValidURL: Bool {
        guard let url = URL(string: self), let _ = url.host else { return false }
        return true
    }
}
