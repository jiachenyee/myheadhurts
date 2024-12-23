//
//  WatchHeadacheDetailView.swift
//  myheadhurtswatch Watch App
//
//  Created by Jia Chen Yee on 12/23/24.
//

import Foundation
import SwiftUI
import SwiftData

struct WatchHeadacheDetailView: View {
    
    @EnvironmentObject private var viewModel: ViewModel
    
    let headache: Headache?
    
    @State private var date: Date = .now
    @State private var severity: Headache.HeadacheSeverity = .present
    
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
                LabeledContent("when") {
                    Text(date.formatted(date: .abbreviated, time: .standard))
                }
                
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
            .disabled(headache != nil)
            
            Section {
                Toggle("lightheadedness", isOn: $lightheadedness)
                Toggle("dizziness", isOn: $dizziness)
                Toggle("collapsed", isOn: $collapsed)
            }
            .disabled(headache != nil)
            
            if headache == nil {
                Section("notes") {
                    TextField("type down notes", text: $notes)
                }
            } else {
                Section("notes") {
                    Text(notes)
                }
            }
            
            Section {
                if headache == nil {
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
            date = headache?.date ?? .now
            severity = headache?.severity ?? .present
            notes = headache?.notes ?? ""
            nausea = headache?.nausea ?? false
            vomiting = headache?.vomiting ?? false
            lightheadedness = headache?.lightheadedness ?? false
            dizziness = headache?.dizziness ?? false
            collapsed = headache?.collapsed ?? false
        }
    }
    
    func createHeadache() {
        guard headache == nil else { return }
        
        let newHeadache = Headache(date: date,
                                   severity: severity,
                                   notes: notes,
                                   nausea: nausea,
                                   vomiting: vomiting,
                                   lightheadedness: lightheadedness,
                                   dizziness: dizziness,
                                   collapsed: collapsed)
        
        modelContext.insert(newHeadache)
        
        try? modelContext.save()
        
        Task {
            await viewModel.createNewHealthKitRecord(for: newHeadache)
        }
    }
}
