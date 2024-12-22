//
//  HeadacheDetailView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI

struct HeadacheDetailView: View {
    
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
    
    @State private var isDeleteConfirmationPresented = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var wasHeadacheUpdated: Bool {
        if let headache {
            return date != headache.date ||
            severity != headache.severity ||
            notes != headache.notes ||
            nausea != headache.nausea ||
            vomiting != headache.vomiting ||
            lightheadedness != headache.lightheadedness ||
            dizziness != headache.dizziness ||
            collapsed != headache.collapsed
        } else {
            return false
        }
    }
    
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
            
            Section {
                Toggle("lightheadedness", isOn: $lightheadedness)
                Toggle("dizziness", isOn: $dizziness)
                Toggle("collapsed", isOn: $collapsed)
            }
            
            Section("notes") {
                TextEditor(text: $notes)
            }
            
            Section {
                if wasHeadacheUpdated {
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
            
            if headache != nil {
                Section {
                    Button(role: .destructive) {
                        isDeleteConfirmationPresented = true
                    } label: {
                        Label("Delete", systemImage: "trash")
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
        .alert("delete this entry?", isPresented: $isDeleteConfirmationPresented) {
            Button("delete", role: .destructive) {
                dismiss()
                
                withAnimation {
                    modelContext.delete(headache!)
                }
                
                Task {
                    await viewModel.deleteOldHealthKitRecord(for: headache!)
                }
            }
            
            Button("cancel", role: .cancel) {}
        } message: {
            Text("are you sure you want to delete this entry? this action cannot be undone.")
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
        
        if wasHeadacheUpdated {
            headache.date = date
            headache.severity = severity
            headache.notes = notes
            headache.nausea = nausea
            headache.vomiting = vomiting
            headache.lightheadedness = lightheadedness
            headache.dizziness = dizziness
            headache.collapsed = collapsed
            
            Task {
                await viewModel.updateHealthKitRecord(for: headache)
            }
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

#if DEBUG
#Preview {
    NavigationStack {
        HeadacheDetailView(headache: .example)
    }
}
#endif
