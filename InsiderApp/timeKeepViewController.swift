//
//  timeKeepViewController.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/23.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit

class timeKeepViewController: UIViewController {
    var keyorans = 0
    var time:Int = 0
    var timer:Timer!
    var timerflag = 1
    var phaseflag = 0
    
    @IBOutlet weak var stpbtntext: UIButton!
    
    @IBOutlet weak var objectTitle: UILabel!
    
    @IBOutlet weak var timerTEXT: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        time = PlayerControll.sharedHQ.keyThinkTime * 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        objectTitle.text = "キーワードを当てろ"
    }
    
    
    func update(timer: Timer){
        time -= 1

        if (time%60) < 10{
            timerTEXT.text = String(time/60)+":0"+String(time%60)
        } else {
            timerTEXT.text = String(time/60)+":"+String(time%60)
        }
        
        if time == 0 {
            //killtimer
            timer.invalidate()
        }
    }
    
    @IBAction func stoptimer(_ sender: AnyObject) {
        if timerflag == 1{
            timer.invalidate()
            self.timerflag = 0
            stpbtntext.setTitle("再開", for: UIControlState.normal)
        }else if timerflag == 0{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            timer.fire()
            self.timerflag = 1
            stpbtntext.setTitle("一時停止", for: UIControlState.normal)
        }
        
    }
    
    @IBAction func Finished(_ sender: AnyObject) {
        timer.invalidate()
        if phaseflag == 0 {
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "答えが出ましたか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.chkAnswer()
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title:"NO", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            self.timer.fire()
        })
        messages?.addAction(defaultAction)
        messages?.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
        }else if phaseflag == 1 {
            let messages: UIAlertController? = UIAlertController(title:"確認", message: "議論が終わりましたか？",preferredStyle:UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                //一覧に飛ぶ
                
            })
            let defaultAction2: UIAlertAction = UIAlertAction(title:"NO", style: UIAlertActionStyle.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                self.timer.fire()
            })
            messages?.addAction(defaultAction)
            messages?.addAction(defaultAction2)
            present(messages!, animated: true, completion: nil)
        }
    }
    
    func chkAnswer(){
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください。", message: "おめでとうございます。\n正解は\n\""+PlayerControll.sharedHQ.Keywords[PlayerControll.sharedHQ.insNUM]!+"\"\nでした。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.deteccheck()
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
        
    }
    
    func deteccheck(){
        if PlayerControll.sharedHQ.detecmode == 1{
            let messages: UIAlertController? = UIAlertController(title:"正解者を確認します。", message: "正解したプレイヤーは、一人だけ正体を確認することができます。/n端末を正解者に渡してください。",preferredStyle:UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                //
                self.phaseflag = 1
            })
            messages?.addAction(defaultAction)
            present(messages!, animated: true, completion: nil)
        } else if PlayerControll.sharedHQ.detecmode == 0 {
            self.prepareInstime0()
            self.phaseflag = 1
        }
        
    }
    
    func prepareInstime0() {
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください", message: "それでは、インサイダー推理フェーズに入ります。\nこの中に黒幕、インサイダーがいます。\n出題者含め自由に会話して、\n誰かがインサイダーかを推理してください。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.prepareInstime1()
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func prepareInstime1() {
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください", message: "制限時間は"+String(PlayerControll.sharedHQ.insThinkTime)+"分です。\nそれでは開始します。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.startIns()
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func startIns(){
        time = PlayerControll.sharedHQ.insThinkTime * 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
        objectTitle.text = "インサイダーを推理しろ"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
