//
//  timeKeepViewController.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/23.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit

class timeKeepViewController: UIViewController {
    var time:Int = 0
    var timer:Timer!
    var timerflag = 1
    var phaseflag = 0
    @IBOutlet weak var imagevieq: UIImageView!
    
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
        
        if PlayerControll.sharedHQ.detecskill == 1{
            time = PlayerControll.sharedHQ.keyThinkTime * 60
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            timer.fire()
            objectTitle.text = "キーワードを当てろ"
            imagevieq.image = #imageLiteral(resourceName: "scene1")
        } else {
            time = PlayerControll.sharedHQ.insThinkTime * 60
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            timer.fire()
            objectTitle.text = "インサイダーを当てろ"
            imagevieq.image = #imageLiteral(resourceName: "insider")
            self.phaseflag = 1
        }
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
            if phaseflag == 0{
                //答えが出なかった場合の終了
                if PlayerControll.sharedHQ.hanseikai == 0 {
                    //敗北
                    PlayerControll.sharedHQ.guilty = 666
                    let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result")
                    self.present(targetViewController!, animated: true, completion: nil)
                } else if PlayerControll.sharedHQ.hanseikai == 1{
                    let messages: UIAlertController? = UIAlertController(title:"読み上げてください。", message: "残念ながら、皆さんの努力も虚しく、\n不正解でした。\n正解は\n\""+PlayerControll.sharedHQ.Keywords[PlayerControll.sharedHQ.insNUM]!+"\"\nでした。\nこれから反省会を行います。\n全員反省の弁を述べてください。",preferredStyle:UIAlertControllerStyle.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        self.hanseikai()
                    })
                    messages?.addAction(defaultAction)
                    present(messages!, animated: true, completion: nil)
                    phaseflag = 1
                }
                
            }else if phaseflag == 1{
                //インサイダー推理時間が終了したことを告げて次の画面に行く
                let messages: UIAlertController? = UIAlertController(title:"制限時間", message: "インサイダーが誰かの議論を\n終えてください。",preferredStyle:UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "List")
                    self.present(targetViewController!, animated: true, completion: nil)
                })
                messages?.addAction(defaultAction)
                present(messages!, animated: true, completion: nil)
                
            }
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
            let messages: UIAlertController? = UIAlertController(title:"確認", message: "インサイダーが誰かの議論が\n終わりましたか？",preferredStyle:UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "List")
                self.present(targetViewController!, animated: true, completion: nil)
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
            let messages: UIAlertController? = UIAlertController(title:"正解者を確認します。", message: "正解したプレイヤーは、一人だけ正体を確認することができます。\n端末を正解者に渡してください。\n正解したプレイヤーは見えないように持ってください。",preferredStyle:UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "List")
                self.present(targetViewController!, animated: true, completion: nil)
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
        imagevieq.image = #imageLiteral(resourceName: "insider")
    }
    
    func hanseikai(){
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください。", message: "最後は出題者の独断で決めます。\n全員、自らがインサイダーでないことをアピールしてください。\n正解すれば逆転勝利します。\n不正解であれば引き分けです。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            PlayerControll.sharedHQ.didend = 1
            self.startIns()
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
        
    }
    
    
}
