//
//  FullVersionRow.swift
//  Ready ToDo
//
//  Created by H.D.N.Sameera on 2021-03-14.
//

import SwiftUI

struct FullVersionRow: View {
    var body: some View {
        HStack {
            Image(appLogo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(Color.secondary)
                .frame(width: 55, height: 55)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke()
                            .foregroundColor(Color.gray)
                            .frame(width: 56, height: 56)
                )
                .padding(.trailing)
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text(appName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.blue)
                        Text("Full Version")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    }
                    Spacer()
                }.frame(width:UIScreen.main.bounds.width/2.5)
            }
            
        }.padding()
        .frame(width:UIScreen.main.bounds.width/1.4, height: 80)
    }
}

struct FullVersionRow_Previews: PreviewProvider {
    static var previews: some View {
        FullVersionRow()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
