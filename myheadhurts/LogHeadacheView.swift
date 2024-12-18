//
//  LogHeadacheView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI

struct LogHeadacheView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var newHeadache = HeadacheEntry(date: .now,
                                                   severity: .mild,
                                                   nausea: false,
                                                   vomiting: false)
    
    var onAdd: ((HeadacheEntry) -> Void)
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("when", selection: $newHeadache.date)
                    
                    Picker("severity", selection: $newHeadache.severity) {
                        ForEach(HeadacheEntry.HeadacheSeverity.allCases, id: \.self) { severity in
                            Text(severity.rawValue)
                                .tag(severity)
                        }
                    }
                }
                
                Section("other symptoms") {
                    Toggle("nausea", isOn: $newHeadache.nausea)
                    Toggle("vomiting", isOn: $newHeadache.vomiting)
                }
                
                Section("notes") {
                    TextEditor(text: $newHeadache.notes)
                }
                
                Section {
                    Button("save") {
                        onAdd(newHeadache)
                        dismiss()
                    }
                    
                    Button("cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("log headache")
        }
    }
}

#Preview {
    LogHeadacheView() { _ in
        
    }
}
