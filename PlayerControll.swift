//
//  PlayerControll.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/18.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//
// Singleton
// http://egg-is-world.com/2016/01/18/swift-2-singleton/

import UIKit

final class PlayerControll: UIResponder, UIApplicationDelegate {
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
    var insNUM:Int = 0
    var spyNUM:Int = 0
    var detectiveNUM:Int = 0
    var keyThinkTime:Int = 0
    var insThinkTime:Int = 0
    var spymode:Int = 0
    var detecmode:Int = 0
    var gisinmode:Int = 0
    
    
    //外部から受け取った数字をプレイヤーナンバーとして保存する。
    func setPlayer(num:Int?){
        PlayerNum = num!
        //出題者の数は入れないので-１する
        if gisinmode == 0{
        PlayerNum -= 1
        } else if gisinmode == 1{
            
        }
    }
    
    //外部から数字を取りたい場合にこのメソッドから取得する
    func getPlayer() -> Int{
        return PlayerNum
    }
    
    //このメソッドにプレイヤー人数を渡すとIDの入った配列を保存する
    func pickNum(){
        var count = 0
        //配列を変更するメソッドを呼び出す
        shuffleBang(array: &defaultNumbers)
        while count < PlayerNum {
            PASSCODEs.append(defaultNumbers[count])
            Names.append("")
            Keywords.append("")
            count += 1
        }
    }
    
    func returnPASS() -> [String?]{
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
    
    private override init() {
        
    }
    
    func destroy(){
        PlayerNum = 0
        PASSCODEs.removeAll()
        Keywords.removeAll()
        Names.removeAll()
        //まだ消せてないものあり
    }
    
    static var sharedHQ = PlayerControll()
}
