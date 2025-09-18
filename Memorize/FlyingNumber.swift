//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Вячеслав Полянский on 18.09.2025.
//

import SwiftUI

struct FlyingNumber: View {
    
    let number: Int
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number)
        }
    }
}

#Preview {
    FlyingNumber(number: 5)
}
