
import SwiftUI

@main
struct WidgetPlusApp: App {
    var body: some Scene {
        return WindowGroup {
            MainView(manager: WidgetManager())
        }
    }
}
