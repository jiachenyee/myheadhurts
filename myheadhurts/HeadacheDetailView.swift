//
//  HeadacheDetailView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI

struct HeadacheDetailView: View {
    
    @Binding var headache: HeadacheEntry
    
    var body: some View {
        Form {
            Section {
                DatePicker("when", selection: $headache.date)
                
                Picker("severity", selection: $headache.severity) {
                    ForEach(HeadacheEntry.HeadacheSeverity.allCases, id: \.self) { severity in
                        Text(severity.rawValue)
                            .tag(severity)
                    }
                }
            }
            
            Section("other symptoms") {
                Toggle("nausea", isOn: $headache.nausea)
                Toggle("vomiting", isOn: $headache.vomiting)
            }
            
            Section("notes") {
                TextEditor(text: $headache.notes)
            }
        }
        .navigationTitle("\(headache.date.titleFormat) episode")
    }
}

#Preview {
    @Previewable @State var headache: HeadacheEntry = .example
    
    NavigationStack {
        HeadacheDetailView(headache: $headache)
    }
}

extension Date {
    var titleFormat: String {
        let formatter = DateFormatter()
        
        // e.g. 1 Nov
        formatter.dateFormat = "dd MMM"
        
        return formatter.string(from: self).lowercased()
    }
}
