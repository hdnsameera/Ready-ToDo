//
//  SettingsToggleRow.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import SwiftUI

struct SettingsToggleRow: View {
    
    // MARK: - PROPERTIES
    
    let name: String
    
    @Binding var isOn: Bool
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Toggle(isOn: $isOn, label: {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundColor(isOn ? Color.orange : Color.gray)
            })
        }.padding(.top, -3)
        .padding(.bottom, -3)
    }
}
