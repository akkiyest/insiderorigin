//
//  ResultViewController.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/29.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var winnerlabel: UILabel!
    @IBOutlet weak var winnerpict: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if PlayerControll.sharedHQ.guilty == PlayerControll.sharedHQ.insNUM{
            winnerlabel.text = "市民＆出題者"
            if PlayerControll.sharedHQ.detecguilt == 1{
                winnerpict.image = #imageLiteral(resourceName: "detective")
            }else if PlayerControll.sharedHQ.didend == 1{
                winnerpict.image = #imageLiteral(resourceName: "master")
            }else{
                winnerpict.image = #imageLiteral(resourceName: "civilian")
            }
        }else if PlayerControll.sharedHQ.guilty == 666{
            winnerlabel.text = "全員敗北"
            winnerpict.image = #imageLiteral(resourceName: "haiboku")
        }else if PlayerControll.sharedHQ.guilty == 777{
            winnerlabel.text = "スパイ"
            winnerpict.image = #imageLiteral(resourceName: "spy")
        }else{
            winnerlabel.text = "インサイダー"
            winnerpict.image = #imageLiteral(resourceName: "insider")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backto(_ sender: AnyObject) {
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "ホーム画面に戻ります。\nよろしいですか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //広告表示
            
            self.confirm()
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        
        messages!.addAction(defaultAction)
        messages!.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
    }
    
    func confirm(){
        let messages: UIAlertController? = UIAlertController(title:"確認", message: "今回のキーワード\n"+PlayerControll.sharedHQ.Keywords[PlayerControll.sharedHQ.insNUM]!+"/nは良問でしたか？",preferredStyle:UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            let archive = NSKeyedArchiver.archivedData(withRootObject: PlayerControll.sharedHQ.oldAnswers)
            PlayerControll.sharedHQ.defaults.set(archive, forKey: "Ans")
            PlayerControll.sharedHQ.defaults.synchronize()
            //初期化する
            PlayerControll.sharedHQ.destroy()
            let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Setting")
            self.present(targetViewController!, animated: true, completion: nil)
        })
        let defaultAction2: UIAlertAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //初期化する
            PlayerControll.sharedHQ.destroy()
            let targetViewController = self.storyboard?.instantiateViewController(withIdentifier: "Setting")
            self.present(targetViewController!, animated: true, completion: nil)
        })
        
        messages!.addAction(defaultAction)
        messages!.addAction(defaultAction2)
        present(messages!, animated: true, completion: nil)
    }
    
}

