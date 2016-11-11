//
//  playerListViewController.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/25.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit

class playerListViewController: UIViewController {
    @IBOutlet var Buttontext: [UIButton]!
    //選び終わったら初期化必要
    var selected:Int = 999
    var TNT:Int = 0
    var TNTselectedGuilt:Int = 999
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var count0 = 0
        while count0 < 10 {
            Buttontext[count0].setTitle("", for: .normal)
            count0 += 1
        }
        //一人一人名前をつける
        self.named()
        
        if PlayerControll.sharedHQ.detecskill == 1{
            self.image.image = #imageLiteral(resourceName: "players")
            let messages: UIAlertController? = UIAlertController(title:"実行してください。", message: "この一覧の中の正解者のIDを選択してください。",preferredStyle:UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
            })
            messages?.addAction(defaultAction)
            present(messages!, animated: true, completion: nil)
        } else if PlayerControll.sharedHQ.detecskill == 0{
            self.image.image = #imageLiteral(resourceName: "players")
            self.kyoshutouhyou()
        }
    }
    
    @IBAction func touched(_ sender: AnyObject) {
        self.named()
        selected = sender.tag!
        Buttontext[selected].setTitle("->"+PlayerControll.sharedHQ.Names[selected]!, for: .normal)
    }
    
    func named(){
        var count = 0
        while count < PlayerControll.sharedHQ.PlayerNum {
            Buttontext[count].setTitle(PlayerControll.sharedHQ.Names[count], for: .normal)
            Buttontext[count].tag = count
            count += 1
        }
        
        
    }
    
    @IBAction func selectedIns(_ sender: AnyObject) {
        if PlayerControll.sharedHQ.seikaisha == 999{
            //正解者を選ばせる
            self.seikaisha()
        }else if self.TNT == 1{
            self.TNTcheck()
        }else if TNT == 0 {
            let messages: UIAlertController? = UIAlertController(title:"読み上げてください", message: "多数決の結果、\nインサイダー容疑者は\nID:"+PlayerControll.sharedHQ.Names[self.selected]!+"さんでよろしいですか？",preferredStyle:UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                PlayerControll.sharedHQ.guilty = self.selected
                self.destroy()
                let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result")
                self.present(targetViewController!, animated: true, completion: nil)
            })
            let defaultAction2: UIAlertAction = UIAlertAction(title:"NO", style: UIAlertActionStyle.cancel, handler:{
                (action: UIAlertAction!) -> Void in
            })
            
            messages?.addAction(defaultAction)
            messages?.addAction(defaultAction2)
            present(messages!, animated: true, completion: nil)
        }
    }
    
    func seikaisha(){
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください", message: "正解者は\nID:"+PlayerControll.sharedHQ.Names[self.selected]!+"さんでよろしいですか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.named()
            PlayerControll.sharedHQ.seikaisha = self.selected
            //画面を移転する
            self.selected = 999
            if PlayerControll.sharedHQ.spymode == 1 && PlayerControll.sharedHQ.spyNUM == PlayerControll.sharedHQ.seikaisha{
                PlayerControll.sharedHQ.guilty = 777
                let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result")
                self.present(targetViewController!, animated: true, completion: nil)
            }else if PlayerControll.sharedHQ.detecmode == 1 {
                //探偵モードをONにする
                self.named()
                self.image.image = #imageLiteral(resourceName: "detective")
                self.TNT = PlayerControll.sharedHQ.detecskill
                self.TNTmode()
            } else {
                self.named()
                self.kyoshutouhyou()
            }
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title:"NO", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        messages?.addAction(defaultAction)
        messages?.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
    }
    
    func TNTmode(){
        let messages: UIAlertController? = UIAlertController(title:"正解者に端末を渡してください", message: "正解者は一人だけ正体を確認することができます。\nその内容を話しても構いません。\nゲームを左右するので、注意深く選んでください。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //ラベルを変更する、名前を読み込む
            
        })
        messages!.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func kyoshutouhyou(){
        image.image = #imageLiteral(resourceName: "scene5")
        let messages: UIAlertController? = UIAlertController(title:"読み上げ、挙手投票を行ってください", message: "挙手投票を行います。\n挙手投票の結果、50%以上手を上げたら有罪です。\n正解者がインサイダーだと思う人は手を上げてください。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //画面を移転する
            self.kyoshutouhyou2()
        })
        messages!.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func kyoshutouhyou2(){
        let messages: UIAlertController? = UIAlertController(title:"【重要】", message: "多数決は可決されましたか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //結果に画面遷移
            PlayerControll.sharedHQ.guilty = PlayerControll.sharedHQ.seikaisha
            self.destroy()
            let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result")
            self.present(targetViewController!, animated: true, completion: nil)
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            if PlayerControll.sharedHQ.insNUM == PlayerControll.sharedHQ.seikaisha{
                //結果に画面遷移
                PlayerControll.sharedHQ.guilty = 999
                self.destroy()
                let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result")
                self.present(targetViewController!, animated: true, completion: nil)
            }else if PlayerControll.sharedHQ.insNUM != PlayerControll.sharedHQ.seikaisha{
                //もう一度選べる
                self.selectAnother()
            }
            
        })
        
        messages!.addAction(defaultAction)
        messages!.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
        
    }
    
    func selectAnother(){
        image.image = #imageLiteral(resourceName: "scene6")
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください。", message: "正解者、"+PlayerControll.sharedHQ.Names[PlayerControll.sharedHQ.seikaisha]!+"はインサイダーではありませんでした。\n指差し投票を行います。\n引き分けになった場合、無条件で正解者の指定した人が有罪になります。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        messages!.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func TNTcheck(){
        //よろしいですか？
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "正解者のあなたが選んだプレイヤーは\nID:"+PlayerControll.sharedHQ.Names[self.selected]!+"\nでよろしいですか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.TNTcheck2()
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
        })
        messages!.addAction(defaultAction)
        messages!.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
    }
    
    func TNTcheck2(){
        TNT = 0
        if PlayerControll.sharedHQ.insNUM == self.selected{
            if PlayerControll.sharedHQ.gisinmode == 1 && self.selected == 0{
                let messages: UIAlertController? = UIAlertController(title:"正解", message: "あなたの選択は正しく、\nインサイダーはいませんでした。\nこれは次のインサイダー推理の時間に話しても問題ありません。\nOKを押してから、端末を出題者に返してください。",preferredStyle:UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    PlayerControll.sharedHQ.detecguilt = 1
                    self.TNTcheck3()
                })
                messages!.addAction(defaultAction)
                present(messages!, animated: true, completion: nil)
            }else{
                let messages: UIAlertController? = UIAlertController(title:"正解", message: "あなたの推理は正しく、\n"+PlayerControll.sharedHQ.Names[self.selected]!+"\nはインサイダーでした。\nこれは次のインサイダー推理の時間に話しても問題ありません。\nOKを押してから、この結果を見られないように端末を出題者に返してください。",preferredStyle:UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    PlayerControll.sharedHQ.detecguilt = 1
                    self.TNTcheck3()
                })
                messages!.addAction(defaultAction)
                present(messages!, animated: true, completion: nil)
            }
        }else{
            if PlayerControll.sharedHQ.gisinmode == 1 && self.selected == 0 {
                let messages: UIAlertController? = UIAlertController(title:"不正解", message: "どうやらインサイダーは潜んでいるようです。\nこれは次のインサイダー推理の時間に話しても問題ありませんし、\nたとえあなたがインサイダーであったなら嘘をついてもかまいません。\nOKを押してから、この結果を見られないように端末を出題者に返してください。",preferredStyle:UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    self.TNTcheck3()
                })
                messages!.addAction(defaultAction)
                present(messages!, animated: true, completion: nil)
                
            } else {
                let messages: UIAlertController? = UIAlertController(title:"不正解", message: "正解者のあなたが選んだプレイヤー\n"+PlayerControll.sharedHQ.Names[self.selected]!+"\nはインサイダーではありませんでした。\nこれは次のインサイダー推理の時間に話しても問題ありませんし、\nたとえあなたがインサイダーであったなら嘘をついてもかまいません。\nOKを押してから、端末を出題者に返してください。",preferredStyle:UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    self.TNTcheck3()
                })
                messages!.addAction(defaultAction)
                present(messages!, animated: true, completion: nil)
            }
        }
        
    }
    
    func TNTcheck3(){
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください", message: "それでは、インサイダー推理フェーズに入ります。\nこの中に黒幕、インサイダーがいます。\n出題者含め自由に会話して、\n誰かがインサイダーかを推理してください。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.TNTcheck4()
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func TNTcheck4(){
        PlayerControll.sharedHQ.detecskill = 0
        let messages: UIAlertController? = UIAlertController(title:"読み上げてください", message: "制限時間は"+String(PlayerControll.sharedHQ.insThinkTime)+"分です。\nそれでは開始します。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimeKeep")
            self.present(targetViewController!, animated: true, completion: nil)
            
        })
        messages?.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func TNTerror(){
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "正体を明かしたい人を選んでください。",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //画面を移転する
            
        })
        messages!.addAction(defaultAction)
        present(messages!, animated: true, completion: nil)
    }
    
    func destroy(){
        selected = 999
        TNT = 0
        TNTselectedGuilt = 999
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
