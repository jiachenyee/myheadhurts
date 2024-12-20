//
//  ContentView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var isNewEntrySheetPresented = false
    
    @Query var headaches: [Headache]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            Group {
                if headaches.isEmpty {
                    ContentUnavailableView("no headaches to show", systemImage: "face.smiling")
                } else {
                    ScrollView {
                        LazyVStack {
                            StatisticsView()
                            
                            HeadacheListView()
                        }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    isNewEntrySheetPresented = true
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(24)
                        .background(Color.accentColor)
                        .clipShape(.circle)
                }
            }

            .navigationTitle("my head hurts")
            .sheet(isPresented: $isNewEntrySheetPresented) {
                NavigationStack {
                    HeadacheDetailView(headache: nil)
                }
            }
            .background(LinearGradient(colors: [.clear, .accentColor.opacity(0.3)], startPoint: .top, endPoint: .bottom),
                        ignoresSafeAreaEdges: .all)
        }
    }
}

#Preview {
    ContentView()
}
