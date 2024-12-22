//
//  EntryRecording.swift
//  EntryRecording
//
//  Created by Jia Chen Yee on 12/20/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<SimpleEntry>) -> Void) {
        let entries: [SimpleEntry] = [SimpleEntry(date: .now)]
        
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct EntryRecordingEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    @Query var todayHeadaches: [Headache]
    @Query var thisWeekHeadaches: [Headache]
    
    init(entry: Provider.Entry) {
        self.entry = entry
        
        let startOfWeek = Date.now.startOfWeek
        let startOfToday = Date.now.startOfDay
        let today = Date.now
        
        _todayHeadaches = Query(filter: #Predicate {
            $0.date >= startOfToday && $0.date < today
        })
        
        _thisWeekHeadaches = Query(filter: #Predicate {
            $0.date >= startOfWeek && $0.date < today
        })
    }
    
    var thisWeekHeadache: Int {
        thisWeekHeadaches.count
    }
    var todayHeadache: Int {
        todayHeadaches.count
    }
    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            Button(intent: LogEntryIntent()) {
                Image(systemName: "brain.filled.head.profile")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .imageScale(.large)
            }
        case .accessoryRectangular:
            VStack(alignment: .leading) {
                HStack {
                    Text("\(Image(systemName: "brain.filled.head.profile"))")
                    Text("headaches")
                }
                .font(.headline)
                HStack {
                    VStack(alignment: .leading) {
                        Text("today")
                            .font(.headline)
                        Text("this week")
                            .font(.headline)
                    }
                    VStack(alignment: .leading) {
                        Text("\(todayHeadache)")
                            .font(.headline)
                        Text("\(thisWeekHeadache)")
                            .font(.headline)
                    }
                }
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .accessoryInline:
            Button(intent: LogEntryIntent()) {
                Label("\(todayHeadache)", systemImage: "brain.filled.head.profile")
                    .frame(maxWidth: .infinity)
            }
        case .systemSmall:
            VStack {
                Spacer()
                
                Text("\(todayHeadache)")
                    .font(.system(size: 48, weight: .bold))
                
                Text("today")
                    .font(.system(size: 18))
                
                Spacer()
                
                Button(intent: LogEntryIntent()) {
                    Label("log", systemImage: "brain.filled.head.profile")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .systemMedium:
            VStack {
                HStack {
                    VStack {
                        Spacer()
                        
                        Text("\(todayHeadache)")
                            .font(.system(size: 48, weight: .bold))
                        
                        Text("today")
                            .font(.system(size: 18))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Divider()
                    
                    VStack {
                        Spacer()
                        
                        Text("\(thisWeekHeadache)")
                            .font(.system(size: 48, weight: .bold))
                        
                        Text("this week")
                            .font(.system(size: 18))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Button(intent: LogEntryIntent()) {
                    Label("log", systemImage: "brain.filled.head.profile")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        default: EmptyView()
        }
    }
}

struct EntryRecording: Widget {
    let kind: String = "EntryRecording"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            EntryRecordingEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(colors: [.clear, .red.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                }
                .tint(.red)
                .widgetURL(URL(string: "myheadhurts://now")!)
                .modelContainer(for: Headache.self)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryInline, .accessoryRectangular])
        .configurationDisplayName("Record Entry")
        .description("Record new headache entries and view statistics.")
    }
}

#Preview(as: .systemMedium) {
    EntryRecording()
} timeline: {
    SimpleEntry(date: .now)
}
