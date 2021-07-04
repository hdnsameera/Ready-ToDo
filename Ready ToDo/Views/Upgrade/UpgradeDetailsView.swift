//
//  UpgradeDetailsView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-02-18.
//

import SwiftUI

struct UpgradeDetailsView: View {
    
    @StateObject var storeManager = StoreManager()
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    @AppStorage ("isOnboarding") var isOnboarding: Bool = true
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(Color.secondary)
                }).padding()
            }
            
            HStack {
                FullVersionRow()
                if !storeManager.myProducts.isEmpty {
                    VStack {
                        if UserDefaults.standard.bool(forKey: storeManager.myProducts[0].productIdentifier) {

                        } else {
                            VStack(spacing: 10) {
                                Button(action: {
                                    storeManager.purchaseProduct(product: storeManager.myProducts[0])
                                    self.presentationMode.wrappedValue.dismiss()
                                    isOnboarding = true

                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 30)
                                            .foregroundColor(Color.gray.opacity(0.2))
                                            .frame(width: 75, height: 23, alignment: .center)

                                        Text("USD \(storeManager.myProducts[0].price)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.blue)
                                    }

                                })

                                Button(action: {
                                    if UserDefaults.standard.bool(forKey: productIDs[0]) {
                                        isPaidUser = true
                                        self.presentationMode.wrappedValue.dismiss()
                                        isOnboarding = true
                                    }
                                }, label: {

                                    ZStack {
                                        RoundedRectangle(cornerRadius: 30)
                                            .foregroundColor(Color.gray.opacity(0.2))
                                            .frame(width: 75, height: 23, alignment: .center)

                                        Text("RESTORE")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.blue)
                                    }
                                })
                            }
                    }

                    }
                }
            }.padding(.trailing, 5)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Ads Free")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.green)
                    
                    Divider()
                    
                    ForEach(features.sorted(by: <), id:\.key) { image, feature in
                        FeatureRow(feature: feature, image: image)
                    }
                }
            }
        }
        .onAppear(perform: {
            storeManager.getProducts(productIDs: productIDs)
        })
    }
}

struct FeatureRow: View {
    
    let feature, image: String
    
    var body: some View {
        VStack {
            Text(feature)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.green)
                .padding(.top, 20)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct UpgradeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeDetailsView()
            .preferredColorScheme(.dark)
    }
}
