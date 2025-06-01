//
//  Optional+Utils.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//


import Foundation

extension Optional {
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        self != nil
    }
}