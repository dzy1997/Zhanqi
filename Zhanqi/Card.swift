//
//  Card.swift, including deck structure
//  TestOld
//
//  Created by William Dong on 2021/3/6.
//

import Foundation

enum CardType: Int{
    case None
    case Basic
    case Spell
    case Equip
    static func of(_ name: String) -> CardType{
        if let (_, type, _) = cardAll[name]{
            return type
        }
        return .None
    }
}

enum CardSubType: Int{
    case None
    case Normal
    case Yield
    case Weapon
    case Armor
    case Horse
    case Treasure
    static func of(_ name: String) -> CardSubType{
        if let (_, _, subtype) = cardAll[name]{
            return subtype
        }
        return .None
    }
}

enum Suit: Int{
    case None
    case Spade
    case Heart
    case Diamond
    case Club
    var symbol: String{
        if self == .Spade { return "♠" }
        if self == .Heart { return "♥" }
        if self == .Diamond { return "♦" }
        if self == .Club { return "♣" }
        return "X"
    }
}

enum Color: Int{
    case None
    case Red
    case Black
}

enum CardAreaType: Int{
    case None
    case Hand
    case Equip
    case Yield
    case Deck
    case Discard
    case Handle
    case Outside
    var name: String{
        if self == .Hand { return "手牌" }
        if self == .Equip { return "装备区" }
        if self == .Yield { return "延时区" }
        if self == .Deck { return "牌堆" }
        if self == .Discard { return "弃牌堆" }
        if self == .Handle { return "处理区" }
        if self == .Hand { return "游戏外" }
        return "未知区域"
    }
}

class CardArea{
    var cards: [Card] = []
    var type: CardAreaType = .None
    var owner: Player? = nil
    init(cards: [Card] = [], type: CardAreaType, owner: Player? = nil){
        self.cards = cards
        self.type = type
        self.owner = owner
    }
    func toStr() -> String{
        var pl = ""
        if let owner = owner{
            pl = owner.hero.name + "的"
        }
        return "\(pl)\(type.name)"
    }
    func RemoveCard(card: Card){
        cards.removeAll{$0===card}
    }
    func GetCards(n: Int, back: Bool = false) -> [Card]{
        let N = cards.count
        if n > N { return [] }
        if back{
            return Array(cards[N-n...N-1])
        }else{
            return Array(cards[0...n-1])
        }
    }
    static var deck: CardArea { Game.current.deck }
    static var discard: CardArea { Game.current.discard }
    static var handle: CardArea { Game.current.handle }
    static var outside: CardArea { Game.current.outside }
}


class Card{ // 物理牌
    var id: Int = 0
    
    var _name: String = "杀"
    var _suit: Suit = .Spade
    var _rank: Int = 1
    
    var name: String{ return Game.Compute(name: "牌名称", value: _name, info: self) }
    var suit: Suit{ return Game.Compute(name: "牌花色", value: _suit, info: self) }
    var rank: Int{ return Game.Compute(name: "牌点数", value: _rank, info: self) }
    var color: Color{
        if _suit == .Club || _suit == .Spade { return .Black }
        if _suit == .Diamond || _suit == . Heart { return .Red }
        return .None
    }
    
    var type: CardType { CardType.of(name) }
    var subtype: CardSubType { CardSubType.of(name) }

    var area: CardArea = CardArea(type: .Outside)
    var visibleTo: [Player] = []
    
    func createLogicCard(user: Player) -> LogicCard{
        return cardAll[name]!.0.init(cards: [self], user: user)
    }
    
    func createEquipSkill(player: Player) -> EquipSkill{
        return equipSkillAll[name]!.init(player: player, card: self)
    }
    
    func toStr() -> String{
        return "\(_suit.symbol)\(_rank.rankSymbol)\(_name)"
    }
}

extension Int{
    var rankSymbol: String{
        if self <= 10 && self >= 2 { return "\(self)" }
        if self == 1 { return "A" }
        if self == 11 { return "J" }
        if self == 12 { return "Q" }
        if self == 13 { return "K" }
        return "X"
    }
}

class LogicCard{ // 逻辑牌，如丈八杀有两张牌
    var cards: [Card] = []
    var name: String = "牌名"
    var type: CardType { CardType.of(name) }
    var subtype: CardSubType { CardSubType.of(name) }
    
    var suit: Suit = .None
    var rank: Int = -1
    var color: Color = .None
    var abstract: Bool = false // 特殊用途，如需要使用红色杀时，需要使用牌事件判定
    
    var user: Player
    var targets: [Player] = []
    var targetCard: LogicCard? = nil
    
    var effective: Bool = true
    var countered: Bool = false
    
    var directEffectTargets: [Player] = [] // targets that cannot be countered
    
    required init(cards: [Card] = [], user: Player){
        self.cards = cards
        self.user = user
        self.suit = cards.count == 1 ? cards[0].suit : .None
        self.rank = cards.count == 1 ? cards[0].rank : -1
        if cards.count == 1{
            self.color = cards[0].color
        }else{
            if cards.isEmpty{ self.color = .None }
            else{
                let s = Array(Set(cards.map{$0.color}))
                self.color = s.count == 1 ? s[0] : .None
            }
        }
    }
    
    // Inherited functions
    func timesValid() -> Bool{ // 次数合法，如杀为每回合限一次
        return true
    }
    func momentValid() -> Bool{ // 时机合法，如出牌阶段
        return false
    }
    func ruleValid() -> Bool{ // 规则合法，如南蛮无合法目标不能使用
        return true
    }
    func canUse(checkTimes: Bool = true, checkMoment: Bool = true, checkRule: Bool = true) -> Bool{
        // TODO: temporarily disable equip skill for Wusheng
        var moment = true
        if checkMoment{
            if let ev = Event.current as? CardNeedUseEvent{
                moment = ev.player === user && ev.lcardFilter(self)
            }else{
                moment = momentValid()
            }
        }
        var times = true
        if checkTimes{
            times = timesValid()
            times = Game.Compute(name: "使用牌次数合法性", value: times, info: self)
        }
        var rule = true
        if checkRule{
            rule = ruleValid()
            rule = Game.Compute(name: "使用牌规则合法性", value: rule, info: self)
        }
        return times && moment && rule
    }
    func canPlay(checkMoment: Bool = true, checkRule: Bool = true) -> Bool{
        var moment = true
        if checkMoment{
            if let ev = Event.current as? CardNeedPlay, ev.player === self.user{
                moment = ev.lcardFilter(self)
            }else{
                moment = false
            }
        }
        var rule = true
        if checkRule{
            rule = Game.Compute(name: "打出牌规则合法性", value: rule, info: self)
        }
        return moment && rule
    }
    func targetRangeValid(_ target: Player) -> Bool{
        return true
    }
    func targetRuleValid(_ target: Player) -> Bool{
        return true
    }
    func canTarget(_ target: Player, checkRange: Bool = true, checkRule: Bool = true) -> Bool{
        var range = true
        if checkRange{
            range = targetRangeValid(target)
            range = Game.Compute(name: "牌目标距离合法性", value: range, info: (self, target))
        }
        var rule = true
        if checkRule{
            rule = targetRuleValid(target)
            // 处理需要使用牌的目标限制
            var needUse: CardNeedUseEvent? = nil
            if let ev = Event.current as? CardNeedUseEvent, ev.player === self.user{
                needUse = ev
            }
            if user.atMoment("选择目标时"), let ev = Event.last(2) as? CardNeedUseEvent, ev.targetLimited{
                needUse = ev
            }
            if let needUse = needUse {
                rule = rule && needUse.targetFilter(target)
            }
            
            rule = Game.Compute(name: "牌目标规则合法性", value: rule, info: (self, target))
        }
        return range && rule
    }
    func preUse(){
        
    }
    func onUse(){
        
    }
    func onEffect(targetCard: LogicCard){
        
    }
    func onEffect(target: Player){
        
    }
    // function templates for subclasses
    func onSelectSingleTarget(){
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in self.canTarget(pl) }
    }
    func onSelectDirectUse(){
        
    }
    func onUseSingleTarget(){
        self.targets = Input.selectedPlayers
    }
    func onUseAllValidTargets(){
        self.targets = Game.current.players.filter{pl in
            self.canTarget(pl)
        }
    }
    func targetRangeValidDist(target: Player, range: Int) -> Bool{
        let realRange = Game.Compute(name: "牌范围", value: range, info: self)
        return user.rangeHas(target, range: realRange)
    }
    func targetRuleValidNoSelf(target: Player) -> Bool{
        return target !== user
    }
}

// Equip card and associated skills
class EquipCard: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = cards[0].name
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func preUse() {
        onSelectDirectUse()
    }
    override func onUse() {
        self.targets = [user]
    }
    override func onEffect(target: Player) {
        let card = cards[0]
        CardMove([card], to: target.equip).execute()
        for card1 in target.equip.cards{
            if card1.subtype == card.subtype && card1 !== card{
                CardMove([card1], to: .discard).execute()
                break
            }
        }
    }
}

class CardMove: Event{ // Moving Physical Cards
    var cards: [Card]
    var origs: [CardArea] = []
    var dest: CardArea
    var front: Bool = false
    var visibleTo: [Player] = []
    init(_ cards: [Card], to dest: CardArea, front: Bool = false, visibleTo: [Player]? = nil){
        self.cards = cards
        self.dest = dest
        self.front = front
        if let vt = visibleTo{
            self.visibleTo = vt
        }else{
            // automatically handle visibility change
            let areas: [CardAreaType] = [.Equip, .Yield, .Discard, .Handle]
            if areas.contains(dest.type){
                self.visibleTo = Game.current.players
            }
            if dest.type == .Deck{
                self.visibleTo = []
            }
            if dest.type == .Hand{
                self.visibleTo = [dest.owner!]
            }
        }
        super.init()
    }
    override func toStr() -> String {
        let cs = cards.map{ c in c.toStr() }
        return "\(cs)移动到\(dest.toStr())"
    }
    override func process() {
        if cards.isEmpty { assert(false) }
        origs = cards.map{ $0.area }
        let game = Game.current
        InvokeMoment("牌移动前")
        // Mark handle cards
        if dest.type == .Handle{
            Event.last(2).handleCards += cards
        }
        for i in 0..<cards.count{
            let card = cards[i]
            let orig = origs[i]
            orig.cards.remove(card)
            // remove equip skill
            if orig.type == .Equip{
                for sk in orig.owner!.skills{
                    if let sk = sk as? EquipSkill, sk.card === card{
                        orig.owner!.skills.remove(sk)
                        break
                    }
                }
            }
            // remove yield card
            if orig.type == .Yield && dest.type != .Yield{
                game.yieldLogicCardMap.removeValue(forKey: card.id)
            }
            card.area = dest
            // Add equip skill
            if dest.type == .Equip{
                let sk = card.createEquipSkill(player: dest.owner!)
                dest.owner!.skills.append(sk)
            }
            // Change visibility
            card.visibleTo = self.visibleTo
        }
        if front{
            dest.cards = cards + dest.cards
        }else{
            dest.cards = dest.cards + cards
        }
        // TODO: Generalize this condition
        if dest.type == .Handle && visibleTo.count != 6 || dest.type == .Deck {
            // no animation for Guanxing and Yiji
        }else{
            Event.WaitForAnim(timeScale: 2.0) {
                game.gameView.AnimateCardMove(cardmove: self)
            }
        }
        InvokeMoment("牌移动后")
    }
}

class CardUse: Event{
    var lCard: LogicCard
    var currentTarget: Player = Player()
    init(lCard: LogicCard) {
        self.lCard = lCard
    }
    override func toStr() -> String {
        let targets = lCard.targets.map{ t in t.hero.name }
        return "\(lCard.user.hero.name)对\(targets)使用【\(lCard.name)】"
    }
    override func process() {
        if let ev = Event.last(2) as? CardNeedUseEvent{
            ev.lCard = self.lCard
        }
        InvokeMoment("选择目标时", lCard.user)
        if !lCard.cards.isEmpty{
            CardMove(lCard.cards, to: .handle).execute()
        }
        InvokeMoment("使用牌时", lCard.user)
        if lCard is Sha, let ev = Event.last(2) as? PhasePlay, ev.player === lCard.user{
            let pl = lCard.user
            pl.shaUsed += 1
            print("\(pl.hero.name)已使用\(pl.shaUsed)/\(pl.shaMax)张杀")
        }
        if !lCard.targets.isEmpty{
            for name in ["指定目标时", "成为目标时", "指定目标后", "成为目标后"]{
                var doneTargets: [Player] = []
                while true {
                    let targets = lCard.targets.filter{pl in !doneTargets.has(pl)}
                    if targets.isEmpty { break }
                    currentTarget = targets[0]
                    let mp = ["指定目标时", "指定目标后"].contains(name) ? lCard.user : currentTarget
                    InvokeMoment(name, mp)
                    doneTargets.append(currentTarget)
                    // remove cancelled targets
                    doneTargets = doneTargets.filter{pl in lCard.targets.has(pl)}
                }
            }
        }
        if CardSubType.of(lCard.name) == .Yield{
            let card = lCard.cards[0]
            CardMove([card], to: lCard.targets[0].yield).execute()
            Game.current.yieldLogicCardMap[card.id] = lCard
        }else{
            CardEffect(lCard: lCard).execute()
        }
    }
    override func momentHaltCondition() -> Bool {
        if ["指定目标时", "成为目标时", "指定目标后", "成为目标后"].contains(currentMoment){
            return lCard.targets.has(currentTarget)
        }
        return false
    }
}

class CardEffect: Event{
    var lCard: LogicCard
    var doneTargets: [Player] = []
    var currentTarget: Player = Player()
    
    init(lCard: LogicCard){
        self.lCard = lCard
    }
    
    override func process() {
        // 将延时锦囊移到处理区
        if lCard.subtype == .Yield{
            let card = lCard.cards[0]
            CardMove([card], to: .handle).execute()
            Game.current.cardsToShow.append(card)
        }
        // 使用闪或无懈可击，其中只有无懈可以被抵消
        if let tCard = lCard.targetCard{
            lCard.effective = true
            InvokeMoment("牌对目标结算开始时")
            if lCard.effective{
                lCard.countered = false
                if !lCard.directEffectTargets.has(currentTarget){
                    InvokeMoment("牌对目标生效前")
                }
                if lCard.countered{
                    InvokeMoment("使用牌被抵消时")
                }
                if !lCard.countered{
                    lCard.onEffect(targetCard: tCard)
                }
            }
        }
        // 使用其他基本牌或普通锦囊牌
        while true {
            let targets = lCard.targets.filter{t in !doneTargets.has(t)}
            if targets.isEmpty { break }
            currentTarget = targets[0]
            if targets.count > 1{
                currentTarget = lCard.user.GetPlayer(players: targets, prompt: "选择下一个结算的角色")
            }
            doneTargets.append(currentTarget)
            lCard.effective = true
            InvokeMoment("牌对目标结算开始时", currentTarget)
            if lCard.effective{
                lCard.countered = false
                // TODO: Enable wuxie query after test
                if lCard.type != .Spell{
                    InvokeMoment("牌对目标生效前", currentTarget)
                    // 无双效果
                    if let sha = lCard as? Sha, sha.shanRequired == 2, sha.countered{
                        sha.countered = false
                        InvokeMoment("牌对目标生效前", currentTarget)
                    }
                }
                if lCard.countered{
                    InvokeMoment("使用牌被抵消时", lCard.user)
                }
                if !lCard.countered{
                    lCard.onEffect(target: currentTarget)
                }
            }
        }
    }
    override func momentHaltCondition() -> Bool {
        if currentMoment == "牌对目标生效前"{
            return lCard.countered
        }
        return false
    }
}

class CardNeedUseEvent: Event{
    var player: Player
    var lcardFilter: (LogicCard) -> Bool = { _ in false }
    // filter限定牌名/牌类型
    var targetFilter: (Player) -> Bool = { _ in true}
    var targetLimited: Bool = false // 青龙刀/骑兵为仅限某名角色true，乱武/蓄锐为包含某名角色false
    var lCard: LogicCard? = nil
    init(player: Player){
        self.player = player
    }
    override func process() {
        InvokeMoment("需要使用牌时", player)
    }
    override func momentHaltCondition() -> Bool {
        return lCard != nil
    }
}

class CardPlay: Event{
    var logicCard: LogicCard
    init(logicCard: LogicCard){
        self.logicCard = logicCard
    }
    override func toStr() -> String {
        "\(logicCard.user.hero.name)打出【\(logicCard.name)】"
    }
    override func process() {
        if let ev = Event.ofType(CardNeedPlay.self){
            ev.lCard = self.logicCard
        }
        if !logicCard.cards.isEmpty{
            CardMove(logicCard.cards, to: .handle).execute()
        }
        InvokeMoment("打出牌时", logicCard.user)
    }
}

class CardNeedPlay: Event {
    var player: Player
    var lcardFilter: (LogicCard) -> Bool = { _ in false }
    var lCard: LogicCard? = nil
    init(player: Player){
        self.player = player
    }
    override func process() {
        InvokeMoment("需要打出牌时", player)
    }
    override func momentHaltCondition() -> Bool {
        return lCard != nil
    }
}
