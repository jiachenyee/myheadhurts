//
//  HeadacheDetailView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI

struct HeadacheDetailView: View {
    
    let headache: Headache?
    
    @State private var date: Date = .now
    @State private var severity: Headache.HeadacheSeverity = .mild
    
    @State private var notes: String = ""
    @State private var nausea: Bool = false
    @State private var vomiting: Bool = false
    
    @State private var lightheadedness: Bool = false
    @State private var dizziness: Bool = false
    @State private var collapsed: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                DatePicker("when", selection: $date)
                
                Picker("severity", selection: $severity) {
                    ForEach(Headache.HeadacheSeverity.allCases, id: \.self) { severity in
                        Text(severity.rawValue)
                            .tag(severity)
                    }
                }
            }
            
            Section("other symptoms") {
                Toggle("nausea", isOn: $nausea)
                Toggle("vomiting", isOn: $vomiting)
            }
            
            Section {
                Toggle("lightheadedness", isOn: $lightheadedness)
                Toggle("dizziness", isOn: $dizziness)
                Toggle("collapsed", isOn: $collapsed)
            }
            
            Section("notes") {
                TextEditor(text: $notes)
            }
            
            Section {
                if let headache,
                   date != headache.date ||
                    severity != headache.severity ||
                    notes != headache.notes ||
                    nausea != headache.nausea ||
                    vomiting != headache.vomiting ||
                    lightheadedness != headache.lightheadedness ||
                    dizziness != headache.dizziness ||
                    collapsed != headache.collapsed {
                    Button("discard changes", systemImage: "trash", role: .destructive) {
                        discardChanges()
                    }
                } else if headache == nil {
                    Button("create entry") {
                        createHeadache()
                        dismiss()
                    }
                    
                    Button("cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("\(headache?.date.titleFormat ?? "new") episode")
        .onAppear {
            discardChanges()
        }
        .onDisappear {
            saveChanges()
        }
    }
    
    func discardChanges() {
        date = headache?.date ?? .now
        severity = headache?.severity ?? .present
        notes = headache?.notes ?? ""
        nausea = headache?.nausea ?? false
        vomiting = headache?.vomiting ?? false
        lightheadedness = headache?.lightheadedness ?? false
        dizziness = headache?.dizziness ?? false
        collapsed = headache?.collapsed ?? false
    }
    
    func saveChanges() {
        guard let headache = headache else { return }
        
        headache.date = date
        headache.severity = severity
        headache.notes = notes
        headache.nausea = nausea
        headache.vomiting = vomiting
        headache.lightheadedness = lightheadedness
        headache.dizziness = dizziness
        headache.collapsed = collapsed
    }
    
    func createHeadache() {
        guard headache == nil else { return }
        
        modelContext.insert(Headache(date: date,
                                     severity: severity,
                                     notes: notes,
                                     nausea: nausea,
                                     vomiting: vomiting,
                                     lightheadedness: lightheadedness,
                                     dizziness: dizziness,
                                     collapsed: collapsed))
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        HeadacheDetailView(headache: .example)
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
