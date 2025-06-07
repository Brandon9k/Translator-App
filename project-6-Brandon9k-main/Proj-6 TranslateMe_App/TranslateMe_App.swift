@main
struct TranslateMe_App: App {
    @State private var isLaunchScreenDone = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if isLaunchScreenDone {
                    ContentView()
                } else {
                    LaunchScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    isLaunchScreenDone = true
                                }
                            }
                        }
                }
            }
        }
    }
} 