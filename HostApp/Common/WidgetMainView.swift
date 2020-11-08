
import SwiftUI
import WidgetKit

// Main Widget View
struct WidgetMainView: View {
    
    var entry: Provider.Entry
    @ObservedObject var manager: WidgetManager

    var body: some View {
        ZStack {
            if manager.backgroundImage == nil {
            LinearGradient(gradient: Gradient(colors: [manager.colors[manager.widgetGradientColors[0]], manager.colors[manager.widgetGradientColors[1]]]), startPoint: .top, endPoint: .bottom)
            } else if manager.backgroundImage != nil {
                Image(uiImage: manager.backgroundImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(manager.isAlpha ? 1.0 : 0.5)
            }
            HStack {
                if manager.textAlignment == .trailing { Spacer() }
                VStack(alignment: manager.textAlignment) {
                    Text(manager.dateComponent(.weekday).uppercased())
                        .font(.custom(manager.textFont, size: 35)).bold()
                    Text(manager.dateComponent(.month))
                        .font(.custom(manager.textFont, size: 20))
                }.foregroundColor(manager.textColor)
                if manager.textAlignment == .leading { Spacer() }
            }.padding(30)
        }
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let entry = CalendarEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> ()) {
        let timeline = Timeline(entries: [CalendarEntry(date: Date())], policy: .atEnd)
        completion(timeline)
    }
}

// Widget data model
struct CalendarEntry: TimelineEntry {
    let date: Date
}

// MARK: - Render UI
struct CalendarWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetMainView(entry: CalendarEntry(date: Date()), manager: WidgetManager())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
