import Foundation

public struct Tiktoken {
    
    public static let shared: Tiktoken = .init()
    
    private init() {}
    
	 static var cachedEncoders: [String: Encoding] = [:]
	
    public func getEncoding(_ name: String) async throws -> Encoding? {
		 if let current = Self.cachedEncoders[name] { return current }
		 if let encodingName = Model.MODEL_TO_ENCODING[name], let existing = Self.cachedEncoders.values.first(where: { $0.name == encodingName }) { return existing }

        guard let vocab = Model.getEncoding(name) else { return nil }
        let encoder = await loadRanks(vocab)
        let regex = try NSRegularExpression(pattern: vocab.pattern)
        let encoding = Encoding(name: name, regex: regex, mergeableRanks: encoder, specialTokens: vocab.specialTokens)
		 
		  Self.cachedEncoders[name] = encoding
        return encoding
    }
    
//    public func getEncoding(for vocab: Vocab) -> Encoding? {
//        return nil
//    }
//    
//    public func register() {
//        // TODO: Register model and Encoding
//    }
//    
//    public func clear() {
//        // TODO: Clear all cached encoding
//    }
}

private extension Tiktoken {
    func loadRanks(_ vocab: Vocab) async -> [[UInt8]: Int] {
        if ["gpt2", "gpt3"].contains(vocab.name) {
            return await Load.dataGymToMergeableBpeRanks(vocabBpeFile: vocab.url)
        } else {
            return await Load.loadTiktokenBpe(url: vocab.url)
        }
    }
}
