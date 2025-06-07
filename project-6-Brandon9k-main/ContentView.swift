import SwiftUI

struct ContentView: View {
    @State private var originalText: String = ""
    @State private var translatedText: String = ""
    
    var body: some View {
        VStack {
            Text("Translate Me")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter text", text: $originalText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                translateText()
            }) {
                Text("Translate Me")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Text(translatedText)
                .font(.title2)
                .padding()
            
            Spacer()
            
            NavigationLink(destination: SavedTranslationsView()) {
                Text("View Saved Translations")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
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