import WidgetKit
import SwiftUI
import Intents

let appGroupName = "group.com.clicker.state"

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ClickerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let count = UserDefaults(suiteName: appGroupName)?.string(forKey: "count") ?? ""
        let emoji = UserDefaults(suiteName: appGroupName)?.string(forKey: "emoji") ?? ""
        let text = count == "" || emoji == "" ? "Start clicking!" : "\(emoji) \(count) \(emoji)"

        Text(entry.date, style: .time).padding()
        Text(text).padding()
    }
}

@main
struct ClickerWidget: Widget {
    let kind: String = "ClickerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ClickerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Clicker Widget")
        .description("Widget for Clicker App")
    }
}

struct ClickerWidget_Previews: PreviewProvider {
    static var previews: some View {
        ClickerWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
