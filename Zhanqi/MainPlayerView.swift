//
//  MainPlayerView.swift
//  TestOld
//
//  Created by William Dong on 2022/3/26.
//

import Foundation
import UIKit

class MainPlayerView: UIView{
    var player: Player
    var playerView: PlayerView!
    var handView: UIScrollView!
    var cardViews: [CardView] = []
    init(frame: CGRect, player: Player) { //designated initializer
        self.player = player
        super.init(frame: frame)
        self.backgroundColor=UIColor.white
        let h = frame.height, w = frame.width
        let rect = CGRect(x: 0, y: 0, width: h*0.75, height: h)
        playerView = PlayerView(frame: rect, player: player)
        addSubview(playerView)
        let rect1 = CGRect(x: h*0.75, y: 0, width: w-h*0.75, height: h)
        handView = UIScrollView(frame: rect1)
        handView.backgroundColor = UIColor.gray
        handView.contentSize = CGSize(width: 0, height: h)
        addSubview(handView)
        sendSubviewToBack(handView)
        UpdateHand()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetPlayer(player: Player){
        if player !== self.player{
            self.player = player
            playerView.player = player
            playerView.selectView!.SetEntity(player)
            playerView.Update()
            UpdateHand()
        }
    }
    
    func UpdateHand(){
        let h = bounds.height, w = h * 0.7
        let rect = CGRect(origin: .zero, size: CGSize(width: w, height: h))
        for cv in cardViews{
            cv.removeFromSuperview()
        }
        cardViews = player.hand.cards.map{
            CardView(frame: rect, card: $0)
        }
        for cv in cardViews{
            handView.addSubview(cv)
        }
        RepositionHand()
    }
    
    func RepositionHand(){
        if !cardViews.isEmpty{
            let n = cardViews.count
            let h = cardViews[0].frame.height, w = h * 0.7
            handView.contentSize.width = CGFloat(n)*w
            for i in 0..<n{
                cardViews[i].center = CGPoint(x: (CGFloat(i)+0.5)*w, y: 0.5*h)
                cardViews[i].alpha = 1.0
            }
        }
    }
    
    func EnterInput(){
        if Input.done { return }
        var extraCards: [Card] = []
        if Input.selectableCardAreas.has(player.equip){
            extraCards += player.equip.cards
        }
        if Input.selectableCardAreas.has(player.yield){
            extraCards += player.yield.cards
        }
        let h = bounds.height, w = h * 0.7
        let rect = CGRect(origin: .zero, size: CGSize(width: w, height: h) )
        let cvs = extraCards.map{ CardView(frame: rect, card: $0) }
        cardViews = cvs + cardViews
        for cv in cvs{
            handView.addSubview(cv)
        }
        UIView.animate(withDuration: Game.animTime/2){
            self.RepositionHand()
        }
    }
    
    func ExitInput(){
        let toRemove = cardViews.filter{ $0.card.area.type != .Hand }
        for cv in toRemove{
            cardViews.remove(cv)
            cv.removeFromSuperview()
        }
        UIView.animate(withDuration: Game.animTime/2){
            self.RepositionHand()
        }
    }
}
