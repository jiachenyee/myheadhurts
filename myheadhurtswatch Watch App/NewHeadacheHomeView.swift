//
//  NewHeadacheHomeView.swift
//  myheadhurtswatch Watch App
//
//  Created by Jia Chen Yee on 12/23/24.
//

import SwiftUI

struct NewHeadacheHomeView: View {
    
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("log headache")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .center)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                viewModel.isNewEntrySheetPresented = true
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding(32)
                    .font(.title)
                    .background(.red.opacity(0.2))
                    .clipShape(.circle)
            }
            .foregroundStyle(.white)
            .buttonStyle(.plain)
            .padding()
            .sheet(isPresented: $viewModel.isNewEntrySheetPresented) {
                NavigationStack {
                    WatchHeadacheDetailView(headache: nil)
                }
            }
        }
    }
}

#Preview {
    NewHeadacheHomeView()
}
