//
//  HeadacheListSectionView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import SwiftUI
import SwiftData

struct HeadacheListSectionView: View {
    
    @Query(sort: \Headache.date, order: .reverse) var headaches: [Headache]
    
    @Namespace private var namespace
    @Environment(\.modelContext) private var modelContext
    
    let startOfDay: Date
    
    init(startOfDay: Date) {
        self.startOfDay = startOfDay
        
        let endOfDay = startOfDay.addingTimeInterval(24 * 60 * 60)
        
        _headaches = Query(filter: #Predicate {
            $0.date >= startOfDay && $0.date < endOfDay
        }, sort: \.date, order: .reverse )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(startOfDay.formattedDateOnly.lowercased())
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(headaches) { headache in
                NavigationLink(destination: HeadacheDetailView(headache: headache)) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(headache.date.formatted(date: .omitted, time: .shortened).lowercased())
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.episodeTitle)
                            
                            Spacer()
                            
                            Text(headache.severity.rawValue)
                                .font(.headline)
                        }
                        
                        if !headache.notes.isEmpty {
                            Text(headache.notes)
                                .foregroundStyle(.secondary)
                                .foregroundStyle(Color(.label))
                                .multilineTextAlignment(.leading)
                        }
                        
                        if !headache.traits.isEmpty {
                            WrappingHStack(models: headache.traits) { trait in
                                Text(trait.rawValue)
                                    .padding(4)
                                    .padding(.horizontal)
                                    .background(Color.accentColor.opacity(0.1))
                                    .clipShape(.capsule)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.1), radius: 8)
                    .contextMenu {
                        Button(role: .destructive) {
                            modelContext.delete(headache)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                    }
                }
            }
        }
    }
}
