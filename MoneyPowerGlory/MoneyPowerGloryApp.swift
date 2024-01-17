import SwiftUI
import FirebaseCore

@main
struct MoneyPowerGloryApp: App {
    @StateObject private var viewModel = ViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
