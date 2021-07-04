//
//  OnBoardingView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import SwiftUI
import StoreKit

struct OnboardingView: View {
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    var page: Page

    var body: some View {
        VStack {
            TabView {
                ForEach(0 ..< Page.allCases.count) { item in
                    switch item {
                    case 0: OnboardingCard(page: Page.title1).padding(20)
                    case 1: OnboardingCard(page: Page.title2).padding(20)
                    case 2 : OnboardingCard(page: Page.title3).padding(20)
                    default: OnboardingCard(page: Page.title3).padding(20)
                    }
                }
            }.tabViewStyle(PageTabViewStyle())
        }
        .onAppear(perform: {
            
            if UserDefaults.standard.bool(forKey: productIDs[0]) {
                isPaidUser = true
            }
        })
        .statusBar(hidden: true)
        .ignoresSafeArea(.all)
    }
    
    init() {
        page = .title1
        UIPageControl.appearance().currentPageIndicatorTintColor = .orange
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
    }
}
