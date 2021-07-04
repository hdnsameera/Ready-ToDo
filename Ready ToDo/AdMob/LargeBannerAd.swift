//
//  BannerAd.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-02-07.
//

import SwiftUI
import GoogleMobileAds
import UIKit

struct LargeBannerAd: View {
    var body: some View {
                BannerVC()
                    .frame(width: 320, height: 100, alignment: .center)
    }
}

struct LargeBannerAd_Previews: PreviewProvider {
    static var previews: some View {
            LargeBannerAd()
                .frame(width: 320, height: 100, alignment: .center)
    }
}

final private class BannerVC: UIViewControllerRepresentable  {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeLargeBanner)
        let viewController = UIViewController()
        view.adUnitID = admobUnitID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeLargeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
