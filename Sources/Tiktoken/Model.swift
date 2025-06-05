//
//  Model.swift
//  
//
//  Created by Alberto Espinilla Garrido on 20/3/23.
//

import Foundation

enum Model {
    static func getEncoding(_ name: String) -> Vocab? {
        if let encodingName = MODEL_TO_ENCODING[name],
           let vocab = Vocab.all.first(where: { $0.name == encodingName }) {
            return vocab
        }
        return findPrefix(with: name)
    }
}

extension Model {
    static let IGNORED_PREFIXES: [String] = [
        "ft:"  // Fine-tuned versions of standard models
    ]

    // NOTE: the following bindings are copied from the current python tiktoken
    // repo which seems to be the one maintained. All bindings relating to
    // deprecated models have been removed for clarity sake.
    static let MODEL_PREFIX_TO_ENCODING: [String: String] = [
        "o1-": "o200k_base",
        "o3-": "o200k_base",
        // chat
        "chatgpt-4o-": "o200k_base",
        "gpt-4o-": "o200k_base",            // e.g., gpt-4o-2024-05-13
        "gpt-4-": "cl100k_base",            // e.g., gpt-4-0314, etc., plus gpt-4-32k
        "gpt-3.5-turbo-": "cl100k_base",    // e.g, gpt-3.5-turbo-0301, -0401, etc.
        "gpt-35-turbo-": "cl100k_base",     // Azure deployment name
        
        // custom settings (e.g not ported from the python tiktoken code)
        // 4.1: nothing is official but it's likely to use the same merge
        // file as 40, e.g o200k_base.
        "gpt-4.1-": "o200k_base",
    ]
    
    static let MODEL_TO_ENCODING: [String: String] = [
        // reasoning
        "o1": "o200k_base",
        "o3": "o200k_base",
        // chat
        "gpt-4o": "o200k_base",
        "gpt-4": "cl100k_base",
        "gpt-3.5-turbo": "cl100k_base",
        "gpt-3.5": "cl100k_base",       // Common shorthand
        "gpt-35-turbo": "cl100k_base",  // Azure deployment name
        // base
        "davinci-002": "cl100k_base",
        "babbage-002": "cl100k_base",
        // embeddings
        "text-embedding-ada-002": "cl100k_base",
        "text-embedding-3-small": "cl100k_base",
        "text-embedding-3-large": "cl100k_base",
    ]
    
    static func findPrefix(with name: String) -> Vocab? {
        guard let key = Model.MODEL_PREFIX_TO_ENCODING.keys.first(where: { name.starts(with: $0) }),
              let name = Model.MODEL_PREFIX_TO_ENCODING[key] ,
              let vocab = Vocab.all.first(where: { $0.name == name }) else {
            return nil
        }
        return vocab
    }
}
