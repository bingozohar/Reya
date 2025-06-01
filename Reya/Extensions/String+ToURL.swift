//
//  String+ToURL.swift
//  Reya
//
//  Created by Romaryc Pelissie on 01/06/2025.
//

import Foundation

extension String {
    func toURL() -> URL? {
        URL(string: self)
    }
}
