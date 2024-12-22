//
//  ContentView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI
import SwiftData
import HealthKit

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel.shared
    
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
                    viewModel.isNewEntrySheetPresented = true
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
            .sheet(isPresented: $viewModel.isNewEntrySheetPresented) {
                NavigationStack {
                    HeadacheDetailView(headache: nil)
                }
            }
            .background(LinearGradient(colors: [.clear, .accentColor.opacity(0.3)], startPoint: .top, endPoint: .bottom),
                        ignoresSafeAreaEdges: .all)
            .onOpenURL { url in
                viewModel.isNewEntrySheetPresented = true
            }
        }
        .task {
            await viewModel.requestAuthorization()
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
