//
//  StatisticNumberHighlightView.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import SwiftUI

struct StatisticNumberHighlightView: View {
    
    var value: Int
    var title: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .contentTransition(.numericText())
                .monospacedDigit()
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentColor)
            
            Text("\(title)")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Material.thinMaterial)
        .clipShape(.rect(cornerRadius: 8))
        .shadow(color: .black.opacity(0.2), radius: 4)
        .animation(.default, value: value)
    }
}
