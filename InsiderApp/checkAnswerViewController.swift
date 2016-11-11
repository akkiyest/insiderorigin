//
//  checkAnswerViewController.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/23.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit

class checkAnswerViewController: UIViewController {
    
    @IBOutlet weak var imageview: UIImageView!
    var INSnum:Int = 999
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.image = #imageLiteral(resourceName: "master")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        diceRoll()
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "出題者しか見えないように端末を持ち、\nOKを押してください。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.answerLabel.text = PlayerControll.sharedHQ.Keywords[self.INSnum]
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func diceRoll(){
        INSnum = Int(arc4random_uniform(UInt32(PlayerControll.sharedHQ.PlayerNum)))
    }
    
    //引き直したとき同じものが出ない。
    func diceReroll(){
        let oldINSnum = INSnum
        
        while oldINSnum == INSnum
        {
        diceRoll()
        }
        
    }
    
    @IBAction func startButton(_ sender: AnyObject) {
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "キーワードを覚えましたか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.nextstep()
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title:"NO", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        messages?.addAction(defaultAction)
        messages?.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
        
    }
    

    @IBAction func reloadButton(_ sender: AnyObject) {
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "答えを引き直します。\nよろしいですか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.diceReroll()
            self.answerLabel.text = PlayerControll.sharedHQ.Keywords[self.INSnum]
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title:"NO", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        messages?.addAction(defaultAction)
        messages?.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
    }
    
    func nextstep(){
        PlayerControll.sharedHQ.insNUM = self.INSnum
        //スパイモード用
        var msg:String = ""
        if PlayerControll.sharedHQ.spymode == 1{
            diceReroll()
            PlayerControll.sharedHQ.spyNUM = self.INSnum
            msg = "\nまた、正解すると勝利を独占するスパイがいます。\nそれは"+PlayerControll.sharedHQ.PASSCODEs[PlayerControll.sharedHQ.insNUM]+"番の人です。"
        }
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください。", message: "インサイダーは\nパスコード"+PlayerControll.sharedHQ.PASSCODEs[PlayerControll.sharedHQ.insNUM]+"番の人です。"+msg,preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.answerLabel.text = "****"
            self.thirdstep()
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func thirdstep(){
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください。", message: "それではキーワードをみなさんに当ててもらいます。\n私は\n「はい」か「いいえ」か「パス」\nしか話せません。\n制限時間は"+PlayerControll.sharedHQ.keyThinkTime.description+"分です。\n端末をタイマー代わりにします。\nそれではスタートです。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimeKeep")
            self.present(targetViewController!, animated: true, completion: nil)
            
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }

}
