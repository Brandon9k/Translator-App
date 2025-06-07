import SwiftUI

struct SavedTranslationsView: View {
    @State private var translations: [Translation] = []
    
    var body: some View {
        VStack {
            if translations.isEmpty {
                Text("No saved translations")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(translations) { translation in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(translation.originalText)
                                .font(.body)
                            Text(translation.translatedText)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            
            Button(action: {
                translations.removeAll()
                Translation.saveTranslations([])  // Clear stored translations
            }) {
                Text("Clear All Translations")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Translate Me")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            translations = Translation.loadTranslations()
        }
    }
} 