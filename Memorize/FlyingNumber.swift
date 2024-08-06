//
//  FlyingNumber.swift
//  Memorize
//
//  Created by HannPC on 2024/8/4.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {

        if number != 0 {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundColor(number < 0 ? .red : .green)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                .offset(x: 0, y: offset)
                .opacity(offset == 0 ? 1 : 0)
                .onAppear {
                    offset = 0
                    withAnimation(.easeInOut(duration: 0.5)) {
                        offset = number < 0 ? 80 : -80
                    }
                }
        }
    }
}


#Preview {
    FlyingNumber(number:5)
}
