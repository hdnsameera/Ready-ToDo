//
//  UpgradeView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-02-16.
//

import SwiftUI

struct UpgradeView: View {
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    @State private var showUpgradeDetails: Bool = false
    
    var body: some View {
        HStack {
            FullVersionRow()
            Spacer()
            VStack {
                if UserDefaults.standard.bool(forKey: productIDs[0]) {
                    Button(action: {
                        isPaidUser = true
                    }, label: {
                        Text("RESTORE")
                            .font(.caption)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                        .stroke()
                                        .frame(width: 80, height: 25)
                            )
                            .foregroundColor(Color.gray)
                    }).padding(.trailing, 5)
                } else {
                    Button(action: {
                        self.showUpgradeDetails.toggle()
                    }, label: {
                        
                        Text("UPGRADE")
                            .font(.caption)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                        .stroke()
                                        .frame(width: 80, height: 25)
                            )
                            .foregroundColor(Color.gray)
                    }).padding(.trailing, 5)
                    .sheet(isPresented: $showUpgradeDetails, content: {
                        UpgradeDetailsView()
                            .background(Color.black)
                            .preferredColorScheme(.dark)
                    })
                }
                
            }
        }
        .padding(.trailing)
        .frame(width: UIScreen.main.bounds.width, height: 80)
    }
}

struct UpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView().preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
