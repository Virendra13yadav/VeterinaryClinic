//
//  Toast.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
