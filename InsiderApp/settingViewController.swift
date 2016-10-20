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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //確定ボタンを押したら起きること　間違い有るかも
    func boopla () {
        playerNumberTextField.resignFirstResponder()
        KeywordTime.resignFirstResponder()
        InsiderTime.resignFirstResponder()
    }
    
}
