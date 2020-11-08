
import WidgetKit
import SwiftUI

@main
struct AppWidget: Widget {
    let kind: String = "AppWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetMainView(entry: entry, manager: WidgetManager())
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Widget Plus")
        .description("Build your own calendar style of widget")
    }
}

// MARK: - Render UI
struct AppWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetMainView(entry: CalendarEntry(date: Date()), manager: WidgetManager())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
