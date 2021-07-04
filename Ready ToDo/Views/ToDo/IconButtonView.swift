//
//  IconButtonView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-27.
//

import SwiftUI

struct IconButtonView: View {

    let icon: String
    let width, height: CGFloat
    @Binding var bindingBool: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.bindingBool.toggle()
            }
        }, label: {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
        })
    }
}

struct IconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        IconButtonView(icon: "gear", width: 300, height: 300, bindingBool: .constant(true))
            .foregroundColor(Color.secondary)
    }
}
