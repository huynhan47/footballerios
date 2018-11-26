//
//  ViewController.swift
//  MultiCollect
//
//  Created by Posco ICT VN on 7/9/18.
//  Copyright © 2018 Posco ICT VN. All rights reserved.
//

import UIKit
import GoogleMobileAds
import iAd
import Toast_Swift
import SQLite

class ViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{


    @IBOutlet var MainView: UIView!
    @IBOutlet weak var target: UICollectionView!
    @IBOutlet weak var from: UICollectionView!
  
    @IBOutlet weak var club: UICollectionView!
    
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConstFrom: NSLayoutConstraint!
   
    @IBOutlet weak var Banner: GADBannerView!
    @IBAction func btnSkip(_ sender: Any)
    {
      
        //Add imageview to alert
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
      
        
        //alert.addAction(action)
        //self.present(alert, animated: true, completion: nil)
        
        let dialogMessage = UIAlertController(title: "Tạm Bỏ Qua", message: "Dùng 10 BitCoin Để Tạm Bỏ Qua", preferredStyle: .alert)
        imgViewTitle.image = UIImage(named:"e_1")
        dialogMessage.view.addSubview(imgViewTitle)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.skipQuestion()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func skipQuestion()
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
            defaults.set(skipList!, forKey: "GlobalVar.skipList")
            BitCoin -= 10
            defaults.set(BitCoin, forKey: "BitCoin")
            self.viewDidLoad()
        }

    }
    @IBAction func Bingo(_ sender: Any) {
        performSegue(withIdentifier: "Bingo", sender: self)
    }
    
    /////@IBOutlet weak var imgQuestion: UIImageView!
    
    @IBOutlet weak var btnBitScore: UIButton!
    var puzzText = ["L","A","I","C","H","U","2","0","1","8","S","T","U","D","I","O"]
    //var orgPuzzText = ["L","A","I","C","H","U"]
    var answerText   = [" ", " ", " "," "," "," "," "," "] as Array
    var mappingText = [1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8] as Array
    var currentIndex = 0 as Int?;
    var totalIndex = 0;
    var Index : Int = 0;
    var height = CGFloat(3) ;
    let max = UIScreen.main.bounds .width;
    var spacing = CGFloat(3) ;
    var size = 3 ;

    ///let path = Bundle.main.path(forResource: "laichu1", ofType: "sqlite")
    let path = Bundle.main.path(forResource: "laichu", ofType: "db")
    
    var imgQuestionName :String = "h_0007";
    /////var finishList :String? = "\"0000\"";
    /////var skipList :String? = "\"0009\",\"0014\",\"0014\",\"0016\",\"0017\"";
    let defaults = UserDefaults.standard;
    var OrgPuzzleString = "";
    var currentQuestionID : String?;
    var totalQuestionCount :Int64 = 0;
    var BitCoin : Int = 0
    var finishCount : Int = 0;
    var skipQuestionListFlag : Bool = true;
    var interstitial: GADInterstitial?
    var laiVNI : String = " ";
    var answerVNI : String = " ";
    let QuynhAkaArray : [String] = ["e_1","e_2","e_3","e_4","e_5","e_6","e_7","e_8"]
    let QuynhMCArray : [String] = ["QuynhMC_1","QuynhMC_2","QuynhMC_3","QuynhMC_4","QuynhMC_5","QuynhMC_6","QuynhMC_7","QuynhMC_8"]
    var MessageArray : [String] = [
        "Sai Rồi Bạn Ơi Thử Lại Nhé",
        "Sai Rồi! Thử Hỏi Bạn Bè Xem Sao! Nút Share Bên Dưới",
        "Sai Rồi Bạn Ơi Thử Lại Nhé",
        "Sai Rồi Bạn Ơi Thử Lại Nhé",
        "Sai Rồi Bạn Ơi Thử Lại Nhé",
        "Sai Rồi Bạn Ơi Thử Lại Nhé",
        "Sai Rồi Bạn Ơi Thử Lại Nhé",
        "Sai Rồi Bạn Ơi Thử Lại Nhé"]
    
    
    @IBOutlet weak var QuynhMC: UIImageView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID:
            //"ca-app-pub-3940256099942544/1033173712" //Test
            ///"ca-app-pub-8204407936442788/4948790453" //Hero Local Inter
            "ca-app-pub-8204407936442788/2111600477" //Hero Prd Inter
        )
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        request.testDevices = [ "5d32c58b82e0a5043fe3c7f684a9a066" ];
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    //Ad
//    lazy var adBannerView: GADBannerView = {
//        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        adBannerView.delegate = self
//        adBannerView.rootViewController = self
//
//        return adBannerView
//    }()
//
    
    @IBAction func LetShare(_ sender: Any) {
            let extractedExpr = captureScreen();
            let activityVC = UIActivityViewController(activityItems: [["Game Khó Nhất Quả Đất"], extractedExpr],applicationActivities: nil)
             present(activityVC, animated: true, completion: nil)
             if let popOver = activityVC.popoverPresentationController {
                popOver.sourceView = self.view
            }
        }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipQuestionListFlag = true; //reset skipFlag
        QuynhMC.image = UIImage (named :QuynhMCArray[Int(arc4random_uniform(8))])
        
        currentIndex = 0;
        interstitial = createAndLoadInterstitial()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        let request = GADRequest()
        
        request.testDevices = [ "5d32c58b82e0a5043fe3c7f684a9a066" ];
        GADRewardBasedVideoAd.sharedInstance().load(request,
                                                    withAdUnitID:
        ///    "ca-app-pub-8204407936442788/6787400591"
        ///"ca-app-pub-3940256099942544/1712485313"
        ///"ca-app-pub-8204407936442788/3125279764" //Paper Hero Local Video
        "ca-app-pub-8204407936442788/6787400591" //Paper Hero Prd Video
        )
        ///defaults.set("\"0000\",\"0009\",\"0014\",\"0014\",\"0016\",\"0017\"", forKey: "skipList")
        print(HelperLogic.shuffle(array: puzzText))
        from.delegate = self;
        from.dataSource = self;
        
        target.delegate = self;
        target.dataSource = self;
        
        club.delegate = self;
        club.dataSource = self;
        // Do any additional setup after loading the view, typically from a nib.
        
        //Don't know why to put this line here , but it uses to fix skip bug
        target.reloadData();
        //Ad
        
        ///Banner.adUnitID = "ca-app-pub-4345988626634460/8118253004";
        ///Banner.adUnitID = "ca-app-pub-3940256099942544/2934735716";//Test
        ///Banner.adUnitID = "ca-app-pub-8204407936442788/6745798291" //Hero Local
        Banner.adUnitID = "ca-app-pub-8204407936442788/9857803526" //Hero PRD
      

        Banner.rootViewController = self
        
        Banner.load(request);
        Banner.delegate = self;
        ////////
        /////imgQuestion.image = UIImage(named: "clock");
        ///////
        
        //lbl
        //lblBitscore = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21)
        
        //lblBitscore.backgroundColor = UIColor(patternImage: UIImage(named: "bitscore")!)
        //lbl
        
        //DataBase
        var db = try? Connection();
        let laichus = Table("laichu");
        let id = Expression<String?>("id")
        let letters = Expression<String?>("letters")
        do{
            db = try Connection(path!)
        }
        catch{
            let err1 = error as NSError
            print("error occurred, here are the details1:\n \(err1)")
            
        }
        //for laichu in try db!.prepare(laichus) {
        //    print("id: \(laichu[id]), name: \(user[name]), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        //}
        do {
            
            for laichu in try db!.prepare(laichus) {
                print("id: \(laichu[id]!)")
                // id: 1, name: Optional("Alice"), email: alice@mac.com
            }
            // SELECT * FROM "users"
        }
        catch{
            let err2 = error as NSError
            print("error occurred, here are the details2:\n \(err2)")
            
        }
        
        //try! db!.prepare(laichus)
   
        let question = laichus.filter(letters == "B_I_E_T_T_H_U")
        
        for row in try! db!.prepare(question)
        {
            print("id ne 0: \(row[id]!)")
        }
      
        finishList =  defaults.string(forKey: "finishList");
        if (finishList == nil)
        {
            finishList = "\"0000\"";
        }
        print(finishList!)
        
       GlobalVar.skipList =  defaults.string(forKey: "skipList");
        if (GlobalVar.skipList == nil)
        {
            GlobalVar.skipList = "\"0000\"";
        }
        print(GlobalVar.skipList!)
        
        //defaults.set("\"0003\"", forKey: "finishList")
        //finishList =  defaults.string(forKey: "finishList");
        //if (finishList == nil)
        //{
        //    finishList = "\"0005\"";
        //}
        print(finishList!)
        
        BitCoin =  defaults.integer(forKey: "BitCoin");
//        if (BitCoin == 0)
//        {
//            BitCoin = 30;
//        }
        print(BitCoin)
        btnBitScore.setTitle(String(BitCoin), for: .normal)
        //User Default - Start
        
        var sql = "SELECT * FROM LAICHU WHERE ID  NOT IN (" + finishList! + "," + GlobalVar.skipList! + ") ORDER BY ID ASC LIMIT 1 "
        ///var sql = "SELECT * FROM LAICHU WHERE ID   IN (\"0009\") ORDER BY ID ASC LIMIT 1 "
        print("sql ne: " + sql)
        
        var rows = try! db!.prepare(sql)
        for _ in rows
        {
            skipQuestionListFlag = false //if rows != 0
        }
        if (skipQuestionListFlag == true)
        {
  
            sql = "SELECT * FROM LAICHU WHERE ID  IN ("  + skipList! + ") ORDER BY "
            print("sql ne 2: " + sql)
            var orderBy = "CASE id ";
            var skipArray = skipList!.split(separator: ",")
            if(skipArray.count - 1 > 0)
            {
                for  index in  1 ... (skipArray.count - 1 )
                {
                orderBy.append(" WHEN " + String(skipArray[index]) + " THEN " + String(index) );
                }
            
                orderBy.append(" END LIMIT 1");
                sql.append(orderBy);
                print(sql)
                rows = try! db!.prepare(sql)
            }
            else
            {
               
            }
        }
        
        for row in rows
        {
            print("id ne 1: \(row[1]!)")
            currentQuestionID =  (row[0]) as? String
            skipList = skipList!.replacingOccurrences(of: ",\"" + currentQuestionID! + "\"", with: "")
            print("skipListAfter replace" + skipList!)
            defaults.set(skipList!, forKey: "skipList")
            imgQuestionName =  "h_" + currentQuestionID!
            OrgPuzzleString = row[2] as! String
            answerText = Array<String>(repeating: " ", count: OrgPuzzleString.split(separator: "_").count)
            totalIndex = answerText.count;
            laiVNI = row[6] as! String
            answerVNI = row [5] as! String
            
            
            let orgPuzzle = OrgPuzzleString.split(separator: "_")
            var orgPuzzleArray : [String] = []
            for i in 0 ..< orgPuzzle.count
            {
                if (orgPuzzle[i] != "_")
                {
                    orgPuzzleArray.append(String(orgPuzzle[i]))
                }
            }
            puzzText =  HelperLogic.shuffle(array:  genRandomText(orgTextArray: orgPuzzleArray, length: 16))
            
        }

        /////print("imgQuestionName ne :"  +  imgQuestionName)
        /////imgQuestion.image = UIImage(named: imgQuestionName)
        
        
        let sql_count = "SELECT count(*) FROM LAICHU"
        print("sql ne: " + sql)
        for row in try! db!.prepare(sql_count)
        {
             print("total ne 1: \(row[0]!)")

             totalQuestionCount = row[0]! as! Int64
        }
        
        finishCount = finishList!.split(separator: ",").count;
        print("finishCount ne 1: " + String(finishCount))
        
        lblProgress.text = String(finishCount - 1) + "/" + String(totalQuestionCount);
        //User Default - End
        
        
        // make UI
        //From UI
        let numberOfItemsPerRow = 8;
        let flowLayout = target.collectionViewLayout as! UICollectionViewFlowLayout
        
        spacing = max / 212;
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right +
            (spacing * CGFloat(numberOfItemsPerRow - 1))
        size = Int((max - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        heightConstFrom.constant = (CGFloat(size) + 10)*2
        from.contentInset.bottom = 10;
       
        from.reloadData();
        
        
        //Target UI
        let numberOfItemsPerRowTarget = 8;
        //let flowLayoutTarget = target.collectionViewLayout as! UICollectionViewFlowLayout
        
        spacing = max / 212;
        let totalSpaceTarget = //flowLayoutTarget.sectionInset.left
           // + flowLayoutTarget.sectionInset.right +
            (spacing * CGFloat(numberOfItemsPerRowTarget - 1))
        size = Int((max - totalSpaceTarget) / CGFloat(numberOfItemsPerRowTarget))
        
        ///heightConst.constant = CGFloat(size) + 10 // Cancel. It will set after get answer count
        if(totalIndex < 8)
        {
            heightConst.constant = CGFloat(size) + 10
            target.contentInset.left = (max - totalSpaceTarget - CGFloat((size * totalIndex)))/2;
            target.contentInset.right = (max - totalSpaceTarget - CGFloat((size * totalIndex)))/2;
        }
        else{
            heightConst.constant = CGFloat(size)*2 + 20
            target.contentInset.left = 0
            target.contentInset.right = 0
        }
        
        target.contentInset.top = 0;
        target.reloadData();
    }
    override func viewDidAppear(_ animated: Bool) {
        if (finishCount - 1  == totalQuestionCount)
        {
            //Add imageview to alert
            let imgViewTitle2 = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
            
            //alert.addAction(action)
            //self.present(alert, animated: true, completion: nil)
            
            let dialogMessage2 = UIAlertController(title: "Đã Hoàn Thành", message: "Hãy Reset Game Để Chơi Lại Nhé", preferredStyle: .alert)
            imgViewTitle2.image = UIImage(named:"e_1")
            dialogMessage2.view.addSubview(imgViewTitle2)
            
            // Create OK button with action handler
            let ok2 = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                self.performSegue(withIdentifier: "Welcome", sender: self)
            })
            
            
            //Add OK and Cancel button to dialog message
            dialogMessage2.addAction(ok2)
            
            // Present dialog message to user
            self.present(dialogMessage2, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 ;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.target
        {
            //return OrgPuzzleString.split(separator: "_").count;
            let index = OrgPuzzleString.split(separator: "_").count
            print("OrgPuzzleString ne: " + String(index))
            return index
        }
        else if collectionView == self.from
        {
            return puzzText.count;
            
        }
        else
        {
            return 3;
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.target
        {
            
            let cell:targetCellUnit = collectionView.dequeueReusableCell(withReuseIdentifier: "targetCellUnit", for: indexPath) as! targetCellUnit
            //cell.backgroundColor = UIColor.red;
            cell.targetLabel.text = answerText[indexPath.row]
            cell.contentView.layer.cornerRadius = 10.0
            cell.contentView.layer.borderWidth = 3.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.masksToBounds = true
            
            if (cell.targetLabel.text != " ")
            {
                cell.contentView.backgroundColor = UIColor(hexString:  "D34722");
            }
            else
            {
                cell.contentView.backgroundColor = UIColor.black;
            }
    
            return cell;
            
        }
        else if (collectionView == self.from)
        {
            let cell:fromCellUnit = collectionView.dequeueReusableCell(withReuseIdentifier: "fromCellUnit", for: indexPath) as! fromCellUnit
            cell.fromLabel.text = puzzText[indexPath.row]
            cell.contentView.layer.cornerRadius = 10.0
            cell.contentView.layer.borderWidth = 3.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.masksToBounds = true
            if (cell.fromLabel.text != " ")
            {
                cell.contentView.backgroundColor = UIColor(hexString:  "D34722");
            }
            else
            {
                cell.contentView.backgroundColor = UIColor.black;
            }
            
            return cell;
        }
        else //if (collectionView == self.club)
        {
             let cell:clubCellUnit = collectionView.dequeueReusableCell(withReuseIdentifier: "clubCellUnit", for: indexPath) as! clubCellUnit
            cell.clubLogo.image = UIImage(named: "QuynhMC_1");
             return cell;
        }
        
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
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    //{
        //return UIEdgeInsetsMake(0,0,0,0)
        
    //}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == self.target
         {
            if(answerText[indexPath.row] == " ") // Check if blank cell press
            {
                return;
            }
            print(indexPath.row)
            //currentIndex?-=1;
            puzzText[Int(mappingText[indexPath.row])] =  answerText[indexPath.row]; // revert puzzle text
    
            answerText[indexPath.row] = " "; //delete answer text
            currentIndex = answerText.index(of: " ") //Find the first blank to identify the current cell to process
        }
         else if collectionView == self.from
         {
            if (puzzText[indexPath.row] == " " || answerText.index(of: " ") == nil) // Check if blank cell press
            {
                return;
            }
            answerText[currentIndex!] = puzzText[indexPath.row] // display answer text
            mappingText[currentIndex!] = indexPath.row; //track the index of answer texr
            puzzText[indexPath.row] = " "; // delete the puzzle text
            print(answerText[currentIndex!])
            currentIndex = answerText.index(of: " ") //Find the first blank to identify the current cell to process
            //currentIndex?+=1;
            
            if(currentIndex == nil) //When all blank cell are filled, check the answer
            {
                validAnswer();
            }
            
            //Change visible of selecting cell
            let cell:fromCellUnit = collectionView.dequeueReusableCell(withReuseIdentifier: "fromCellUnit", for: indexPath) as! fromCellUnit
            cell.fromLabel.text = puzzText[indexPath.row]
            
            cell.contentView.layer.cornerRadius = 10.0
            cell.contentView.layer.borderWidth = 3.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.backgroundColor = UIColor.black;
            cell.contentView.layer.masksToBounds = true
        }
        else
         {
            
        }
        //let  height = collectionView.collectionViewLayout.collectionViewContentSize.height;
        //heightConst.constant = height

        target.reloadData();
        from.reloadData();
     
        ///self.view.makeToast("This is a piece of toast", duration: 2.0, point: CGPoint(x: 110.0, y: 110.0), ///title: "Toast Title", image: captureScreen()) { didTap in
         ///   if didTap {
         ///       print("completion from tap")
          ///  } else {
          ///      print("completion without tap")
           /// }
       /// }
            
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //print("size");
        //print(size)
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = spacing;
        //print("height2")
        //height  = CGFloat(size*3);
        //print(height)
 
        return CGSize(width: size, height: size)
        
        //flowLayout.collectionViewContentSize
        //let horizontalSpacing = layout.scrollDirection == .vertical ? layout.minimumInteritemSpacing : layout.minimumLineSpacing
        //let width = UIScreen.main.bounds.width
        //print(CGSize(width: (width - 10)/11, height: (width - 10)/11))
        //return CGSize(width: (width - 10)/11, height: (width - 10)/11) // width & height are the same to make a square cell
    }
    func validAnswer ()
    {
        let AnswerString = answerText.joined(separator: "_");
        ///let OrgPuzzleString = orgPuzzText.joined();
        if (AnswerString == OrgPuzzleString)
        {
            print("Bingo");
            finishList! += (",\"" + currentQuestionID! + "\"")           
            defaults.set(finishList, forKey: "finishList")
            BitCoin += 10
            defaults.set(BitCoin, forKey: "BitCoin")
            
            //Load Ad
            performSegue(withIdentifier: "Bingo", sender: self)
            ///interstitial?.present(fromRootViewController: self)
        }
        else
        {
            print("Wrong");
  
            let indexImage = Int(arc4random_uniform(6));
            let indexMessage = Int(arc4random_uniform(6));
            //QuynhAkaImg.image = UIImage (named :QuynhAkaArray[index])
            
            self.view.makeToast(MessageArray[indexMessage], duration: 2.0, point: CGPoint(x: self.view.frame.width/2  , y: self.view.frame.height/2), title: "Thông Báo", image:  UIImage (named :QuynhAkaArray[indexImage])) { didTap in
                if didTap {
                    print("completion from tap")
                } else {
                    print("completion without tap")
                }
              }
        }
    }
    
    func genRandomText(orgTextArray : [String], length : Int) -> [String]{
        let textRemain = length - orgTextArray.count;
        var resultArray = orgTextArray;
        let abcString : String = "ABCDEFGHIKLMNOPQRSTUVXY";
       
        ///let abcArray : [Character] = Array(abcString)
        if (textRemain > 0)
        {
            for _ in 1...textRemain
            {
                let offset = Int(arc4random_uniform(23));
                resultArray.append(abcString.subString(from : offset, to: (offset)));
            }
        }
        return resultArray
    }
    
    
    
}

extension ViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads Banner")
        print(error)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Bingo") {
            let vc = segue.destination as! ResultController
            vc.answerVNI = answerVNI;
            vc.laiVNI = laiVNI;
            ///vc.inter = self.interstitial;
        }
    }
    
}
extension ViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        if(GlobalVar.interAdsRate % 3 == 0)
        {
            ad.present(fromRootViewController: self)
        }
    }
//    func didFailToReceiveAdWithError()
//    {
//
//    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial)
    {
        ///performSegue(withIdentifier: "Bingo", sender: self)
    }
}
extension ViewController: GADRewardBasedVideoAdDelegate {
func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                        didRewardUserWith reward: GADAdReward) {
    print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    print("Reward based video ad has completed.")
    skipList! += (",\"" + currentQuestionID! + "\"")
    print(skipList!)
    defaults.set(skipList!, forKey: "skipList")
    self.viewDidLoad()
}

func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
    print("Reward based video ad is received.")
}

func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Opened reward based video ad.")
}

func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad started playing.")
}

func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad has completed.")
    skipList! += (",\"" + currentQuestionID! + "\"")
    print(skipList!)
    defaults.set(skipList!, forKey: "skipList")
    self.viewDidLoad()
}

func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad is closed.")
    self.viewDidLoad();
}

func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad will leave application.")
}

func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                        didFailToLoadWithError error: Error) {
    print("Reward based video ad failed to load.")
}
}
extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
