//
//  SettingsLabel.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import SwiftUI

struct SettingsLabel: View {
    
    // MARK: - PROPERTIES
    var labelText: String
    var labelImage: String

    // MARK: - BODY
    var body: some View {
        HStack {
            Text(labelText)
                .fontWeight(.semibold)
                .textCase(.uppercase)
            Spacer()
            Image(systemName: labelImage)
        }
    }
}

struct SettingsLabel_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLabel(labelText: "application", labelImage: "paintbrush").previewLayout(.sizeThatFits)
            .padding()
    }
}
