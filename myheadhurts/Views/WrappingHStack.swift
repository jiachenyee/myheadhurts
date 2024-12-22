//
//  WrappingHStack.swift
//  myheadhurts
//
//  Created by Jia Chen Yee on 12/20/24.
//

import Foundation
import SwiftUI

struct WrappingHStack<Model, V>: View where Model: Hashable, V: View {
    typealias ViewGenerator = (Model) -> V
    
    var models: [Model]
    var viewGenerator: ViewGenerator
    var horizontalSpacing: CGFloat = 4
    var verticalSpacing: CGFloat = 4
    
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        let geometryWidth = geometry.size.width
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.models, id: \.self) { models in
                viewGenerator(models)
                    .padding(.horizontal, horizontalSpacing)
                    .padding(.vertical, verticalSpacing)
                    .alignmentGuide(.leading) { dimension in
                        if (abs(width - dimension.width) > geometryWidth) {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if models == self.models.last! {
                            width = 0 //last item
                        } else {
                            width -= dimension.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { dimension in
                        let result = height
                        if models == self.models.last! {
                            height = 0 // last item
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry in
            let rect = geometry.frame(in: .local)
            
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            
            return Color.clear
        }
    }
}
