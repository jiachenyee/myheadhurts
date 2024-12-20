//
//  EntryRecordingControl.swift
//  EntryRecording
//
//  Created by Jia Chen Yee on 12/20/24.
//

import AppIntents
import SwiftUI
import WidgetKit

struct EntryRecordingControl: ControlWidget {
    static let kind: String = "app.jiachen.myheadhurts.EntryRecording"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: LogEntryIntent()) {
                Label("Log Headache", systemImage: "brain.filled.head.profile")
            }
        }
        .displayName("Log Headache")
    }
}
