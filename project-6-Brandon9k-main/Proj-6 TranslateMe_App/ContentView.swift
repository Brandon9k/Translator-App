//
//  ContentView.swift
//  Proj-6 TranslateMe_App
//
//  Created by Brandon Christian on 11/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var originalText: String = ""
    @State private var translatedText: String = ""
    @State private var translations: [Translation] = []
    @State private var name: String = "Brandon Christian" // Name field (inaccessible)
    @State private var number: String = "Z23551360" // Number field (inaccessible)

    // Replace this with the name of your image in Assets or a loaded UIImage
    private let privateImageName: String = "translate_page_logo"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Private image replacing the "Translate Me" text
                if let uiImage = UIImage(named: privateImageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) // Adjust size as needed
                        .padding(.top, 40)
                } else {
                    Text("Image not found")
                        .foregroundColor(.red)
                        .padding(.top, 40)
                }
                
                TextField("Enter text", text: $originalText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    translateText()
                }) {
                    Text("Translate Me")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Text(translatedText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 1)
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: SavedTranslationsView()) {
                    Text("View Saved Translations")
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 10) // Adjust padding for spacing
                
                // Display Name and Number as non-editable text
                VStack(alignment: .leading, spacing: -2) {
                    Text("Name: \(name)")
                        .font(.body)
                        .foregroundColor(.gray) // To make it less prominent
                        .padding(.horizontal)
                    
                    Text("Number: \(number)")
                        .font(.body)
                        .foregroundColor(.gray) // To make it less prominent
                        .padding(.horizontal)
                }
                .padding(.bottom, 10) // Adjust padding for spacing
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
        }
    }
    
    func translateText() {
        guard let url = URL(string: "https://api.mymemory.translated.net/get?q=\(originalText)&langpair=en|fr") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let responseData = json["responseData"] as? [String: Any],
               let translated = responseData["translatedText"] as? String {
                DispatchQueue.main.async {
                    self.translatedText = translated
                    let newTranslation = Translation(originalText: self.originalText,
                                                   translatedText: translated)
                    var savedTranslations = Translation.loadTranslations()
                    savedTranslations.append(newTranslation)
                    Translation.saveTranslations(savedTranslations)
                }
            }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}

