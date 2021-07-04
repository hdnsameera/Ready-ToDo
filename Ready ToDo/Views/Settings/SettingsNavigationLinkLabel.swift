//
//  SettingsNavigationLinkLabel.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-24.
//

import SwiftUI

struct SettingsNavigationLinkLabel: View {
    
    // MARK: - PROPERTIES
    let text: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
            Spacer()
            Image(systemName: "chevron.right")
        }.font(.body)
        .foregroundColor(Color.gray)
        .padding(.top, 2)
        .padding(.bottom, 2)
    }
}

struct SettingsNavigationLinkLabel_Previews: PreviewProvider {
    static var previews: some View {
        SettingsNavigationLinkLabel(text: "Appearance")
    }
}
