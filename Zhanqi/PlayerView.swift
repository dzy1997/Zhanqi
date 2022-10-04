//
//  PlayerView.swift
//  TestOld
//
//  Created by William Dong on 2022/3/24.
//

import Foundation
import UIKit

class PlayerView: UIView{
    var player: Player
    var selected: Bool = false
    var topLabel: UILabel!
    var handLabel: UILabel!
    var yieldLabel: UILabel!
    var equipLabels: [UILabel] = []
    var selectView: SelectView!
    init(frame: CGRect, player: Player) { //designated initializer
        self.player = player
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        let img = UIImage(named: "liubei")
        let imgView = UIImageView(image: img)
        imgView.frame = bounds
        imgView.contentMode = .scaleToFill
        addSubview(imgView)
        // top label
        topLabel = UILabel.create()
        topLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.2)
        topLabel.text = "武将名 4/4"
        topLabel.backgroundColor = (player.team==0 ? UIColor.red : UIColor.blue).withAlphaComponent(0.5)
        addSubview(topLabel)
        handLabel = UILabel.create()
        handLabel.frame = CGRect(x: 0, y: bounds.height * 0.25, width: bounds.width*0.2, height: bounds.height*0.15)
        handLabel.text = "4"
        handLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(handLabel)
        yieldLabel = UILabel.create()
        yieldLabel.frame = CGRect(x: bounds.width*0.8, y: bounds.height * 0.25, width: bounds.width*0.2, height: bounds.height*0.15)
        yieldLabel.text = "乐"
        yieldLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(yieldLabel)
        let k: CGFloat = 0.15
        for i in 1...4{
            let y = bounds.maxY - CGFloat(i) * k * bounds.height
            let label = UILabel.create()
            label.frame = CGRect(x: bounds.origin.x, y: y, width: bounds.width, height: bounds.height * k)
            label.text = "♠2 八卦阵"
            label.textAlignment = .natural
            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            equipLabels.append(label)
            addSubview(label)
        }
        selectView = SelectView(frame: bounds)
        selectView.SetEntity(player)
        addSubview(selectView)
        Update()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func Update(){
        let hpText = player.alive ? "\(player.hp)/\(player.maxHp)" : "阵亡"
        let flag = Game.current.flagOwners[player.team] === player ? "⚑" : ""
        topLabel.text = "\(flag)\(player.hero.name) \(hpText)"
        topLabel.backgroundColor = (player.team == 0 ? UIColor.red : UIColor.blue).withAlphaComponent(0.5)
        handLabel.text = "\(player.hand.cards.count)"
        yieldLabel.alpha = player.yield.cards.isEmpty ? 0.0 : 1.0
        let cards = player.equip.cards
        let n = cards.count
        for i in 0..<4{
            let label = equipLabels[i]
            if i < n{
                label.alpha = 1.0
                label.text = cards[i].toStr()
            }else{
                label.alpha = 0.0
            }
        }
    }
}
