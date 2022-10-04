//
//  CardStandard.swift
//  TestOld
//
//  Created by William Dong on 2021/8/19.
//

import Foundation

let cardStandard: [String: (LogicCard.Type, CardType, CardSubType)] = [
    "杀": (Sha.self, .Basic, .None),
    "射杀": (Shesha.self, .Basic, .None),
    "闪": (Shan.self, .Basic, .None),
    "桃": (Tao.self, .Basic, .None),
    "无懈可击": (Wuxie.self, .Spell, .Normal),
    "无中生有": (Wuzhong.self, .Spell, .Normal),
    "兵贵神速": (Binggui.self, .Spell, .Normal),
    "水淹七军": (Shuiyan.self, .Spell, .Normal),
    "火烧连营": (Huoshao.self, .Spell, .Normal),
    "奇门遁甲": (Qimen.self, .Spell, .Normal),
    "决斗": (Juedou.self, .Spell, .Normal),
    "南蛮入侵": (Nanman.self, .Spell, .Normal),
    "万箭齐发": (Wanjian.self, .Spell, .Normal),
    "桃园结义": (Taoyuan.self, .Spell, .Normal),
    "过河拆桥": (Guochai.self, .Spell, .Normal),
    "乐不思蜀": (Lebusishu.self, .Spell, .Yield),
    "诸葛连弩": (EquipCard.self, .Equip, .Weapon),
    "青釭剑": (EquipCard.self, .Equip, .Weapon),
    "雌雄双股剑": (EquipCard.self, .Equip, .Weapon),
    "寒冰剑": (EquipCard.self, .Equip, .Weapon),
    "贯石斧": (EquipCard.self, .Equip, .Weapon),
    "丈八蛇矛": (EquipCard.self, .Equip, .Weapon),
    "青龙偃月刀": (EquipCard.self, .Equip, .Weapon),
    "方天画戟": (EquipCard.self, .Equip, .Weapon),
    "朱雀羽扇": (EquipCard.self, .Equip, .Weapon),
    "八卦阵": (EquipCard.self, .Equip, .Armor),
    "仁王盾": (EquipCard.self, .Equip, .Armor),
    "大宛": (EquipCard.self, .Equip, .Horse),
    "赤兔": (EquipCard.self, .Equip, .Horse),
    "紫骍": (EquipCard.self, .Equip, .Horse),
    "绝影": (EquipCard.self, .Equip, .Horse),
    "爪黄飞电": (EquipCard.self, .Equip, .Horse),
    "的卢": (EquipCard.self, .Equip, .Horse),
]

let cardSkillStandard: [String: EquipSkill.Type] = [
    // 武器
    "诸葛连弩": LiannuSkill.self,
    "寒冰剑": HanbingSkill.self,
    "雌雄双股剑": CixiongSkill.self,
    "青釭剑": QinggangSkill.self,
    "贯石斧": GuanshiSkill.self,
    "丈八蛇矛": ZhangbaSkill.self,
    "青龙偃月刀": QinglongSkill.self,
    "方天画戟": FangtianSkill.self,
    "朱雀羽扇": ZhuqueSkill.self,
    // 防具
    "八卦阵": BaguaSkill.self,
    "仁王盾": RenwangSkill.self,
    // 坐骑
    "的卢": CrossHorseSkill.self,
    "爪黄飞电": CrossHorseSkill.self,
    "绝影": CrossHorseSkill.self,
    "赤兔": MoveHorseSkill.self,
    "大宛": MoveHorseSkill.self,
    "紫骍": MoveHorseSkill.self,
]

let deckStandard: [(Suit, Int, String)] = [
    (.Spade, 1, "决斗"),
    (.Spade, 2, "雌雄双股剑"),
    (.Spade, 3, "过河拆桥"),
    (.Spade, 4, "过河拆桥"),
    (.Spade, 5, "青龙偃月刀"),
    (.Spade, 6, "乐不思蜀"),
    (.Spade, 7, "南蛮入侵"),
    (.Spade, 8, "杀"),
    (.Spade, 9, "杀"),
    (.Spade, 10, "杀"),
    (.Spade, 11, "奇门遁甲"),
    (.Spade, 12, "丈八蛇矛"),
    (.Spade, 13, "大宛"),
    
    (.Heart, 1, "万箭齐发"),
    (.Heart, 2, "闪"),
    (.Heart, 3, "火烧连营"),
    (.Heart, 4, "桃"),
    (.Heart, 5, "赤兔"),
    (.Heart, 6, "乐不思蜀"),
    (.Heart, 7, "桃"),
    (.Heart, 8, "无中生有"),
    (.Heart, 9, "桃"),
    (.Heart, 10, "射杀"),
    (.Heart, 11, "无中生有"),
    (.Heart, 12, "过河拆桥"),
    (.Heart, 13, "爪黄飞电"),
    
    (.Club, 1, "兵贵神速"),
    (.Club, 2, "八卦阵"),
    (.Club, 3, "杀"),
    (.Club, 4, "杀"),
    (.Club, 5, "的卢"),
    (.Club, 6, "杀"),
    (.Club, 7, "南蛮入侵"),
    (.Club, 8, "杀"),
    (.Club, 9, "杀"),
    (.Club, 10, "杀"),
    (.Club, 11, "杀"),
    (.Club, 12, "无懈可击"),
    (.Club, 13, "水淹七军"),
    
    (.Diamond, 1, "决斗"),
    (.Diamond, 2, "闪"),
    (.Diamond, 3, "闪"),
    (.Diamond, 4, "朱雀羽扇"),
    (.Diamond, 5, "贯石斧"),
    (.Diamond, 6, "射杀"),
    (.Diamond, 7, "闪"),
    (.Diamond, 8, "闪"),
    (.Diamond, 9, "闪"),
    (.Diamond, 10, "射杀"),
    (.Diamond, 11, "闪"),
    (.Diamond, 12, "桃"),
    (.Diamond, 13, "射杀"),
    
    (.Spade, 1, "兵贵神速"),
    (.Spade, 2, "八卦阵"),
    (.Spade, 3, "奇门遁甲"),
    (.Spade, 4, "奇门遁甲"),
    (.Spade, 5, "绝影"),
    (.Spade, 6, "青釭剑"),
    (.Spade, 7, "杀"),
    (.Spade, 8, "杀"),
    (.Spade, 9, "杀"),
    (.Spade, 10, "杀"),
    (.Spade, 11, "无懈可击"),
    (.Spade, 12, "过河拆桥"),
    (.Spade, 13, "南蛮入侵"),
    
    (.Heart, 1, "桃园结义"),
    (.Heart, 2, "闪"),
    (.Heart, 3, "桃"),
    (.Heart, 4, "火烧连营"),
    (.Heart, 5, "火烧连营"),
    (.Heart, 6, "桃"),
    (.Heart, 7, "无中生有"),
    (.Heart, 8, "桃"),
    (.Heart, 9, "无中生有"),
    (.Heart, 10, "射杀"),
    (.Heart, 11, "射杀"),
    (.Heart, 12, "桃"),
    (.Heart, 13, "闪"),
    
    (.Club, 1, "决斗"),
    (.Club, 2, "杀"),
    (.Club, 3, "过河拆桥"),
    (.Club, 4, "过河拆桥"),
    (.Club, 5, "杀"),
    (.Club, 6, "乐不思蜀"),
    (.Club, 7, "杀"),
    (.Club, 8, "杀"),
    (.Club, 9, "杀"),
    (.Club, 10, "杀"),
    (.Club, 11, "杀"),
    (.Club, 12, "水淹七军"),
    (.Club, 13, "无懈可击"),
    
    (.Diamond, 1, "诸葛连弩"),
    (.Diamond, 2, "闪"),
    (.Diamond, 3, "火烧连营"),
    (.Diamond, 4, "闪"),
    (.Diamond, 5, "闪"),
    (.Diamond, 6, "闪"),
    (.Diamond, 7, "射杀"),
    (.Diamond, 8, "射杀"),
    (.Diamond, 9, "射杀"),
    (.Diamond, 10, "闪"),
    (.Diamond, 11, "闪"),
    (.Diamond, 12, "方天画戟"),
    (.Diamond, 13, "紫骍"),
    
    (.Spade, 2, "寒冰剑"),
    (.Heart, 12, "兵贵神速"),
    (.Club, 2, "仁王盾"),
    (.Diamond, 12, "无懈可击"),
]

class Sha: LogicCard{
    var shesha: Bool = false
    var isFire: Bool = false
    var counted: Bool = true
    var timesLimited: Bool = true
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "杀"
    }
    override func timesValid() -> Bool {
        if user.atMoment("出牌阶段"){
            return user.shaUsed < user.shaMax
        }
        return true
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        let g1 = user.grid
        let g2 = target.grid
        if shesha && g1.onLineWith(grid: g2) { return true }
        // 如有视为在攻击范围内技能，则再计算InAttackRange，暂时不用
        let range = user.attackRange()
        return g1.distanceTo(grid: g2) <= range
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return targetRuleValidNoSelf(target: target)
    }
    override func preUse() {
        onSelectSingleTarget()
    }
    override func onUse() {
        onUseSingleTarget()
    }
    var shanUsed: Int = 0
    var shanRequired: Int = 1
    override func onEffect(target: Player) {
        Damage(from: user, to: target, point: 1, isFire: isFire).execute()
    }
}

class Shesha: Sha{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "射杀"
        shesha = true
    }
}

class Shan: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "闪"
    }
    // TODO: add ruleValid, sha is counter-able
    override func ruleValid() -> Bool {
        if let ev = Event.current as? CardEffect, ev.lCard is Sha, ev.currentTarget === user{
            if ev.currentMoment == "牌对目标生效前"{
                return !ev.lCard.directEffectTargets.has(user)
            }
        }
        return false
    }
    override func momentValid() -> Bool {
        if let ev = Event.current as? CardEffect, ev.lCard is Sha, ev.currentTarget === user{
            return ev.currentMoment == "牌对目标生效前"
        }
        return false
    }
    override func onUse() {
        if let ev = Event.current as? CardEffect{
            targetCard = ev.lCard
        }else{
            print("Error: 在错误时机使用闪")
            assert(false)
        }
    }
    override func onEffect(targetCard: LogicCard) {
        targetCard.countered = true
    }
}

class Tao: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "桃"
    }
    func checkStatus() -> Int{
        if user.atMoment("出牌阶段") { return 1 }
        if Event.current.currentMoment == "处于濒死状态时" { return 2 }
        return 0
    }
    override func momentValid() -> Bool {
        return checkStatus()>0
    }
    override func ruleValid() -> Bool {
        if checkStatus() == 1{
            return true
        }
        if checkStatus() == 2{
            // 为directuse
            return Game.current.players.contains{ self.canTarget($0) }
        }
        return false
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        let range = target.hp > 0 ? 1 : 4
        return targetRangeValidDist(target: target, range: range)
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        if checkStatus() == 1{
            return target.hp < target.maxHp
        }else{
            return target.atMoment("处于濒死状态时")
        }
    }
    override func preUse() {
        if checkStatus() == 1{
            let n = self.canTarget(user) ? 0 : 1
            Input.playerNumRange = (n,1)
            Input.playerFilter = { self.canTarget($0) }
        }else{
            onSelectDirectUse()
        }
    }
    override func onUse() {
        if checkStatus() == 1{
            if Input.selectedPlayers.isEmpty{
                targets = [user]
            }else{
                onSelectSingleTarget()
            }
        }else{
            onUseAllValidTargets()
        }
    }
    override func onEffect(target: Player) {
        HPRecover(player: target, point: 1).execute()
    }
}

class Juedou: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "决斗"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        targetRangeValidDist(target: target, range: 3)
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return targetRuleValidNoSelf(target: target)
    }
    override func preUse() {
        onSelectSingleTarget()
    }
    override func onUse() {
        onUseSingleTarget()
    }
    var isTargetTurn: Bool = false
    var userShaRequired = 1
    var targetShaRequired = 1
    override func onEffect(target: Player) {
        var ended: Bool = false
        while !ended{
            isTargetTurn = !isTargetTurn // 更换出杀方
            let player = isTargetTurn ? target : user
            let n = isTargetTurn ? targetShaRequired : userShaRequired
            for _ in 0..<n{
                let ev = CardNeedPlay(player: player)
                ev.lcardFilter = { $0 is Sha }
                ev.execute()
                if ev.lCard == nil{
                    ended = true
                    break
                }
            }
        }
        if isTargetTurn{
            Damage(from: user, to: target, point: 1).execute()
        }else{
            Damage(from: target, to: user, point: 1).execute()
        }
    }
}

class Guochai: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "过河拆桥"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 4)
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return targetRuleValidNoSelf(target: target)
    }
    override func preUse() {
        onSelectSingleTarget()
    }
    override func onUse() {
        onUseSingleTarget()
    }
    override func onEffect(target: Player) {
        if target.CountCards(yield: true) > 0{
            Input.Reset(player: user)
            Input.autoConfirm = true
            Input.prompt = "选择目标区域中的一张牌弃置"
            Input.cardNumRange = (1,1)
            Input.selectableCardAreas = [target.hand, target.equip, target.yield]
            Input.Get()
            let card = Input.ok ? Input.selectedCards[0] : (target.hand.cards+target.equip.cards+target.yield.cards)[0]
            CardMove([card], to: .discard).execute()
        }
    }
}

class Wuzhong: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "无中生有"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return target === user
    }
    override func preUse() {
        onSelectDirectUse()
    }
    override func onUse() {
        onUseAllValidTargets()
    }
    override func onEffect(target: Player) {
        target.Draw(n: 2)
    }
}

class Nanman: LogicCard {
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "南蛮入侵"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func ruleValid() -> Bool {
        for pl in Game.current.players{
            if self.canTarget(pl){
                return true
            }
        }
        return false
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 3)
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return targetRuleValidNoSelf(target: target)
    }
    override func preUse() {
        onSelectDirectUse()
    }
    override func onUse() {
        onUseAllValidTargets()
    }
    override func onEffect(target: Player) {
        let ev = CardNeedPlay(player: target)
        ev.lcardFilter = { $0 is Sha }
        ev.execute()
        if ev.lCard == nil{
            Damage(from: user, to: target, point: 1).execute()
        }
    }
}

class Wanjian: LogicCard {
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "万箭齐发"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func ruleValid() -> Bool {
        for pl in Game.current.players{
            if self.canTarget(pl){
                return true
            }
        }
        return false
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 3)
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return targetRuleValidNoSelf(target: target)
    }
    override func preUse() {
        onSelectDirectUse()
    }
    override func onUse() {
        onUseAllValidTargets()
    }
    override func onEffect(target: Player) {
        let ev = CardNeedPlay(player: target)
        ev.lcardFilter = {$0.name == "闪"}
        ev.execute()
        if ev.lCard == nil{
            Damage(from: user, to: target, point: 1).execute()
        }
    }
}

class Taoyuan: LogicCard {
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "桃园结义"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 3)
    }
    override func preUse() {
        onSelectDirectUse()
    }
    override func onUse() {
        onUseAllValidTargets()
    }
    override func onEffect(target: Player) {
        HPRecover(player: target, point: 1).execute()
    }
}

class Lebusishu: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "乐不思蜀"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 5)
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        for card in target.yield.cards{
            if Game.current.yieldLogicCardMap[card.id]!.name == self.name{
                return false
            }
        }
        return targetRuleValidNoSelf(target: target)
    }
    override func preUse() {
        onSelectSingleTarget()
    }
    override func onUse() {
        onUseSingleTarget()
    }
    override func onEffect(target: Player) {
        // 回合->阶段->牌结算
        if let ev = Event.ofType(Turn.self){
            ev.skipMove = true
        }
    }
}

class Wuxie: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "无懈可击"
    }
    override func momentValid() -> Bool {
        if let ev = Event.current as? CardEffect{
            return ev.currentMoment == "牌对目标生效前" && ev.lCard.type == .Spell
        }
        return false
    }
    override func onUse() {
        if let ev = Event.current as? CardEffect{
            targetCard = ev.lCard
        }
    }
    override func onEffect(targetCard: LogicCard) {
        targetCard.countered = true
    }
}

class Binggui: LogicCard{
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "兵贵神速"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func ruleValid() -> Bool {
        return true // TODO: 四周都不可进入时不能使用
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return target.id == user.id
    }
    override func onUse() {
        onUseAllValidTargets()
    }
    override func onEffect(target: Player) {
        Move(player: target, distRange: (2,2)).execute()
    }
}

class Shuiyan: LogicCard {
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "水淹七军"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 2)
    }
    override func preUse() {
        onSelectSingleTarget()
    }
    override func onUse() {
        onUseSingleTarget()
    }
    override func onEffect(target: Player) {
        var choice = false
        if !target.equip.cards.isEmpty{
            Input.Reset(player: target)
            Input.prompt = "是否选择弃置装备区所有牌？"
            Input.Get()
            choice = Input.ok
        }
        if choice{
            CardMove(target.equip.cards, to: Game.current.discard).execute()
        }else{
            Damage(from: user, to: target, point: 1).execute()
        }
    }
}

class Huoshao: LogicCard {
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "火烧连营"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 2)
    }
    override func preUse() {
        onSelectSingleTarget()
    }
    override func onUse() {
        onUseSingleTarget()
    }
    override func onEffect(target: Player) {
        let game = Game.current
        if !target.hand.cards.isEmpty{
            target.ShowCards(cards: target.hand.cards)
            if target.hand.cards.contains(where: {$0.suit == .Diamond}){
                var players = game.players.filter{pl in
                    pl !== target && target.rangeHas(pl, range: 1)
                }
                Damage(from: user, to: target, point: 1, isFire: true).execute()
                while true{
                    players = players.filter{ $0.alive }
                    if players.isEmpty { break }
                    var player = players[0]
                    if players.count > 1{
                        player = game.currentTurnPlayer.GetPlayer(players: players, prompt: "选择下一个受到伤害的角色")
                    }
                    players.remove(player)
                    Damage(from: user, to: player, point: 1, isFire: true).execute()
                }
            }
        }
    }
}

class Qimen: LogicCard {
    required init(cards: [Card] = [], user: Player) {
        super.init(cards: cards, user: user)
        name = "奇门遁甲"
    }
    override func momentValid() -> Bool {
        return user.atMoment("出牌阶段")
    }
    override func targetRangeValid(_ target: Player) -> Bool {
        return targetRangeValidDist(target: target, range: 2)
    }
    override func targetRuleValid(_ target: Player) -> Bool {
        return targetRuleValidNoSelf(target: target)
    }
    override func preUse() {
        onSelectSingleTarget()
    }
    override func onUse() {
        onUseSingleTarget()
    }
    override func onEffect(target: Player) {
        SwitchDisplace(players: [user, target]).execute()
    }
}

class BaguaSkill: EquipSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "八卦阵"
        equipSubtype = .Armor
    }
    
    var status = 0
    override func canUse() -> Bool {
        status = 0
        let shan = Shan(cards: [], user: player)
        if shan.canUse(){
            status = 1
        }
        if shan.canPlay(){
            status = 2
        }
        return status > 0
    }
    
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否使用【八卦阵】？")
    }
    
    override func onUse() {
        let status = status
        let ev = Judge(player: player)
        ev.execute()
        if ev.resultColor == .Red{
            let shan = Shan(cards: [], user: player)
            if status == 1{
                CardUse(lCard: shan).execute()
            }else{
                CardPlay(logicCard: shan).execute()
            }
        }
    }
}

class RenwangSkill: EquipSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "仁王盾"
        equipSubtype = .Armor
    }
    
    override func canUse() -> Bool {
        if let ev: CardEffect = player.atMoment("牌对目标结算开始时"), ev.lCard is Sha, ev.lCard.color == .Black{
            return true
        }
        return false
    }
    
    override func onUse() {
        (Event.current as! CardEffect).lCard.effective = false
    }
}

class LiannuSkill: WeaponSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "诸葛连弩"
        attackRange = 1
    }
    
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "使用牌次数合法性"{
            if let lCard = info as? Sha, lCard.user === self{
                return true
            }
        }
        return value
    }
}

class QinggangSkill: WeaponSkill{
    // TODO: 是否严格按照规则集写？
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "青釭剑"
        attackRange = 2
    }
    var cardUse: CardUse!
    override func canUse() -> Bool {
        if let cardUse: CardUse = player.atMoment("指定目标后") {
            if cardUse.lCard is Sha{
                self.cardUse = cardUse
                return true
            }
        }
        return false
    }
    override func onUse() {
        let sha = cardUse.lCard as! Sha
        let sk = QingGangDisable(player: cardUse.currentTarget)
        sk.sha = sha
        player.skills.append(sk)
    }
}

class QingGangDisable: PlayerSkill{
    var sha: Sha! = nil
    override func Setup() {
        type = .Game
        name = "青钢剑效果"
    }
    override func Update() {
        // TODO: 改为检测对每个角色使用结算完成时
        var found = false
        for ev in Event.stack{
            if let ev = ev as? CardUse, ev.lCard === self.sha{
                found = true
            }
        }
        if !found{ // Event has ended
            player.skills.remove(self)
        }else{
            // not ended, need to disable equip skill
            for sk in player.skills{
                if let sk = sk as? EquipSkill, sk.equipSubtype == .Armor{
                    sk.enabled = false
                }
            }
        }
    }
}

class CixiongSkill: WeaponSkill {
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "雌雄双股剑"
        attackRange = 2
    }
    
    override func canUse() -> Bool {
        if let cardUse: CardUse = player.atMoment("指定目标后"),
           cardUse.lCard is Sha, player.hero.gender != cardUse.currentTarget.hero.gender
        {
            return true
        }
        return false
    }
    
    override func preUse()->Bool {
        Input.Reset(player: player)
        Input.prompt = "是否使用【雌雄双股剑】？"
        Input.Get()
        return Input.ok
    }
    
    override func onUse() {
        var cards: [Card] = []
        let ev = (Event.current as! CardUse)
        let target = ev.currentTarget
        if !target.hand.cards.isEmpty{
            Input.Reset(player: target)
            Input.prompt = "选择一张手牌弃置，或者点取消令\(player.hero.name)摸一张牌"
            Input.cardNumRange = (1,1)
            Input.selectableCardAreas = [target.hand]
            Input.Get()
            if Input.ok{
                cards = Input.selectedCards
            }
        }
        if cards.count > 0{
            CardMove(cards, to: .discard).execute()
        }else{
            player.Draw(n: 1)
        }
    }
}

class HanbingSkill: WeaponSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "寒冰剑"
        attackRange = 2
    }
    
    override func canUse() -> Bool {
        if player.atMoment("造成伤害时"), let ev1 = Event.last(2) as? CardEffect,
            ev1.lCard is Sha, ev1.lCard.user === player{
            return true
        }
        return false
    }
    
    override func preUse() -> Bool{
        return player.GetBool(prompt: "是否使用寒冰剑？")
    }
    
    override func onUse() {
        if let ev = Event.current as? Damage{
            ev.point = 0
            let target = ev.target
            for _ in 0..<2{
                if target.CountCards() > 0{
                    Input.Reset(player: player)
                    Input.autoConfirm = true
                    Input.prompt = "请选择一张牌弃置"
                    Input.selectableCardAreas = [target.hand, target.equip]
                    Input.cardNumRange = (1,1)
                    Input.Get()
                    let card = Input.ok ? Input.selectedCards[0] : Input.validCards.randomElement()!
                    CardMove([card], to: .discard).execute()
                }
            }
        }
    }
}

class GuanshiSkill: WeaponSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "贯石斧"
        attackRange = 3
    }
    
    override func canUse() -> Bool {
        if let ev: CardEffect = player.atMoment("使用牌被抵消时"), ev.lCard is Sha{
            return true
        }
        return false
    }
    
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "是否使用贯石斧，选择两张牌弃置，使【杀】依然造成伤害？"
        Input.cardNumRange = (2,2)
        Input.selectableCardAreas = [player.hand, player.equip]
        Input.cardFilter = { $0 !== self.card }
        Input.Get()
        return Input.ok
    }
    
    override func onUse() {
        let cards = Input.selectedCards
        CardMove(cards, to: .discard).execute()
        (Event.current as! CardEffect).lCard.countered = false
    }
}

class ZhangbaSkill: WeaponSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "丈八蛇矛"
        attackRange = 3
    }
    var status = 0
    override func canUse() -> Bool {
        let sha = Sha(cards: [], user: player)
        sha.abstract = true
        if sha.canUse(){
            status = 1
            return true
        }
        if sha.canPlay(){
            status = 2
            return true
        }
        return false
    }
    override func preUse()->Bool {
        Input.Reset(player: player)
        Input.prompt = "选择两张手牌当作杀\(status==1 ? "使用" : "打出")"
        Input.cardNumRange = (2,2)
        Input.selectableCardAreas = [player.hand]
        if status==1{
            // use card
            Input.playerNumRange = (1,1)
            Input.playerFilter = {pl in
                let cards = Input.selectedCards
                return cards.count == 2 && Sha(cards: cards, user: self.player).canTarget(pl)
            }
        }
        Input.okFilter = {
            let sha = Sha(cards: Input.selectedCards, user: self.player)
            return self.status == 1 ? sha.canUse() : sha.canPlay()
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let sha = Sha(cards: Input.selectedCards, user: player)
        if status == 1{
            sha.targets = Input.selectedPlayers
            CardUse(lCard: sha).execute()
        }else{
            CardPlay(logicCard: sha).execute()
        }
    }
}

class QinglongSkill: WeaponSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "青龙偃月刀"
        attackRange = 3
    }
    
    override func canUse() -> Bool {
        if let ev: CardEffect = player.atMoment("使用牌被抵消时"), ev.lCard is Sha{
            return true
        }
        return false
    }
    
    override func preUse() -> Bool{
        return player.GetBool(prompt: "是否使用【青龙偃月刀】？")
    }
    
    override func onUse() {
        let target = (Event.current as! CardEffect).currentTarget
        let ev = CardNeedUseEvent(player: self.player)
        ev.lcardFilter = { card in
            card is Sha
        }
        ev.targetFilter = { $0 === target }
        ev.execute()
    }
}

class FangtianSkill: WeaponSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "方天画戟"
        attackRange = 4
    }
    
    override func canUse() -> Bool {
        if let cardUse: CardUse = player.atMoment("选择目标时"),
           cardUse.lCard is Sha
        {
            let cards = cardUse.lCard.cards
            let hand = player.hand.cards
            if cards.count == hand.count{
                for c in cards{
                    if !hand.has(c) {
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    
    override func preUse() -> Bool{
        let ev = Event.current as! CardUse
        let sha = ev.lCard as! Sha
        Input.Reset(player: player)
        Input.prompt = "是否使用【方天画戟】，选择至多两名额外目标？"
        Input.playerNumRange = (1,2)
        Input.playerFilter = {pl in
            !sha.targets.has(pl) && sha.canTarget(pl)
        }
        Input.Get()
        return Input.ok
    }
    
    override func onUse() {
        let ev = Event.current as! CardUse
        let sha = ev.lCard as! Sha
        for pl in Input.selectedPlayers{
            sha.targets.append(pl)
        }
    }
}

class ZhuqueSkill: WeaponSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "朱雀羽扇"
        attackRange = 4
    }
    
    override func canUse() -> Bool {
        if let dam: Damage = player.atMoment("造成伤害时"), !dam.isFire,
            let eff = Event.last(2) as? CardEffect, eff.lCard is Sha
        {
            return true
        }
        return false
    }
    
    override func preUse() -> Bool{
        return player.GetBool(prompt: "是否使用【朱雀羽扇】，将此伤害改为火焰伤害？")
    }
    
    override func onUse() {
        (Event.current as! Damage).isFire = true
    }
}

class MoveHorseSkill: EquipSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "移动马"
        equipSubtype = .Armor
    }
    
    override func canUse() -> Bool {
        return player.atMoment("出牌阶段")
    }
    
    override func onUse() {
        Move(player: player, distRange: (1,1)).execute()
    }
}

class CrossHorseSkill: EquipSkill{
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        name = "穿越马"
        equipSubtype = .Horse
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "移动边界合法性"{
            let (pl, _) = info as! (Player, Grid)
            if pl === self.player{
                return true
            }
        }
        if name == "停留合法性"{
            let (pl, _, passBy) = info as! (Player, Grid, Bool)
            if pl === self.player && passBy == true{
                return true
            }
        }
        return value
    }
}
