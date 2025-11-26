//
//  View+.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

extension Image {
    func petImageStyle(width: CGFloat = 100,
                       cornerRadius: CGFloat = 10) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: width, height: width)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    static var petPlaceholder: Image {
        Image(systemName: "pawprint.fill")
    }
}
