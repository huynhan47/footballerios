//
//  WelcomeController.swift
//  MultiCollect
//
//  Created by Posco ICT VN on 8/15/18.
//  Copyright © 2018 Posco ICT VN. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class WelcomeController : UIViewController
{ 
    let defaults = UserDefaults.standard;
    var BitCoin : Int = 0;
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblBitCoin: UILabel!
    
    
    @IBOutlet weak var ScoreView: UIView!
    @IBAction func ResetGame(_ sender: Any) {
        //Add imageview to alert
        let imgViewTitle2 = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        
        
        //alert.addAction(action)
        //self.present(alert, animated: true, completion: nil)
        
        let dialogMessage2 = UIAlertController(title: "Reset Game", message: "Có Chắc Chắn Chơi Lại Từ Đầu?", preferredStyle: .alert)
        imgViewTitle2.image = UIImage(named:"e_1")
        dialogMessage2.view.addSubview(imgViewTitle2)
        
        // Create OK button with action handler
        let ok2 = UIAlertAction(title: "OK Chắc Chắn", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.defaults.set("\"0000\"", forKey: "finishList")
            self.defaults.set("\"0000\"", forKey: "skipList")
            self.defaults.set(30, forKey: "BitCoin")
            self.viewDidLoad()
        })
        
        // Create Cancel button with action handlder
        let cancel2 = UIAlertAction(title: "Lỡ Tay Bấm Nhầm", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage2.addAction(ok2)
        dialogMessage2.addAction(cancel2)
        
        // Present dialog message to user
        self.present(dialogMessage2, animated: true, completion: nil)
        
        
    }
    
    @IBAction func ShareGame(_ sender: Any) {
//
//        let myWebsite = NSURL(string:"http://www.google.com/")
//        let img: UIImage = UIImage(named: "ok_1.png")!
//
//        guard let url = myWebsite else {
//            print("nothing found")
//            return
//        }        
        let extractedExpr1: UIImage = UIImage(named: "qr.png")!;
        let extractedExpr2: UIImage = UIImage(named: "share2.jpg")!;
        let activityVC = UIActivityViewController(activityItems: [["Game Khó Nhất Quả Đất"],extractedExpr1,extractedExpr2],applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        if let popOver = activityVC.popoverPresentationController {
            popOver.sourceView = self.view
        }
    }
    let path = Bundle.main.path(forResource: "laichu", ofType: "db")
    var totalQuestionCount :String = " "
    var finishList : String? = "\"0000\""
    var finishCount : Int? = 0 ;
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        BitCoin =  defaults.integer(forKey: "BitCoin");
        if (BitCoin == 0)
        {
            BitCoin = 30;
        }
        defaults.set(BitCoin, forKey: "BitCoin")
        lblBitCoin.text = String(BitCoin);
        
        finishList =  defaults.string(forKey: "finishList");
        if (finishList == nil)
        {
            finishList = "\"0000\"";
        }
        print(finishList!)
        
        
        super.viewDidLoad();
       
        
        var db = try? Connection();
       
        do{
            db = try Connection(path!)
        }
        catch{
            
        }
        
        let sql_count = "SELECT count(*) FROM LAICHU"
        for row in try! db!.prepare(sql_count)
        {
            //print("total ne 1: \(row[0]!)")
            totalQuestionCount = String(row[0]! as! Int64)
             print("total ne 1: \(row[0]!)" + totalQuestionCount)
        }
        finishCount = finishList?.split(separator: ",").count ;
        lblScore.text = String(finishCount! - 1) + "/" + totalQuestionCount;
        print("total ne 1:" +  lblScore.text! )
        
        ScoreView.layer.borderWidth = 3;
        ScoreView.layer.borderColor = UIColor.white.cgColor;        
    }
    func captureScreen() -> UIImage {
        var window: UIWindow? = UIApplication.shared.keyWindow
        window = UIApplication.shared.windows[0]
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, window!.isOpaque, 0.0)
        window!.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }
}
