//
//  OnboardingCard.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import SwiftUI

struct OnboardingCard: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var isAnimated: Bool = false
    
    var page: Page
    
    let onBoardingData = OnBoardingData()
    
    @State var images: [String] = ["onBoardingImage_01"]
    @State var tips: [String] = ["Use your time wisely."]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 50) {
                Spacer()
                    VStack {
                        VStack {
                            Text(page.rawValue)
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Spacer()
                            Image(images.randomElement() ?? images[0])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.height/2.5, height: geometry.size.height/2.5)
                                .layoutPriority(0.5)
                                .offset(y: isAnimated ? -50 : 0)
                                .animation(.easeInOut(duration: 1.5))
                        }.frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                        
                        Text(tips.randomElement() ?? tips[0])
                            .layoutPriority(0.5)
                            .font(.system(.headline, design: .rounded))
                            .animation(.easeInOut(duration: 1.5))
                            .padding(.top, geometry.size.height/20)
                    }
                    .onAppear(perform: {
                        self.isAnimated = true
                        images.append(contentsOf: onBoardingData.imagesToDo)
                        tips.append(contentsOf: onBoardingData.tipsTodo)
                    })
                    .onDisappear(perform: {
                        self.isAnimated = false
                    })
                        Button(action: {
                            isOnboarding = false
                        }, label: {
                            HStack(spacing: 8) {
                                Text("Start")
                                Image(systemName: "arrow.right.circle")
                                    .imageScale(.large)
                            }.padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Capsule().strokeBorder(Color("ColorButton"), lineWidth: 1.25))
                        }).accentColor(Color("ColorButton"))
                Spacer()
            }
        }
    }
}

struct OnboardingCard_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCard(page: Page.title1)
            .preferredColorScheme(.dark)
    }
}
