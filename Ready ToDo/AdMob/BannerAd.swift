//
//  BannerAd.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-02-07.
//

import SwiftUI

import SwiftUI
import GoogleMobileAds
import UIKit

struct BannerAd: View {
    var body: some View {
                BannerVC()
                    .frame(width: 320, height: 50, alignment: .center)
    }
}

struct BannerAd_Previews: PreviewProvider {
    static var previews: some View {
            LargeBannerAd()
                .frame(width: 320, height: 50, alignment: .center)
    }
}

final private class BannerVC: UIViewControllerRepresentable  {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let viewController = UIViewController()
        
        // Banner Ad
        view.adUnitID = admobUnitID
        view.rootViewController = viewController
        
        // View Controller
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        
        // Load an Ad
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
