//
//  HeadacheListView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI

struct HeadacheListView: View {
    
    @Binding var headaches: [HeadacheEntry]
    
    var body: some View {
        if headaches.isEmpty {
            ContentUnavailableView("no headaches to show", systemImage: "face.smiling")
        } else {
            ForEach($headaches, editActions: .delete) { $headache in
                NavigationLink(destination: HeadacheDetailView(headache: $headache)) {
                    
                    VStack(alignment: .leading) {
                        Text(headache.date.formatted(date: .abbreviated, time: .shortened).lowercased())
                            .font(.headline)
                        Text(headache.severity.rawValue)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    HeadacheListView(headaches: .constant([.example, .example, .example]))
}

#Preview {
    HeadacheListView(headaches: .constant([]))
}
