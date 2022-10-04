//
//  Event.swift
//  Event and moment
//  TestOld
//
//  Created by William Dong on 2021/3/6.
//

extension Array where Element: AnyObject{
    func has(_ item: Element) -> Bool{
        for it in self{
            if it === item { return true }
        }
        return false
    }
    mutating func remove(_ item: Element) -> Void{
        self.removeAll{it in it === item}
    }
}

import Foundation
import UIKit

class Event { // consider subclassing Event
    static var stack: [Event] = []
    class func last(_ i: Int) -> Event{ // 最后i个，i>=1
        return stack[stack.count-i]
    }
    class func ofType<T>(_ t: T.Type) -> T?{
        for i in 0..<stack.count{
            let e = stack[stack.count-i-1]
            if let ev = e as? T{
                return ev
            }
        }
        return nil
    }
    class var current: Event{
        return stack[stack.count-1]
    }
    
    func toStr() -> String {"\(type(of: self))事件"}
    
    var tags: [String] = []
    var currentMoment: String = ""
    var handleCards: [Card] = []
    var clearHandleCards: Bool = true
    
    var ended: Bool = false
    var endMoment: Bool = false
    var nextMoment: String = ""
    
    init(){
        
    }
    
    var spaces: String{
        return String(repeating: "| ", count: Event.stack.count)
    }
    
    func Start(){
        let line = spaces + "Event:\(self.toStr())"
        Game.current.LogText(line)
        Event.stack.append(self)
    }
    
    func Finish(){
        if Event.current === self{
            Event.stack.removeLast()
//            print(spaces + "EventEnd")
        }
    }
    
    func End(){
        if ended { return }
        ended = true
        if self is GameEvent{
            for ev in Event.stack{
                ev.ended = true
                ev.endMoment = true
                ev.nextMoment = ""
            }
        }
        if self is Turn{
            if let phase = Event.ofType(Phase.self){
                phase.ended = true
                phase.nextMoment = ""
            }
        }
    }
    
    func execute(){ // 结算事件
        if !Event.stack.isEmpty{
            let ev = Event.current
            if ev.ended{
                return
            }
        }
        Game.current.skillsUpToDate = false
        Start()
        process()
        if clearHandleCards{
            let cards = handleCards.filter{ $0.area.type == .Handle }
            if !cards.isEmpty{
                CardMove(cards, to: .discard).execute()
            }
        }
        Finish()
    }
    
    func process(){ // 结算流程
        
    }
    
    func momentHaltCondition() -> Bool{
        return false
    }
    
    func momentShouldHalt() -> Bool{
        return endMoment || momentHaltCondition()
    }
    
    var momentPlayer: Player? = nil
    var currentSkill: Skill? = nil
    var usedSkills: [Skill] = []
    var excludedSkills: [Skill] = [] // asked non-reusable skills, or rejected usabled skills
    func InvokeMoment(_ name: String, _ player: Player? = nil){
        if !Event.ofType(GameEvent.self)!.gameStarted { return }
        if ended && name != nextMoment{
            return
        }
        currentMoment = name
        momentPlayer = player
        defer{
            currentMoment = ""
            momentPlayer = nil
        }
        let line = spaces + "\(name)"
        Game.current.LogText(line)
        
        usedSkills = []
        excludedSkills = []
        let game = Game.current
        if name == "出牌阶段"{ // PhasePlay
            let player = game.currentTurnPlayer
            while !ended{
                Input.Reset(player: player)
                Input.prompt = "出牌阶段，请选择卡牌或技能"
                Input.okFilter = { !Input.selectedCards.isEmpty || !Input.selectedChoices.isEmpty }
                Input.cardNumRange = (0,1)
                Input.selectableCardAreas = [player.hand]
                Input.cardFilter = { card in
                    card.createLogicCard(user: player).canUse()
                }
                Input.onSelectCard = { card in
                    Input.choiceFilter = {_ in false} // TODO: should we remove this?
                    let lCard = card.createLogicCard(user: player)
                    lCard.preUse() // configure player input
                }
                Input.onDeselectCard = { card in
                    Input.choiceFilter = {_ in true}
                    Input.selectedPlayers = []
                    Input.playerNumRange = (0,0)
                    Input.playerFilter = {_ in true}
                }
                game.updateAllSkills()
                let activeSkills = game.getAllSkills().filter{sk in
                    sk.canUse() && sk.enabled && !excludedSkills.has(sk)
                }
                Input.choiceNumRange = (0, activeSkills.isEmpty ? 0 : 1)
                Input.choices = activeSkills.map{skill in skill.name}
                Input.Get()
                if Input.ok{
                    if Input.selectedChoices.count > 0{
                        let sk = activeSkills[Input.selectedChoices[0]]
                        let use = sk.preUse()
                        if use{
                            usedSkills.append(sk)
                            if !sk.reusable { excludedSkills.append(sk) }
                            sk.Use()
                        }
                    }else{ // use a card
                        let card = Input.selectedCards[0]
                        let lCard = card.createLogicCard(user: player)
                        lCard.onUse()
                        CardUse(lCard: lCard).execute()
                    }
                    if momentShouldHalt() { return }
                }else{
                    ended = true
                }
            }
        }else{ // Normal
            // 角色技能
            var donePlayers: [Player] = []
            while true{
                game.updateAllSkills()
                let activePlayers = game.players.filter{pl in
                    if donePlayers.has(pl) { return false }
                    if pl.canUseCard() || pl.canPlayCard() { return true }
                    return pl.getSkills().contains{sk in sk.canUse() && sk.enabled }
                }
                if activePlayers.isEmpty { break }
                var player = activePlayers[0]
                if activePlayers.count > 1{
                    player = game.currentTurnPlayer.GetPlayer(players: activePlayers, prompt: "选择下一个响应的角色")
                }
                donePlayers.append(player)
                let levels: [SkillType] = [.Map, .Hero, .Equip]
                for level in levels{
                    while true {
                        game.updateAllSkills()
                        let skills = player.getSkills(type: level).filter{sk in
                            sk.canUse() && sk.enabled && !excludedSkills.has(sk)
                        }
                        if skills.isEmpty { break }
                        var i = 0
                        if skills.count > 1{
                            i = player.GetChoice(choices: skills.map{$0.name},
                                                 prompt: "选择下一个发动的技能")
                        }
                        let sk = skills[i]
                        let use = sk.preUse()
                        if !sk.reusable || !use{
                            excludedSkills.append(sk)
                        }
                        if use{
                            usedSkills.append(sk)
                            sk.Use()
                            if momentShouldHalt() { return }
                        }
                    }
                }
                let use = player.canUseCard()
                let play = player.canPlayCard()
                if use || play{
                    Input.Reset(player: player)
                    Input.prompt = "请选择一张卡牌"
                    Input.selectableCardAreas = [player.hand]
                    Input.cardNumRange = (1,1)
                    Input.cardFilter = { card in
                        let lCard = card.createLogicCard(user: player)
                        return use ? lCard.canUse() : lCard.canPlay()
                    }
                    if use{
                        Input.onSelectCard = { card in
                            let lCard = card.createLogicCard(user: player)
                            lCard.preUse()
                        }
                        Input.onDeselectCard = { card in
                            Input.selectedPlayers = []
                            Input.playerNumRange = (0,0)
                            Input.playerFilter = { _ in true }
                        }
                    }
                    Input.Get()
                    if Input.ok{
                        let card = Input.selectedCards[0]
                        let lCard = card.createLogicCard(user: player)
                        if use{
                            lCard.onUse()
                            CardUse(lCard: lCard).execute()
                        }else{
                            CardPlay(logicCard: lCard).execute()
                        }
                        if momentShouldHalt() { return }
                    }
                }
            }
            // 地图机制和全局技能
            let glevels: [SkillType] = [.Map, .Game]
            let player = game.currentTurnPlayer
            for level in glevels{
                while true {
                    game.updateAllSkills()
                    let skills = game.getAllSkills(type: level, globalOnly: true).filter{sk in
                        sk.canUse() && !excludedSkills.has(sk) && sk.enabled
                    }
                    if skills.isEmpty { break }
                    var i = 0
                    if skills.count > 1{
                        i = player.GetChoice(choices: skills.map{$0.name}, prompt: "选择下一个发动的技能")
                    }
                    let sk = skills[i]
                    let use = sk.preUse()
                    if !sk.reusable || !use{
                        excludedSkills.append(sk)
                    }
                    if use{
                        usedSkills.append(sk)
                        sk.Use()
                        if momentShouldHalt() { return }
                    }
                }
            }
        }
    }
}

class GameEvent:Event{
    var game: Game
    init(game: Game){
        self.game = game
        super.init()
    }
    override func toStr() -> String {
        "游戏事件"
    }
    var gameStarted = false
    override func process(){
        for i in 0..<6{
            let pos = game.map.campPositions[i]
            let grid = game.map.getGrid(at: pos)!
            Displace(player: game.players[i], to: grid).execute()
        }
        for player in game.players{
            player.Draw(n: 3)
        }
        gameStarted = true
        InvokeMoment("游戏开始时")
        for i in 0..<10{
            if !ended{
                Round(number: i).execute()
            }
        }
        Game.current.LogText("游戏结束")
    }
}

class Round: Event {
    var roundNumber: Int
    init(number: Int) {
        self.roundNumber = number
        super.init()
    }
    override func toStr() -> String {
        "第\(roundNumber)轮"
    }
    override func process() {
        InvokeMoment("轮开始时")
        for pl in Game.current.players{
            pl.turnExecuted = false
        }
        // 暖方先选，冷方先动
        ActionUnit(team: 1, n: 1)
        ActionUnit(team: 0, n: 2)
        ActionUnit(team: 1, n: 2)
        ActionUnit(team: 0, n: 1)
    }
    func ActionUnit(team: Int, n: Int){
        for _ in 0..<n{
            let validPlayers = Game.current.players.filter{pl in pl.team == team && !pl.turnExecuted}
            var player = validPlayers[0]
            if validPlayers.count > 1{
                Input.Reset(player: Game.current.teamLeaders[team])
                Input.autoConfirm = true
                Input.prompt = "选择下一个进行回合的友方角色"
                Input.playerNumRange = (1,1)
                Input.playerFilter = { pl in validPlayers.has(pl) }
                Input.Get()
                if Input.ok{
                    player = Input.selectedPlayers[0]
                }
            }
            Turn(player: player).execute()
            player.turnExecuted = true
        }
    }
}

class Turn: Event{
    public var player: Player
    var skipYield: Bool = false
    var skipDraw: Bool = false
    var skipMove: Bool = false
    var skipPlay: Bool = false
    var skipDiscard: Bool = false
    init(player: Player) {
        self.player = player
        super.init()
        nextMoment = "回合结束时"
    }
    override func toStr() -> String {
        "\(player.hero.name)的回合"
    }
    override func process() {
        Event.WaitForAnim(timeScale: 0.0) {
            Game.current.gameView.mainPlayerView.SetPlayer(player: self.player)
        }
        if !player.alive{
            Input.Reset(player: player)
            Input.autoConfirm = true
            Input.prompt = "选择一个大本营/军营放入你的棋子"
            Input.gridNumRange = (1,1)
            let camps = Game.current.map.campGrids(team: self.player.team)
            let grids = camps.filter{ grid in self.player.canStay(grid: grid) }
            Input.gridFilter = { grid in grids.has(grid) }
            Input.Get()
            let grid = Input.ok ? Input.selectedGrids[0] : grids[0]
            Displace(player: player, to: grid).execute()
            player.alive = true
            player.hp = player.maxHp
        }
        InvokeMoment("回合开始时", player)
        InvokeMoment("准备阶段", player)
        InvokeMoment("延时阶段开始前", player)
        if !skipYield{
            PhaseYield(player: player).execute()
        }
        InvokeMoment("摸牌阶段开始前", player)
        if !skipDraw{
            PhaseDraw(player: player).execute()
        }
        InvokeMoment("移动阶段开始前", player)
        if !skipMove{
            PhaseMove(player: player).execute()
        }
        InvokeMoment("出牌阶段开始前", player)
        if !skipPlay{
            PhasePlay(player: player).execute()
        }
        InvokeMoment("弃牌阶段开始前", player)
        if !skipDiscard{
            PhaseDiscard(player: player).execute()
        }
        InvokeMoment("结束阶段", player)
        InvokeMoment("回合结束时", player)
        player.movePoint = 0
    }
}

class Phase: Event{
    var player: Player
    init(player: Player){
        self.player = player
        super.init()
    }
    override func toStr() -> String {
        "\(player.hero.name)的\(type(of: self))"
    }
}

class PhaseYield: Phase{
    override func process() {
        while !player.yield.cards.isEmpty{
            let card = player.yield.cards.last!
            if let lCard = Game.current.yieldLogicCardMap[card.id]{
                lCard.targets = [player]
                CardEffect(lCard: lCard).execute()
            }
        }
    }
}

class PhaseDraw: Phase{
    var n_draw: Int = 2
    override func process() {
        InvokeMoment("摸牌阶段开始时", player)
        InvokeMoment("摸牌阶段", player)
        if n_draw > 0{
            player.Draw(n: n_draw)
        }
        InvokeMoment("摸牌阶段结束时", player)
    }
}

class PhaseMove: Phase{
    override func process() {
        InvokeMoment("移动阶段开始时", player)
        player.movePoint = Game.Compute(name: "移动力", value: player.hp, info: player)
        let move = Move(player: player, distRange: (0,player.movePoint))
        move.useMovePoint = true
        move.execute()
        InvokeMoment("移动阶段结束时", player)
    }
}

class PhasePlay: Phase{
    override func process() {
        InvokeMoment("出牌阶段开始时", player)
        player.shaUsed = 0
        player.shaMax = 1
        InvokeMoment("出牌阶段", player)
        InvokeMoment("出牌阶段结束时", player)
    }
}

class PhaseDiscard: Phase{
    override func process() {
        InvokeMoment("弃牌阶段开始时", player)
        InvokeMoment("弃牌阶段", player)
        let limit = Game.Compute(name: "手牌上限", value: player.hp, info: player)
        let n = player.hand.cards.count - limit
        if n > 0{
            Input.Reset(player: player)
            Input.prompt = "请选择\(n)张手牌弃置"
            Input.cardNumRange = (n,n)
            Input.selectableCardAreas = [player.hand]
            Input.Get()
            let cards = Input.ok ? Input.selectedCards : Array(self.player.hand.cards[0...n-1])
            CardMove(cards, to: .discard).execute()
        }
        InvokeMoment("弃牌阶段结束时", player)
    }
}

class Damage: Event{
    var source: Player?
    var target: Player
    var point: Int
    var isFire: Bool = false
    init(from source: Player, to target: Player, point: Int, isFire: Bool = false){
        self.source = source
        self.target = target
        self.point = point
        self.isFire = isFire
    }
    override func process() {
        InvokeMoment("造成伤害时", source)
        if point > 0{
            InvokeMoment("受到伤害时", target)
        }
        if point > 0{
            HPReduce(player: target, point: point).execute()
            InvokeMoment("造成伤害后", source)
            InvokeMoment("受到伤害后", target)
        }
    }
    override func momentShouldHalt() -> Bool {
        return point <= 0
    }
    override func toStr() -> String {
        let s = source?.hero.name ?? "系统"
        let f = isFire ? "火焰" : ""
        return "\(s)对\(target.hero.name)造成\(point)点\(f)伤害"
    }
}

class HPLose: Event{
    var player: Player
    var point: Int
    init(player: Player, point: Int) {
        self.player = player
        self.point = point
    }
    override func process() {
        HPReduce(player: player, point: point).execute()
    }
}

class HPReduce: Event{
    var player: Player
    var point: Int
    init(player: Player, point: Int) {
        self.player = player
        self.point = point
    }
    override func process() {
        player.hp -= point
        Event.WaitForAnim {
            Game.current.gameView.AnimateHPChange(player: self.player)
        }
        if player.hp < 1{
            Dying(player: player).execute()
        }
    }
}

class HPRecover: Event{
    var player: Player
    var point: Int
    init(player: Player, point: Int){
        self.player = player
        self.point = point
    }
    override func process() {
        InvokeMoment("回复体力前", player)
        point = min(point, player.maxHp-player.hp)
        if point > 0{
            player.hp += point
            Event.WaitForAnim {
                Game.current.gameView.AnimateHPChange(player: self.player)
            }
            if let dying = Event.ofType(Dying.self){
                dying.recovered = true
            }
            InvokeMoment("回复体力后", player)
        }
    }
    override func toStr() -> String {
        "\(player.hero.name)回复体力"
    }
}

class Dying: Event{
    var player: Player
    var recovered: Bool = false
    init(player: Player) {
        self.player = player
    }
    override func momentHaltCondition() -> Bool { player.hp > 0 }
    override func process() {
        while player.alive && player.hp <= 0{
            recovered = false
            InvokeMoment("处于濒死状态时", player)
            if !recovered{
                Die(player: player).execute()
            }
        }
    }
    override func toStr() -> String {
        "\(player.hero.name)濒死"
    }
}

class Die: Event{
    var player: Player
    var killedBy: Player? = nil
    init(player: Player) {
        self.player = player
    }
    override func process() {
        // damage->hpreduce->dying->die
        if let damage = Event.last(4) as? Damage{
            killedBy = damage.source
        }
        InvokeMoment("死亡时", player)
        player.alive = false
        // trigger animation
        Event.WaitForAnim {
            let gv = Game.current.gameView!
            gv.playerViews[self.player.id].Update()
            if gv.mainPlayerView.player === self.player{
                gv.mainPlayerView.playerView.Update()
            }
        }
        let cards = player.hand.cards + player.equip.cards + player.yield.cards
        CardMove(cards, to: .discard).execute()
        if Game.current.flagOwners[player.team] === player{
            Game.current.flagOwners[player.team] = nil
        }
        // handle grid change
        let grid = player.grid
        player.grid = Grid.dummy
        Event.WaitForAnim {
            Game.current.gameView.mapView.UpdateChess(player: self.player)
            for gv in Game.current.gameView.mapView.gridViews{
                if gv.grid === grid{
                    gv.Update()
                }
            }
        }
        
        let team = 1-player.team
        Score(team: team, point: 3).execute()
        if let kb = killedBy, kb.alive{
            kb.Draw(n: 2)
        }
        InvokeMoment("死亡后", player)
        // End turn / phase if needed
        if let turn = Event.ofType(Turn.self), turn.player === player{
            turn.End()
        }
    }
    override func toStr() -> String {
        "\(player.hero.name)死亡"
    }
}

class Score: Event{
    var team: Int
    var point: Int
    init(team: Int, point: Int){
        self.team = team
        self.point = point
    }
    override func process() {
        let game = Game.current
        InvokeMoment("得分时")
        game.teamScores[team] += point
        let goal = 10 // TODO: change this line
        if game.teamScores[team] >= goal{
            Game.current.LogText("Team \(team) wins")
            Event.ofType(GameEvent.self)!.End()
            
            let side = team == 0 ? "暖方" : "冷方"
            let s1 = game.teamScores[team]
            let s2 = game.teamScores[1-team]
            let mes = "\(side)\(s1)-\(s2)获胜"
            DispatchQueue.main.async {
                let vc = Game.current.gameView.parentViewController!
                let alert=UIAlertController(title:"游戏结束", message: mes, preferredStyle: UIAlertController.Style.alert)
                let cancel=UIAlertAction(title: "回到主界面", style: .cancel){ _ in
                    vc.dismiss(animated: true)
                }
                alert.addAction(cancel)
                vc.present(alert, animated: true, completion: nil)
            }
        }
        InvokeMoment("得分后")
    }
    override func toStr() -> String {
        "\(team == 0 ? "暖色" : "冷色")方得\(point)分"
    }
}

class Judge: Event{
    var player: Player
    var card: Card = Card()
    var resultName: String = ""
    var resultSuit: Suit = .None
    var resultRank: Int = 0
    var resultColor: Color{
        if resultSuit == .Club || resultSuit == .Spade {return .Black}
        if resultSuit == .Diamond || resultSuit == .Heart {return .Red}
        return .None
    }
    init(player: Player){
        self.player = player
    }
    override func process() {
        let game = Game.current
        game.RequireDeck(n: 1)
        card = game.deck.cards[0]
        CardMove([card], to: .handle).execute()
        InvokeMoment("判定牌生效前", player)
        resultName = card.name
        resultSuit = card.suit
        resultRank = card.rank
        InvokeMoment("判定牌生效后", player)
    }
    override func toStr() -> String {
        "\(player.hero.name)进行判定"
    }
}

class RankCompare: Event{
    var players: [Player]
    var cards: [Card]
    var ranks: [Int] = [0,0]
    init(source: Player, target: Player){
        self.players = [source, target]
        self.cards = [source.hand.cards[0], target.hand.cards[0]]
    }
    override func process() {
        for i in 0...1{
            Input.Reset(player: players[i])
            Input.autoConfirm = true
            Input.prompt = "请选择拼点牌"
            Input.cardNumRange = (1,1)
            Input.selectableCardAreas = [players[i].hand]
            Input.Get()
            if Input.ok{
                cards[i] = Input.selectedCards[0]
            }
        }
        CardMove(cards, to: .handle).execute()
        // 拼点牌亮出时
        ranks[0] = cards[0].rank
        ranks[1] = cards[1].rank
        // 拼点结果确定后
    }
    override func toStr() -> String {
        "\(players[0].hero.name)向\(players[1].hero.name)发起拼点"
    }
}

extension Event{
    static let animSem = DispatchSemaphore(value: 0)
    static func WaitForAnim(timeScale: Double = 1.0, anims: @escaping () -> Void){
        DispatchQueue.main.async {
            anims()
        }
        let time = timeScale * Game.animTime
        DispatchQueue.main.asyncAfter(deadline: .now()+time) {
            Event.animSem.signal()
        }
        Event.animSem.wait()
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        for responder in sequence(first: self, next: { $0.next }) {
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
