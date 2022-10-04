//
//  CardView.swift
//  TestOld
//
//  Created by William Dong on 2022/3/24.
//

import Foundation
import UIKit

class CardView:UIView {
    var card: Card
    var faceUp: Bool = true
    var alwaysFaceUp: Bool = false
    
    var suitRankLabel: UILabel!
    var nameLabel: UILabel!
    var backLabel: UILabel!
    var selectView: SelectView!
    
    init(frame: CGRect, card: Card) { //designated initializer
        self.card=card
        
        // frame aspect ratio 0.7
        super.init(frame: frame)
        backgroundColor = .clear
        
        //花色和点数显示在左上角
        let s1 = card._suit.symbol
        let s2 = card._rank.rankSymbol
        suitRankLabel = UILabel()
        suitRankLabel.text=s1+s2
        suitRankLabel.font = .systemFont(ofSize: 11)
        suitRankLabel.textColor = card.color == .Red ? .red : .black
        suitRankLabel.sizeToFit()
        suitRankLabel.frame=CGRect(origin: CGPoint(x: 5.0, y: 5.0), size: suitRankLabel.frame.size)
        addSubview(suitRankLabel)
        
        //牌名显示在中间
        nameLabel=UILabel()
        nameLabel.text=card._name
        nameLabel.font = .systemFont(ofSize: 11)
        nameLabel.textColor=UIColor.black
        nameLabel.sizeToFit()
        nameLabel.center=CGPoint(x: bounds.width/2, y: bounds.height/2)
        addSubview(nameLabel)
        
        //最好换张卡牌背面图片
        backLabel=UILabel()
        backLabel.text="Swift杀"
        backLabel.font = .systemFont(ofSize: 13)
        backLabel.sizeToFit()
        backLabel.textColor=UIColor.gray
        backLabel.center=CGPoint(x: bounds.width/2, y: bounds.height/2)
        addSubview(backLabel)
        
        selectView = SelectView(frame: bounds)
        selectView.SetEntity(card)
        addSubview(selectView)
        
        Update()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let re=CGRect(x: 2, y: 2, width: rect.width-4, height: rect.height-4)
        let path=UIBezierPath(roundedRect: re, cornerRadius: 8)
        path.lineWidth=4
        UIColor.black.setStroke()
        path.stroke()
        UIColor.white.setFill()
        path.fill()
    }
    func Update(){
        faceUp = alwaysFaceUp || card.visibleTo.has(Game.current.gameView.mainPlayerView.player)
        suitRankLabel.isHidden = !faceUp
        nameLabel.isHidden = !faceUp
        backLabel.isHidden = faceUp
    }
}
