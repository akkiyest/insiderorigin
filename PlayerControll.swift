//
//  PlayerControll.swift
//  InsiderApp
//
//  Created by Akihiro Itoh on 2016/10/18.
//  Copyright © 2016年 akihiro.itoh. All rights reserved.
//


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
    //システム上で持っておく、犯人とかの番号
    var insNUM:Int = 999
    var spyNUM:Int = 999
    //探偵が見た人
    var detectiveNUM:Int = 999
    
    //時間　リセット必要
    var keyThinkTime:Int = 0
    var insThinkTime:Int = 0
    
    //モードを保存する　リセット必要 1がON
    var spymode:Int = 0
    var detecmode:Int = 0
    var gisinmode:Int = 0
    var hanseikai:Int = 0
    var didend:Int = 0
    
    //ゲームの進行に必要な番号　すべてリセット必要
    var guilty:Int = 999
    var detecskill:Int = 1
    var detecguilt:Int = 999
    var seikaisha:Int = 999
    let defaults = UserDefaults.standard
    var oldAnswers:[String?] = []
    
    //外部から受け取った数字をプレイヤーナンバーとして保存する。
    func setPlayer(num:Int?){
        PlayerNum = num!
        //出題者の数は入れないので-１する
        if gisinmode == 0{
            PlayerNum -= 1
        } else if gisinmode == 1{
            
            self.Names.append("インサイダーは居ない")
            oldAnswers = Randomize()
            shuffleBang(array: &oldAnswers)
            self.Keywords.append(oldAnswers[0])
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
        insNUM = 999
        spyNUM = 999
        detectiveNUM = 999
        keyThinkTime = 0
        insThinkTime = 0
        
        //モードを保存する　リセット必要 1がON
        spymode = 0
        detecmode = 0
        gisinmode = 0
        hanseikai = 0
        
        
        guilty = 999
        detecskill = 1
        detecguilt = 999
        seikaisha = 999
    }
    
    func Randomize() -> [String?]{
        
        return oldAnswers 
    }
    
    func AddAns(ans:String?){
        oldAnswers.append(ans)
        defaults.set(oldAnswers, forKey: "Ans")
        print(oldAnswers)
    }
    
    static var sharedHQ = PlayerControll()
}
