//
//  OllamaRouter.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import Foundation

enum OllamaRouter {
    case root
    case models
    case chat(data: OllamaChatRequest)
    
    var path: String {
        switch self {
        case .root:
            return "/"
        case .models:
            return "/api/tags"
        case .chat:
            return "/api/chat"
        }
    }
    
    var method: String {
        switch self {
        case .root:
            return "GET"
        case .models:
            return "POST"
        case .chat:
            return "POST"
        }
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}

extension OllamaRouter {
    func asURLRequest(with baseURL: URL) -> URLRequest {
        let encoder: JSONEncoder = .default
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        switch self {
        case .chat(let data):
            request.httpBody = try? encoder.encode(data)
        default :
            break
        }
        return request
    }
}
