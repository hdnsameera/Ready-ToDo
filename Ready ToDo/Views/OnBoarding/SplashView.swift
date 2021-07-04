//
//  SplashView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-02-03.
//

import SwiftUI
import StoreKit

struct SplashView: View {
    
    let persistenceController = PersistenceController.shared
    
    @State private var animate: Bool = false
    @State private var endSplash: Bool = false
    
    var body: some View {
            ZStack {
                
                ToDoMaster().environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                ZStack {
                    Color.black
                    VStack {
                        
                        Image(appLogo)
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 55, height: 55)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke()
                                        .foregroundColor(Color.gray)
                                        .frame(width: 56, height: 56)
                            )
                            
                            .aspectRatio(contentMode: animate ? .fill : .fit)
                            .frame(width: animate ? nil : 85, height: animate ? nil : 85)
                            .scaleEffect(animate ? 6 : 1 )
                            .frame(width: UIScreen.main.bounds.width)
                        
                        Text(appName)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                    }
                    
                    Text("Version \(appVersion)")
                        .font(.footnote)
                        .foregroundColor(Color.white)
                        .padding()
                        .offset(y: UIScreen.main.bounds.height/2 - 25)
                }
                .ignoresSafeArea(.all, edges: .all)
                .onAppear() {
                    animateSplash()
                }
                .opacity(endSplash ? 0 : 1 )
            }
            .statusBar(hidden: true)
    }
    
    func animateSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

            withAnimation(Animation.easeOut(duration: 0.55) ) {
                animate.toggle()
            }

            withAnimation(Animation.easeIn(duration: 0.45) ) {
                endSplash.toggle()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
