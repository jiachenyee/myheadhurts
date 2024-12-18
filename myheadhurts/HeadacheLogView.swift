//
//  HeadacheLogView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/18/24.
//

import SwiftUI

struct HeadacheLogView: View {
    
    @Environment(HeadacheManager.self) var headacheManager
    
    var body: some View {
        
        @Bindable var headacheManager = headacheManager
        
        NavigationStack {
            HeadacheListView(headaches: $headacheManager.headaches)
                .navigationTitle("headache log")
        }
    }
}

#Preview {
    @Previewable @State var headacheManager = HeadacheManager()
    
    HeadacheLogView()
        .environment(headacheManager)
}
