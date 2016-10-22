//
//  PlayerControll.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/18.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//

import UIKit

class PlayerControll: UIResponder, UIApplicationDelegate {
    //プレイヤーの合計人数。ただし出題者の数は含まれない。
    var PlayerNum:Int = 0
    //プレイヤーIDは出題者の右隣のプレイヤーから順に0-1-2-3-...となるようにする
    //プレイヤーIDを配列の番号として答えを入れていく
    var Keywords:[String?] = []
    //プレイヤーIDを配列の番号として名前を入れていく
    var Names:[String?] = []
    ///擬似乱数として100個くらい数列に入れておく
    var defaultNumbers:[String] = ["1023","0403","0130","6410","0666","0156","7312","8567","0008","9246","7447","2316","1267","7118","8689","8829","0345","9999","0612","0119","0874"]
    //realNumbersは擬似乱数を並び替えた配列のうち、上からプレイヤー人数分だけ取って入れておく配列。
    var PASSCODEs:[String] = []
    
    //外部から受け取った数字をプレイヤーナンバーとして保存する。
    func setPlayer(num:Int?){
        PlayerNum = num!
        //出題者の数は入れないので-１する
        PlayerNum -= 1
    }
    //外部から数字を取りたい場合にこのメソッドから取得する
    func getPlayer() -> Int{
        return PlayerNum
    }
    
    //このメソッドにプレイヤー人数を渡すとIDの入った配列を返す
    func pickNum(num:Int?) -> [String?]{
        var count = 0
        //配列を変更するメソッドを呼び出す
        shuffleBang(array: &defaultNumbers)
        while count < PlayerNum {
            PASSCODEs.append(defaultNumbers[count])
            count += 1
        }
        return PASSCODEs
    }
    
    //配列を並び替えるメソッド。元のものにも変更を加える
    func shuffleBang<T>( array: inout [T]) {
        for index in 0..<array.count {
            let newIndex = Int(arc4random_uniform(UInt32(array.count - index))) + index
            if index != newIndex {
                swap(&array[index], &array[newIndex])
            }
        }
    }
    //こちらも配列を並び替えるが、元のものには変更を加えず、新しい配列を返してくれる
    func shuffleArray<S>(source: [S]) -> [S] {
        var copy = source
        shuffleBang(array: &copy)
        return copy
    }

}
