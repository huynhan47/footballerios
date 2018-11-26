//
//  ResultController.swift
//  MultiCollect
//
//  Created by Posco ICT VN on 8/14/18.
//  Copyright © 2018 Posco ICT VN. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
class ResultController : UIViewController
{
    var answerVNI : String = " ";
    var laiVNI : String = " ";
    var BitCoin : Int = 100;
    var QuynhAkaArray : [String] = ["QuynhOK_1","QuynhOK_2","QuynhOK_3","QuynhOK_4","QuynhOK_5","QuynhOK_6","QuynhOK_7","QuynhOK_8"]
    //var DialogueArray : [String] = ["d_1","d_2","d_3","d_4","d_5","d_6","d_7"]
    var DialogueArray : [String] = ["ok_1","ok_2","ok_3","ok_4","ok_5","ok_6","ok_7"]

    @IBOutlet weak var LaiView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var laiVNILabel: UILabel!
    @IBOutlet weak var QuynhAkaImg: UIImageView!
    @IBOutlet weak var DialogueImg: UIImageView!
    @IBOutlet weak var adBanner: GADBannerView!
    var inter: GADInterstitial?
    @IBAction func btnPlay(_ sender: Any) {
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ///inter!.present(fromRootViewController: self)
        var index = Int(arc4random_uniform(7));
        
        QuynhAkaImg.image = UIImage (named :QuynhAkaArray[index])
        
        laiVNILabel.text = laiVNI;
        laiVNILabel.adjustsFontSizeToFitWidth = true;
        laiVNILabel.minimumScaleFactor = 0.1;
        
        answerLabel.text = answerVNI;
        answerLabel.adjustsFontSizeToFitWidth = true;
        answerLabel.minimumScaleFactor = 0.1;
        
        index = Int(arc4random_uniform(8));
        QuynhAkaImg.image = UIImage (named :QuynhAkaArray[index])
        //adBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716";//Test
        adBanner.adUnitID = "ca-app-pub-8204407936442788/6745798291"; //Hero
 
        adBanner.rootViewController = self
        let  request = GADRequest();
        request.testDevices = [ "5d32c58b82e0a5043fe3c7f684a9a066" ];
        
        adBanner.load(request);
        
        LaiView.layer.borderColor = UIColor.white.cgColor;
        LaiView.layer.borderWidth = 5;
        GlobalVar.interAdsRate += 1;
        
    }
}

//extension ViewController: GADBannerViewDelegate {
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("Banner loaded successfully")
//        
//        // Reposition the banner ad to create a slide down effect
//        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
//        bannerView.transform = translateTransform
//        
//        UIView.animate(withDuration: 0.5) {
//            bannerView.transform = CGAffineTransform.identity
//        }
//    }
//    
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("Fail to receive ads")
//        print(error)
//    }
//    
//}
