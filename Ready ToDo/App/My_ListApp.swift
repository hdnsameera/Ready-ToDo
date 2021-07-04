//
//  My_ListApp.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import SwiftUI
import GoogleMobileAds

@main
struct My_ListApp: App {
    
    @StateObject var storeManager = StoreManager()
    
    @AppStorage ("isOnboarding") var isOnboarding: Bool = true
    
    @AppStorage ("tickSoundOn") var tickSoundOn: Bool = false
    @AppStorage ("setReminder") var setReminder: Bool = false
    @AppStorage ("isSwooshAppearMP3") var isSwooshAppearMP3: Bool = false
    @AppStorage ("sortViewAppearSound") var sortViewAppearSound: Bool = false
    
    @AppStorage ("isAscending") var isAscending: Bool = true
    @AppStorage ("status") var status: Status = .all
    @AppStorage ("currentSort") var currentSort: SortBy = .timestamp
    
    @AppStorage ("autoCorrection") var autoCorrection: Bool = true
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @AppStorage("applyThemesToLists") var applyThemesToLists: Bool = false
    
    // Priority Colors
    @AppStorage ("priority1ColorCode") var priority1ColorCode: Int = 9342611
    @AppStorage ("priority2ColorCode") var priority2ColorCode: Int = 31487
    @AppStorage ("priority3ColorCode") var priority3ColorCode: Int = 16726832
    
    @AppStorage ("badgeCount") var badgeCount: Int = 0
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
                    .preferredColorScheme(.dark)
            } else {
                SplashView()
                    .preferredColorScheme(.dark)
                    .onAppear(perform: {
                        UIApplication.shared.addTapGestureRecognizer()
                        SKPaymentQueue.default().add(storeManager)
                        storeManager.getProducts(productIDs: productIDs)
                        storeManager.restoreProducts()
                        if UserDefaults.standard.bool(forKey: productIDs[0]) {
                            isPaidUser = true
                        }
                        
                    })
                    
            }
        }
    }
}
