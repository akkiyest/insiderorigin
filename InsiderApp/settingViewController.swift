//
//  settingViewController.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/17.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit


class settingViewController: UIViewController {
    @IBOutlet weak var playerNumberTextField: UITextField!
    @IBOutlet weak var KeywordTime: UITextField!
    @IBOutlet weak var InsiderTime: UITextField!
    let numberToolbar: UIToolbar = UIToolbar()

    @IBOutlet weak var advancedswitch: UISwitch!
    @IBOutlet weak var detectiveswitch: UISwitch!
    @IBOutlet weak var noonedoubtsswitch: UISwitch!
    @IBOutlet weak var hanseikaiswitch: UISwitch!
    @IBOutlet weak var spymodeswitch: UISwitch!
    
    
    //アドバンスドモードのところにあるスイッチをオンにすると３つ全部オンになる、オフにしたら全部オフになる
    @IBAction func advancedSwitched(_ sender: AnyObject) {
        if (advancedswitch.isOn){
            detectiveswitch.setOn(true, animated: true)
            noonedoubtsswitch.setOn(true, animated: true)
            hanseikaiswitch.setOn(true, animated: true)
        } else {
            detectiveswitch.setOn(false, animated: true)
            noonedoubtsswitch.setOn(false, animated: true)
            hanseikaiswitch.setOn(false, animated: true)
        }
    }

    //プレイヤー人数のところで確定を押す、フォーカス外すとチェックのファンクションが動く
    @IBAction func checkNumbers(_ sender: AnyObject) {
        let numSt:String? = playerNumberTextField.text
        let num = Int(numSt!)
        if num == nil{
            return
        }else if num! >= 4 && num! <= 10{
        //キーワード推理時間とインサイダー推理時間を人数*分に設定する
        KeywordTime.text = numSt
        InsiderTime.text = numSt
        }else{
            //プレイヤー人数が指定数値外だとエラー出す
            let alert: UIAlertController = UIAlertController(title: "プレイヤー数が不正です", message: "４〜１０を選択してください",preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)

        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //数字入力するパッドに確定ボタンを追加する
        numberToolbar.barStyle = UIBarStyle.blackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "確定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(settingViewController.boopla))
        ]
        
        numberToolbar.sizeToFit()
        
        playerNumberTextField.inputAccessoryView = numberToolbar
        KeywordTime.inputAccessoryView = numberToolbar
        InsiderTime.inputAccessoryView = numberToolbar
        
        //スイッチの初期値設定
        advancedswitch.setOn(false, animated: false)
        detectiveswitch.setOn(false, animated: false)
        noonedoubtsswitch.setOn(false, animated: false)
        hanseikaiswitch.setOn(false, animated: false)
        spymodeswitch.setOn(false, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButton(_ sender: AnyObject) {
        
        //プレイヤー人数とキーワード推理時間とインサイダー推理時間が空欄でないかチェックする
        let sendPLN = Int(playerNumberTextField.text!)
        let sendKEYtime = Int(KeywordTime.text!)
        let sendINStime = Int(InsiderTime.text!)
        
        if sendPLN == nil || sendKEYtime == nil || sendINStime == nil {
            let alert2: UIAlertController = UIAlertController(title: "設定エラー", message: "設定に不正な値が入っています。\n確認してください",preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in print("OK")})
            
            alert2.addAction(defaultAction)
            present(alert2, animated: true, completion: nil)
        }
        
        //確認メッセージを表示するため
        var msg:String = ""
        var msg2:String = ""
        
        if advancedswitch.isOn {
        msg = "アドバンスドモードON\n"
        //探偵モード、ダウトモード、スパイモードのフラグをすべて1にする（未記入）
        } else if advancedswitch.isOn == false && detectiveswitch.isOn || noonedoubtsswitch.isOn || hanseikaiswitch.isOn {
            msg = "個別設定ON\n"
        }

        
        if spymodeswitch.isOn{
            msg2 = "スパイ有り\n"
        }
        
        let startAlert: UIAlertController = UIAlertController(title: "スタート確認", message:playerNumberTextField.text!+"人\n"+msg+msg2+"で開始します。\nよろしいですか？",preferredStyle:UIAlertControllerStyle.actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            //プレイヤー人数（マスター含む）をnumで持つ
            PlayerControll.sharedHQ.setPlayer(num: sendPLN)
            PlayerControll.sharedHQ.pickNum()
            PlayerControll.sharedHQ.keyThinkTime = Int(self.KeywordTime.text!)!
            PlayerControll.sharedHQ.insThinkTime = Int(self.InsiderTime.text!)!
            let test1 = PlayerControll.sharedHQ.returnPASS()
            print(test1)
            let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Input")
            self.present(targetViewController!, animated: true, completion: nil)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in 
            //ここでキャンセルする
            print("CANCELED")
        })
        
        // ③ UIAlertControllerにActionを追加
        startAlert.addAction(cancelAction)
        startAlert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(startAlert, animated: true, completion: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //確定ボタンを押したら起きること
    func boopla () {
        playerNumberTextField.resignFirstResponder()
        KeywordTime.resignFirstResponder()
        InsiderTime.resignFirstResponder()
    }
    
}
