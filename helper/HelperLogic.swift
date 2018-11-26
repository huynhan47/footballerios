//
//  HelperLogic.swift
//  fbiosvn2
//
//  Created by Posco ICT VN on 11/2/18.
//  Copyright © 2018 Posco ICT VN. All rights reserved.
//

import Foundation

class HelperLogic {
    static func shuffle(array: Array<String>) -> Array<String >{
        var returnArray = array;
        var m = array.count, i=0;
        var t = "";
        // Chừng nào vẫn còn phần tử chưa được xáo trộn thì vẫn tiếp tục
        while  (m > 0 ){
            // Lấy ra 1 phần tử
            i = Int((drand48() * Double(m)));
            m-=1;
            // Sau đó xáo trộn nó
            t = returnArray[m];
            returnArray[m] = returnArray[i];
            returnArray[i] = t;
        }
        return returnArray;
    }
    
    func skipQuestion(skipList : String, BitCoin : Int)
    {
        
        if(BitCoin == 0)
        {
            let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
            let dialogMessage = UIAlertController(title: "Hết BitCoin", message: "Xem Video Để Bỏ Qua Câu Hỏi Nhé", preferredStyle: .alert)
            imgViewTitle.image = UIImage(named:"e_1")
            dialogMessage.view.addSubview(imgViewTitle)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                    GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                }
                return;
            })
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
        else
        {
            skipList! += (",\"" + currentQuestionID! + "\"")
            print(skipList!)
            defaults.set(skipList!, forKey: "skipList")
            BitCoin -= 10
            defaults.set(BitCoin, forKey: "BitCoin")
            self.viewDidLoad()
        }
        
    }
}
