//
//  ContentView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNewEntrySheetPresented = false
    
    @State private var headacheManager = HeadacheManager()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        VStack {
                            Text("\(headacheManager.headaches.count)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .monospacedDigit()
                            
                            Text("total")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background()
                        .clipShape(.rect(cornerRadius: 8))
                        
                        VStack {
                            let thisWeekHeadache = headacheManager.headaches.filter { $0.date > .now.startOfWeek }
                            
                            Text("\(thisWeekHeadache.count)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .monospacedDigit()
                            
                            Text("this week")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background()
                        .clipShape(.rect(cornerRadius: 8))
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color.clear)
                }
                
                Section("episodes") {
                    HeadacheListView(headaches: $headacheManager.headaches)
                }
                
            }
            .navigationTitle("my head hurts")
            .sheet(isPresented: $isNewEntrySheetPresented) {
                LogHeadacheView { newHeadache in
                    headacheManager.headaches.append(newHeadache)
                }
            }
        }
        .overlay(alignment: .bottom) {
            Button {
                isNewEntrySheetPresented = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
                    .font(.system(size: 60))
            }
        }
        .environment(headacheManager)
    }
}

#Preview {
    ContentView()
}

extension Date {
    var startOfWeek: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
}
