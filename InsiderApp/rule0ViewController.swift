        //
//  rule0ViewController.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/20.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit

class rule0ViewController: UIViewController {
    @IBOutlet weak var imageview: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = #imageLiteral(resourceName: "scene1")
        imageview.image = image1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func BackButton(_ sender: AnyObject) {
       dismiss(animated: true, completion: nil )
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
