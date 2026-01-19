//
//  SkeletonView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 17/01/26.
//

import SwiftUI

struct SkeletonView: View {
    @State private var phase: CGFloat = 0
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .overlay(
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, .white.opacity(0.4), .clear], startPoint: .leading, endPoint: .trailing))
                    .rotationEffect(.degrees(30))
                    .offset(x: phase * 200)
            )
            .mask(Rectangle())
            .onAppear { withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) { phase = 1 } }
            .cornerRadius(12)
    }
}
#Preview {
    SkeletonView()
        .frame(width: 200, height: 160)
        .padding()
}
