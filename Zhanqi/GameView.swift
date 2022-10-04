//
//  GameView.swift
//  TestOld
//
//  Created by William Dong on 2022/3/26.
//

import Foundation
import UIKit

class GameView: UIView{
    var game: Game
    var playerViews: [PlayerView] = []
    var mapView: MapView!
    var promptLabel: UILabel!
    var buttonBar: UIToolbar!
    var okButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var choiceButtons: [UIBarButtonItem] = []
    var mainPlayerView: MainPlayerView!
    var cardDialogView: CardDialogView!
    var logTextView: UITextView!
    var infoTextView: UITextView!
    var logButton: UIButton!
    var infoButton: UIButton!
    var cardViews: [CardView] = []
    var tableCardsView: UIView!
    
    init(frame: CGRect, game: Game){
        self.game = game
        super.init(frame: frame)
        // layout subviews
        let w = bounds.width, h = bounds.height
        let h1 = w / 6 / 0.75
        for i in 0..<6{
            let rect = CGRect(x: CGFloat(i)*w/6, y: 0, width: w/6, height: h1)
            let playerView = PlayerView(frame: rect, player: game.players[i])
            playerViews.append(playerView)
            addSubview(playerView)
        }
        
        
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.systemBackground
        } else {
            backgroundColor = UIColor.white
        }
        promptLabel = UILabel.create()
        if #available(iOS 13.0, *) {
            promptLabel.textColor = UIColor.label
        } else {
            promptLabel.textColor = UIColor.black
        }
        promptLabel.bounds = CGRect(x: 0, y: 0, width: w, height: h * 0.1)
        promptLabel.text = Input.prompt
        promptLabel.numberOfLines = 3
        
        buttonBar = UIToolbar()
        okButton = makeButton(title: "确定")
        cancelButton = makeButton(title: "取消")
        buttonBar.bounds = CGRect(x: 0, y: 0, width: w, height: 50)
        buttonBar.sizeToFit()
        let h2 = buttonBar.bounds.height
        
        buttonBar.center = CGPoint(x: w/2, y: h-h1-h2/2)
        promptLabel.center = CGPoint(x: w/2, y: h-h1-h2-h*0.1/2)
        addSubview(buttonBar)
        addSubview(promptLabel)
        UpdatePromptButtonBar()
        
        let mapRect = CGRect(x: 0, y: h1, width: w, height: h-h1*2-h2-h*0.1)
        mapView = MapView(frame: mapRect, map: game.map)
        addSubview(mapView)
        
        let rect1 = CGRect(x: 0, y: h-h1, width: w, height: h1)
        mainPlayerView = MainPlayerView(frame: rect1, player: game.currentTurnPlayer)
        addSubview(mainPlayerView)
        
        // Add tableCardsView
        let tableCardsRect = CGRect(x: 0, y: 0, width:0, height: h1)
        tableCardsView = UIView(frame: tableCardsRect)
        tableCardsView.center = mapView.center
        addSubview(tableCardsView)
        
        let hDialog = h1/0.6
        let dialogRect = CGRect(x: 0.1 * w, y: promptLabel.frame.minY-hDialog, width: 0.8*w, height: hDialog)
        cardDialogView = CardDialogView(frame: dialogRect, game: game)
        addSubview(cardDialogView)
        
        let hInfo: CGFloat = 150.0
        let infoRect = CGRect(x: 0.05*w, y: mapRect.minY+20, width: 0.9*w, height: hInfo)
        infoTextView = UITextView(frame: infoRect)
        infoTextView.text = "Info text here..."
        infoTextView.textColor = .black
        infoTextView.isEditable = false
        infoTextView.backgroundColor = .white.withAlphaComponent(0.7)
        infoTextView.isHidden = true
        addSubview(infoTextView)
        
        let textRect = CGRect(x: 0.05*w, y: mapRect.minY+20+hInfo+5, width: 0.9*w, height: mapRect.height-20-hInfo-5)
        logTextView = UITextView(frame: textRect)
        logTextView.text = ""
        logTextView.textColor = .black
        logTextView.isEditable = false
        logTextView.backgroundColor = .white.withAlphaComponent(0.7)
        logTextView.isHidden = true
        addSubview(logTextView)
        
        logButton = UIButton(type: UIButton.ButtonType.system)
        logButton.setTitle("游戏记录", for: .normal)
        logButton.addTarget(self, action: #selector(GameView.toggleTextView), for: .touchUpInside)
        logButton.sizeToFit()
        logButton.center = CGPoint(x: w/2, y: mapRect.minY+10)
        addSubview(logButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func toggleTextView(sender: UIButton){
        if sender.title(for: .normal) == "更新信息"{
            infoTextView.text = game.fullInfo()
            return
        }
        logTextView.isHidden.toggle()
        infoTextView.isHidden.toggle()
        let title = logTextView.isHidden ? "游戏记录" : "隐藏"
        logButton.setTitle(title, for: .normal)
    }
    @objc func buttonPress(sender: UIBarButtonItem){
        if sender === okButton{
            if Input.CanConfirm(){
                Input.Confirm()
            }
        }
        if sender === cancelButton{
            Input.Cancel()
        }
        for i in 0..<choiceButtons.count{
            if sender === choiceButtons[i]{
                Input.SelectChoice(i)
                if Input.choiceNumRange.1 == 1{
                    Input.Confirm()
                }
            }
        }
    }
    func makeButton(title: String) -> UIBarButtonItem{
        return UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(buttonPress(sender:)))
    }
    func EnterInput(){
        mainPlayerView.SetPlayer(player: Input.player!)
        mainPlayerView.EnterInput()
        self.cardDialogView.Update()
        self.UpdateSelectViews()
        infoTextView.text = game.fullInfo()
        if Input.gridNumRange != (0,0){
            UIView.animate(withDuration: Game.animTime, animations: {
                self.tableCardsView.alpha = 0.0
            },completion: { _ in
                self.tableCardsView.isHidden = true
            })
        }
    }
    func ExitInput(){
        mainPlayerView.ExitInput()
        self.cardDialogView.Update()
        self.UpdateSelectViews()
        if Input.gridNumRange != (0,0){
            UIView.animate(withDuration: Game.animTime, animations: {
                self.tableCardsView.isHidden = false
                self.tableCardsView.alpha = 1.0
            })
        }
    }
    func UpdatePromptButtonBar(){
        promptLabel.text = Input.done ? "" : Input.prompt
        choiceButtons = []
        if !Input.done{
            for i in 0..<Input.choices.count{
                let button = makeButton(title: Input.choices[i])
                button.isEnabled = Input.choiceFilter(i)
                choiceButtons.append(button)
            }
            okButton.isEnabled = Input.CanConfirm()
            cancelButton.isEnabled = true
        }else{
            okButton.isEnabled = false
            cancelButton.isEnabled = false
        }
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var buttons:[UIBarButtonItem] = [flexSpace, okButton, cancelButton, flexSpace]
        if !choiceButtons.isEmpty{
            buttons = [flexSpace] + choiceButtons + buttons
        }
        buttonBar.setItems(buttons, animated: true)
    }
    func UpdateSelectViews(){
        let cards = Input.validCards
        var selectViews = mainPlayerView.cardViews.map{ $0.selectView! } + cardDialogView.cardViews.map{ $0.selectView! }
        for sv in selectViews{
            let card = sv.entity as! Card
            var state:SelectView.State = .Idle
            if !Input.done && Input.cardNumRange != (0,0){
                if Input.selectedCards.has(card) {
                    state = .Selected
                }else{
                    state = cards.has(card) ? .Selectable : .Unselectable
                }
            }
            sv.SetState(state)
        }
        let players = Input.validPlayers
        selectViews = playerViews.map{ $0.selectView! } + mapView.chessViews.map{ $0.selectView! } + [mainPlayerView.playerView.selectView!]
        for sv in selectViews{
            let player = sv.entity as! Player
            var state:SelectView.State = .Idle
            if !Input.done && Input.playerNumRange != (0,0){
                if Input.selectedPlayers.has(player) {
                    state = .Selected
                }else{
                    state = players.has(player) ? .Selectable : .Unselectable
                }
            }
            sv.SetState(state)
        }
        let grids = Input.validGrids
        selectViews = mapView.gridViews.map{ $0.selectView! }
        for sv in selectViews{
            let grid = sv.entity as! Grid
            var state:SelectView.State = .Idle
            if !Input.done && Input.gridNumRange != (0,0){
                if Input.selectedGrids.has(grid) {
                    state = .Selected
                }else{
                    state = grids.has(grid) ? .Selectable : .Unselectable
                }
            }
            sv.SetState(state)
        }
        UpdatePromptButtonBar()
    }
    
    func AnimateCardMove(cardmove: CardMove){
        var cvs: [CardView] = []
        let h = mainPlayerView.playerView.frame.height, w = h * 0.7
        let cardRect = CGRect(origin: .zero, size: CGSize(width: w, height: h))
        let mainPlayer = mainPlayerView.player
        // collect or create cardviews
        for i in 0..<cardmove.cards.count{
            let card = cardmove.cards[i]
            let orig = cardmove.origs[i]
            var cv: CardView! = nil
            if let player = orig.owner{
                if player === mainPlayer{
                    if let cv1 = mainPlayerView.cardViews.first(where: { $0.card === card }){
                        cv = cv1
                        mainPlayerView.cardViews.remove(cv)
                    }else{
                        cv = CardView(frame: cardRect, card: card)
                        cv.alpha = 0.0
                        mainPlayerView.playerView.addCenterSubview(cv)
                    }
                }else{
                    cv = CardView(frame: cardRect, card: card)
                    cv.alpha = 0.0
                    playerViews[player.id].addCenterSubview(cv)
                }
            }else{ // card has no owner
                if let cv1 = cardViews.first(where: { $0.card === card }){
                    cv = cv1
                    cardViews.remove(cv)
                }else{
                    cv = CardView(frame: cardRect, card: card)
                    cv.alpha = 0.0
                    mapView.addCenterSubview(cv)
                }
            }
            cvs.append(cv)
        }
        if let player = cardmove.dest.owner{
            // has owner, move to hand or playerview
            cvs.forEach{ $0.changeSuperview(to: self) }
            var pv: PlayerView? = nil
            if player === mainPlayer{
                if cardmove.dest.type == .Hand{
                    cvs.forEach{ cv in
                        mainPlayerView.cardViews.append(cv)
                        cv.changeSuperview(to: mainPlayerView.handView)
                    }
                }else{
                    pv = mainPlayerView.playerView
                }
            }else{
                pv = playerViews[player.id]
            }
            if let pv = pv{
                UIView.animateKeyframes(withDuration: Game.animTime*2, delay: 0.0, animations:{
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5){
                        for cv in cvs {
                            cv.center = pv.convert(pv.boundCenter, to: self)
                            cv.alpha = 1.0
                        }
                    }
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1.0){
                        for cv in cvs {
                            cv.alpha = 0.0
                        }
                    }
                }, completion: { _ in
                    cvs.forEach{ $0.removeFromSuperview() }
                })
            }
        }else{
            // move to deck, discard or handle
            cvs.forEach{ cv in
                if cv.superview !== tableCardsView{
                    cardViews.append(cv)
                }
            }
            UpdateTableCardsView()
        }
        UIView.animate(withDuration: Game.animTime){
            self.mainPlayerView.playerView.Update()
            self.playerViews.forEach{ $0.Update() }
        }
        mainPlayerView.handView.clipsToBounds = false
        if cardmove.dest === mainPlayer.hand{
            self.bringSubviewToFront(self.mainPlayerView)
        }
        UIView.animate(withDuration: Game.animTime, animations: {
            self.mainPlayerView.RepositionHand()
        }, completion: { _ in
            self.mainPlayerView.handView.clipsToBounds = true
        })
    }
    
    func UpdateTableCardsView(){
        let toAdd = cardViews.filter{ $0.superview !== tableCardsView }
        let tempAdd = toAdd.filter{ $0.card.area.type != .Handle }
        let toRemove = tableCardsView.subviews.filter{ !cardViews.has($0 as! CardView) }
        toAdd.forEach{ $0.changeSuperview(to: tableCardsView) }
        toRemove.forEach{ $0.changeSuperview(to: self) }
        if !toAdd.isEmpty{
            self.bringSubviewToFront(self.tableCardsView)
        }
        UIView.animate(withDuration: Game.animTime, animations: {
            self.RepositionTableCards()
            toRemove.forEach{ $0.alpha = 0 }
        }, completion: { _ in
            toRemove.forEach{ $0.removeFromSuperview() }
            tempAdd.forEach{ cv in
                self.cardViews.remove(cv)
                cv.changeSuperview(to: self)
            }
            UIView.animate(withDuration: Game.animTime, animations: {
                self.RepositionTableCards()
                tempAdd.forEach{ $0.alpha = 0.0 }
            }, completion: { _ in
                tempAdd.forEach{ $0.removeFromSuperview() }
            })
        })
    }
    
    func AnimateShowCards(player: Player, cards: [Card]){
        let h = tableCardsView.frame.height, w = h * 0.7
        let rect = CGRect(origin: .zero, size: CGSize(width: w, height: h))
        let cvs = cards.map{ CardView(frame: rect, card: $0) }
        let pv = player === mainPlayerView.player ? mainPlayerView.playerView! : playerViews[player.id]
        cvs.forEach{ cv in
            cv.alwaysFaceUp = true
            cv.Update()
            pv.addCenterSubview(cv)
        }
        cardViews += cvs
        UpdateTableCardsView()
    }
    
    func AnimateHPChange(player: Player){
        let pv = playerViews[player.id]
        UIView.animateKeyframes(withDuration: Game.animTime, delay: 0.0, animations:{
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5){
                pv.topLabel.alpha = 0.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5){
                pv.topLabel.alpha = 1.0
            }
        }, completion: {_ in
            pv.Update()
        })
        let mpv = mainPlayerView.playerView!
        if mpv.player === player{
            UIView.animateKeyframes(withDuration: Game.animTime, delay: 0.0, animations:{
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5){
                    mpv.topLabel.alpha = 0.0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5){
                    mpv.topLabel.alpha = 1.0
                }
            }, completion: {_ in
                mpv.Update()
            })
        }
    }
    
    func RepositionTableCards(){
        let h = tableCardsView.frame.height, w = h * 0.7
        let n = cardViews.count
        let center = tableCardsView.center
        tableCardsView.frame.size.width = CGFloat(n)*w
        tableCardsView.center = center
        for i in 0..<n{
            cardViews[i].center = CGPoint(x: (CGFloat(i)+0.5)*w, y: 0.5*h)
            cardViews[i].alpha = 1.0
        }
    }
}

class CardDialogView: UIView{
    var game: Game
    var topLabel: UILabel!
    var scrollView: UIScrollView!
    var cardViews: [CardView] = []
    var hideButton: UIButton!
    var cardShown: Bool = true
    init(frame: CGRect, game: Game){
        self.game = game
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.7)
        let w = frame.width, h = frame.height
        topLabel = UILabel.create()
        topLabel.text = "请选择牌"
        topLabel.bounds = CGRect(origin: .zero, size: CGSize(width: w, height: h*0.2))
        topLabel.center = CGPoint(x: w/2, y: h*0.1)
        addSubview(topLabel)
        scrollView = UIScrollView(frame: CGRect(x: 0, y: h*0.2, width: w, height: h*0.6))
        scrollView.contentSize = CGSize(width: 0, height: h*0.6)
        addSubview(scrollView)
        hideButton = UIButton(type: UIButton.ButtonType.system)
        hideButton.setTitle("隐藏", for: .normal)
        hideButton.addTarget(self, action: #selector(CardDialogView.Toggle), for: .touchUpInside)
        hideButton.sizeToFit()
        hideButton.center = CGPoint(x: w/2, y: h*0.9)
        addSubview(hideButton)
        self.alpha = 0.0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func Toggle(){
        cardShown.toggle()
        let title = cardShown ? "隐藏" : "显示"
        hideButton.setTitle(title, for: .normal)
        UIView.animate(withDuration: Game.animTime){
            self.scrollView.alpha = self.cardShown ? 1.0 : 0.0
            self.topLabel.alpha = self.cardShown ? 1.0 : 0.0
            self.backgroundColor = self.cardShown ? .black.withAlphaComponent(0.7) : .clear
        }
    }
    func Update(){
        var cards: [Card] = []
        var show = false
        if !Input.done{
            cards = Input.selectableCards
            for area in Input.selectableCardAreas{
                if area.owner !== Input.player{
                    cards += area.cards
                }
            }
            show = !cards.isEmpty
        }
        let newAlpha = show ? 1.0 : 0.0
        if self.alpha != newAlpha{
            UIView.animate(withDuration: Game.animTime){
                self.alpha = newAlpha
            }
        }
        if show{
            cardViews.forEach{ $0.removeFromSuperview() }
            let h = bounds.height * 0.6, w = h * 0.7
            let rect = CGRect(origin: .zero, size: CGSize(width: w, height: h))
            cardViews = cards.map{ CardView(frame: rect, card: $0) }
            cardViews.forEach{ scrollView.addSubview($0) }
            UIView.animate(withDuration: Game.animTime){
                self.scrollView.contentSize.width = CGFloat(self.cardViews.count) * w
                for i in 0..<self.cardViews.count{
                    self.cardViews[i].center = CGPoint(x: (CGFloat(i)+0.5)*w, y: 0.5 * h)
                }
            }
        }
    }
}

extension UILabel{
    class func create() -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }
}

extension UIView{
    var boundCenter: CGPoint{
        CGPoint(x: bounds.midX, y: bounds.midY)
    }
    func addCenterSubview(_ view: UIView){
        addSubview(view)
        view.center = boundCenter
    }
    func changeSuperview(to toView: UIView){
        if let fromView = superview{
            let newpos = fromView.convert(center, to: toView)
            toView.addSubview(self)
            self.center = newpos
        }else{
            print("WARNING: Change superview without existing superview!")
        }
    }
}
