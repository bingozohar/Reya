//
//  OllamaClient.swift
//  Reya
//
//  Created by Romaryc Pelissie on 31/05/2025.
//

import Foundation

struct OllamaService {
    static func stream<T: Decodable>(request: URLRequest) -> AsyncThrowingStream<T, Error> {
        let shared: URLSession = .shared
        let decoder: JSONDecoder = .default
        
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    //lance la requette HTTP
                    let (stream, _) = try await shared.bytes(for: request)
                    //print("#Response:", response)
                    
                    //parcours le resultat ligne par ligne
                    for try await line in stream.lines {
                        if let data = line.data(using: .utf8),
                           //convertit la data en objet
                           let decodedObject = try? decoder.decode(T.self, from: data) {
                            //print("6")
                            //renvoi le résultat
                            continuation.yield(decodedObject)
                        }
                    }
                    continuation.finish()
                }
                catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

/*
 
 DEFAULT URL: http://localhost:11434
 
 GET / => Renvoi "Ollama is running"
 GET /api/tags => Renvoi la liste des modeles disponibles
 
 curl http://localhost:11434/api/tags
 {
   "models": [
     {
       "name": "llama3.2:latest",
       "model": "llama3.2:latest",
       "modified_at": "2025-05-31T00:02:47.697702018+02:00",
       "size": 2019393189,
       "digest": "a80c4f17acd55265feec403c7aef86be0c25983ab279d83f3bcd3abbcb5b8b72",
       "details": {
         "parent_model": "",
         "format": "gguf",
         "family": "llama",
         "families": [
           "llama"
         ],
         "parameter_size": "3.2B",
         "quantization_level": "Q4_K_M"
       }
     },
     {
       "name": "gemma3:latest",
       "model": "gemma3:latest",
       "modified_at": "2025-05-30T16:35:58.424979293+02:00",
       "size": 3338801804,
       "digest": "a2af6cc3eb7fa8be8504abaf9b04e88f17a119ec3f04a3addf55f92841195f5a",
       "details": {
         "parent_model": "",
         "format": "gguf",
         "family": "gemma3",
         "families": [
           "gemma3"
         ],
         "parameter_size": "4.3B",
         "quantization_level": "Q4_K_M"
       }
     }
   ]
 }
 
 curl http://localhost:11434/api/generate -d '{
   "model": "llama3.2",
   "prompt": "Bonjour"
 }'
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.073232Z","response":"Bonjour","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.101425Z","response":" !","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.131521Z","response":" Comment","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.162583Z","response":" puis","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.193758Z","response":"-","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.223116Z","response":"je","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.253962Z","response":" vous","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.284452Z","response":" aider","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.315615Z","response":" aujourd","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.346778Z","response":"'hui","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.376684Z","response":" ?","done":false}
 {"model":"llama3.2","created_at":"2025-05-30T22:14:50.406781Z","response":"","done":true,"done_reason":"stop","context":[128006,9125,128007,271,38766,1303,33025,2696,25,6790,220,2366,18,271,128009,128006,882,128007,271,82681,128009,128006,78191,128007,271,82681,758,12535,44829,12,3841,9189,91878,75804,88253,949],"total_duration":489116750,"load_duration":33000292,"prompt_eval_count":26,"prompt_eval_duration":118290625,"eval_count":12,"eval_duration":336979833}
 */
