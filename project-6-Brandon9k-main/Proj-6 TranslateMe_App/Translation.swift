import Foundation

struct Translation: Identifiable, Codable {
    let id: String
    let originalText: String
    let translatedText: String
    let timestamp: TimeInterval
    
    init(originalText: String, translatedText: String) {
        self.id = UUID().uuidString
        self.originalText = originalText
        self.translatedText = translatedText
        self.timestamp = Date().timeIntervalSince1970
    }
    
    var date: Date {
        Date(timeIntervalSince1970: timestamp)
    }
    
    // Add static methods for UserDefaults storage
    static func saveTranslations(_ translations: [Translation]) {
        if let encoded = try? JSONEncoder().encode(translations) {
            UserDefaults.standard.set(encoded, forKey: "SavedTranslations")
        }
    }
    
    static func loadTranslations() -> [Translation] {
        if let data = UserDefaults.standard.data(forKey: "SavedTranslations"),
           let translations = try? JSONDecoder().decode([Translation].self, from: data) {
            return translations
        }
        return []
    }
} 