import Foundation

protocol WordsStorageProtocol {
    func getWords() throws -> [WordModel]
    func addWord(_ word: WordModel) throws
    func removeWord(_ word: WordModel) throws
    func updateWord(_ word: WordModel) throws
}

final class WordsStorage: WordsStorageProtocol {
    static let shared = WordsStorage()
    private let defaults = UserDefaults.standard
    private let wordsKey = "words"

    private init() {}

    func getWords() throws -> [WordModel] {
        guard let data = defaults.data(forKey: wordsKey) else {
            return []
        }
        return try JSONDecoder().decode([WordModel].self, from: data)
    }

    func addWord(_ word: WordModel) throws {
        var words = try getWords()
        words.append(word)
        try saveWords(words)
    }

    func removeWord(_ word: WordModel) throws {
        var words = try getWords()
        words.removeAll { $0.id == word.id }
        try saveWords(words)
    }

    func updateWord(_ word: WordModel) throws {
        var words = try getWords()
        if let index = words.firstIndex(where: { $0.id == word.id }) {
            words[index] = word
        }
        try saveWords(words)
    }

    private func saveWords(_ words: [WordModel]) throws {
        let data = try JSONEncoder().encode(words)
        defaults.set(data, forKey: wordsKey)
    }
}