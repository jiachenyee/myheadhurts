//
//  ContentView.swift
//  myheadhurtswatch Watch App
//
//  Created by Jia Chen Yee on 12/23/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @Query var headaches: [Headache]
    
    var body: some View {
        TabView {
            NewHeadacheHomeView()
            
            if headaches.isEmpty {
                ContentUnavailableView("no headaches to show",
                                       systemImage: "face.smiling")
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
            } else {
                ZStack {
                    NavigationStack {
                        HeadacheListView()
                            .scrollContentBackground(.hidden)
                    }
                    .background(LinearGradient(colors: [.clear, .accentColor.opacity(0.3)], startPoint: .top, endPoint: .bottom),
                                ignoresSafeAreaEdges: .all)
                }
            }
        }
        .tabViewStyle(.verticalPage)
        .task {
            await viewModel.requestAuthorization()
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
