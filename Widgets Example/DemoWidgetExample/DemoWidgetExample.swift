//
//  DemoWidgetExample.swift
//  DemoWidgetExample
//
//  Created by sardar saqib on 11/12/2024.
//

import WidgetKit
import SwiftUI
import OSLog

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", updateNumber: 0, lastEntryDate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", updateNumber: 1, lastEntryDate: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀", updateNumber: hourOffset, lastEntryDate: nextUpdate)
            entries.append(entry)
        }

        
        //print("NEW Current Date:\(currentDate) update Date is: \(nextUpdate)")
       
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let updateNumber: Int
    let lastEntryDate : Date
}

struct DemoWidgetExampleEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
    
            //Text("NUT:\(entry.lastEntryDate)")
            Text(entry.lastEntryDate, style: .time)
            Text(entry.date, style: .time)
            
            Text("Update NO: \(entry.updateNumber)")
            if entry.updateNumber == 0 {
                Text("🌙")
            } else if entry.updateNumber == 1 {
                Text("👿")
            }
            else if entry.updateNumber == 2 {
                Text("🧑‍💻")
            } else if entry.updateNumber == 3 {
                Text("🐓")
            } else if entry.updateNumber == 4 {
                Text("❤️")
                    .onAppear {
                      //  WidgetCenter.shared.reloadAllTimelines()
                    }
            }
            else {
                Text(entry.emoji)
            }
        }
    }
}

struct DemoWidgetExample: Widget {
    let kind: String = "DemoWidgetExample"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DemoWidgetExampleEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DemoWidgetExampleEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    DemoWidgetExample()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀", updateNumber: 0, lastEntryDate: .now)
    SimpleEntry(date: .now, emoji: "🤩", updateNumber: 0, lastEntryDate: .now)
}
