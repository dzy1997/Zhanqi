//
//  HeroStandard.swift
//  TestOld
//
//  Created by William Dong on 2021/8/21.
//

import Foundation

var heroStandard:[String:([String], Gender, Int, Int)] = [
    "刘备": (["仁德", "无中"], .Male, 4, 4),
    "关羽": (["武圣"], .Male, 4, 4),
    "张飞": (["喝断"], .Male, 4, 4),
    "赵云": (["龙胆"], .Male, 4, 4),
    "马超": (["马术", "铁骑"], .Male, 4, 4),
    "诸葛亮": (["观星", "空城"], .Male, 3, 3),
    "黄月英": (["集智", "奇才"], .Female, 3, 3),
    
    "曹操": (["奸雄"], .Male, 4, 4),
    "郭嘉": (["天妒", "遗计"], .Male, 3, 3),
    "司马懿": (["鬼才", "伏膺"], .Male, 3, 3),
    "夏侯惇": (["刚烈"], .Male, 4, 4),
    "张辽": (["突袭"], .Male, 4, 4),
    "许褚": (["裸衣"], .Male, 4, 4),
    "甄姬": (["洛神", "倾国"], .Female, 3, 3),
    "曹纯": (["骁锐"], .Male, 4, 4),
    
    "孙权": (["制衡"], .Male, 4, 4),
    "甘宁": (["奇袭"], .Male, 4, 4),
    "吕蒙": (["渡江"], .Male, 4, 4),
    "黄盖": (["苦肉"], .Male, 4, 4),
    "周瑜": (["英姿", "反间"], .Male, 3, 3),
    "大乔": (["国色", "流离"], .Female, 3, 3),
    "陆逊": (["炎灭", "智变"], .Male, 3, 3),
    "孙尚香": (["结姻", "枭姬"], .Female, 3, 3),
    
    "华佗": (["急救", "青囊"], .Male, 3, 3),
    "吕布": (["无双"], .Male, 4, 4),
    "貂蝉": (["离间", "闭月"], .Female, 3, 3),
]

var heroSkillStandard: [String: PlayerSkill.Type] = [
    // Shu
    "仁德": Rende.self,
    "武圣": Wusheng.self,
    "喝断": Heduan.self,
    "龙胆": Longdan.self,
    "马术": Mashu.self,
    "铁骑": Tieji.self,
    "观星": Guanxing.self,
    "空城": Kongcheng.self,
    "集智": Jizhi.self,
    "奇才": Qicai.self,
    // Wei
    "奸雄": Jianxiong.self,
    "天妒": Tiandu.self,
    "遗计": Yiji.self,
    "鬼才": Guicai.self,
    "伏膺": Fuying.self,
    "刚烈": Ganglie.self,
    "突袭": Tuxi.self,
    "裸衣": Luoyi.self,
    "洛神": Luoshen.self,
    "倾国": Qingguo.self,
    "骁锐": Xiaorui.self,
    // Wu
    "制衡": Zhiheng.self,
    "奇袭": Qixi.self,
    "渡江": Dujiang.self,
    "苦肉": Kurou.self,
    "英姿": Yingzi.self,
    "反间": Fanjian.self,
    "国色": Guose.self,
    "流离": Liuli.self,
    "炎灭": Yanmie.self,
    "智变": Zhibian.self,
    "枭姬": Xiaoji.self,
    "结姻": Jieyin.self,
    // Qun
    "青囊": Qingnang.self,
    "急救": Jijiu.self,
    "无双": Wushuang.self,
    "离间": Lijian.self,
    "闭月": Biyue.self,
    // zhongchou
    "神弓": Wusheng.self,
    "拥权": Wusheng.self,
    "威严": Wusheng.self,
    "恶来": Wusheng.self,
    "奔命": Wusheng.self,
    "归营": Wusheng.self,
    "诱兵": Wusheng.self,
    "冲杀": Wusheng.self,
    // promo
    "汉德": Hande.self,
    "天幸": Tianxing.self,
    "伏兵": Wusheng.self,
    "刚戾": Wusheng.self,
    // debug
    "无中": WuzhongSkill.self,
]

class WuzhongSkill: PlayerSkill{
    override func Setup() {
        self.name = "无中"
        self.reusable = true
    }
    override func canUse() -> Bool {
        return player.atMoment("出牌阶段")
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张手牌当【无中生有】使用"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand]
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let lCard = Wuzhong(cards: Input.selectedCards, user: player)
        lCard.onUse()
        CardUse(lCard: lCard).execute()
    }
}

class Rende: PlayerSkill{
    override func Setup() {
        self.name = "仁德"
        self.reusable = true
    }
    var n_given: Int = 0
    override func Update(){
        if player.atMoment("出牌阶段开始时"){
            n_given = 0
        }
    }
    override func canUse() -> Bool {
        return player.atMoment("出牌阶段") && !player.hand.cards.isEmpty
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择至少一张手牌与距离3以内的一名角色"
        Input.cardNumRange = (1,-1)
        Input.selectableCardAreas = [player.hand]
        Input.playerNumRange = (1,1)
        Input.playerFilter = {pl in
            pl !== self.player && self.player.rangeHas(pl, range: 3)
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let cards = Input.selectedCards
        let target = Input.selectedPlayers[0]
        CardMove(cards, to: target.hand).execute()
        if n_given < 2 && n_given + cards.count >= 2{
            HPRecover(player: player, point: 1).execute()
        }
        n_given += cards.count
    }
}

class Wusheng: PlayerSkill{
    override func Setup() {
        self.name = "武圣"
        self.reusable = true
    }
    var status = 0
    override func canUse() -> Bool {
        // TODO: make a function to create abstract cards
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
        Input.prompt = "选择一张红色牌当作杀\(status==1 ? "使用" : "打出")"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand, player.equip]
        Input.cardFilter = { $0.color == .Red }
        if status==1{
            // use card
            Input.playerNumRange = (1,1)
            Input.playerFilter = {pl in
                let cards = Input.selectedCards
                return cards.count == 1 && Sha(cards: cards, user: self.player).canTarget(pl)
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

class Heduan: PlayerSkill{
    override func Setup() {
        self.name = "喝断"
    }
    var target: Player! = nil
    override func canUse() -> Bool {
        if let ev: Turn = player.atMoment("移动阶段开始前", global: true),
           ev.player.team != player.team, ev.player.grid.onLineWith(grid: player.grid),
           !ev.player.hand.cards.isEmpty, !player.hand.cards.isEmpty
        {
            target = ev.player
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否发动【喝断】？")
    }
    override func onUse() {
        let comp = RankCompare(source: player, target: target)
        comp.execute()
        if comp.ranks[0] > comp.ranks[1]{
            (Event.current as! Turn).skipMove = true
        }else{
            CardMove([comp.cards[1]], to: player.hand).execute()
            CardMove([comp.cards[0]], to: target.hand).execute()
        }
    }
}

class Dujiang: PlayerSkill{
    override func Setup() {
        self.name = "渡江"
    }
    var activated: Bool = false
    override func Update() {
        let ev = Event.current
        let name = ev.currentMoment
        if name == "进入地形后"{
            if let ev = ev as? Displace, ev.gridFrom.name == "湖泊" && ev.gridTo.name == "湖泊"{
                if Event.last(2) is Move{
                    activated = true
                }
            }
        }
        if name == "回合结束时"{
            if let ev = ev as? Turn, ev.player === self{
                activated = false
            }
        }
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "移动合法性"{
            if let ev = Event.current as? Move, ev.useMovePoint{
                let (pl, grid) = info as! (Player, Grid)
                if pl === self.player && pl.grid.name == "湖泊" && grid.name == "湖泊"{
                    return true
                }
            }
        }
        if name == "牌目标规则合法性"{
            if activated{
                let (card, target) = info as! (LogicCard, Player)
                if card is Sha && card.user === player{
                    if !player.rangeHas(target, range: 1){
                        return false
                    }
                }
            }
        }
        return value
    }
    var sha: LogicCard! = nil
    override func canUse() -> Bool {
        let ev = Event.current
        if let ev = ev as? CardUse, ev.lCard is Sha, ev.lCard.user === player, ev.currentMoment == "指定目标后"{
            sha = ev.lCard
            return true
        }
        return false
    }
    override func onUse() {
        sha.directEffectTargets = sha.targets
    }
}

class Chongsha: PlayerSkill{
    override func Setup() {
        self.name = "冲杀"
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "停留无人合法性"{
            if let phase = Event.last(2) as? PhaseMove, phase.player === player{
                let (player, grid) = info as! (Player, Grid)
                if let pl = grid.players.first, pl.team != player.team{
                    return true
                }
            }
        }
        return value
    }
    override func canUse() -> Bool {
        if name == "进入地形时"{
            // PhaseMove->Move->Displace
            if let ev1 = Event.last(3) as? PhaseMove, ev1.player === player{
                let grid = (Event.current as! Displace).gridTo
                if !["军营","大本营"].contains(grid.name){
                    if grid.players.contains(where: {pl in pl.team != player.team}){
                        return true
                    }
                }
            }
        }
        return false
    }
    override func onUse() {
        let ev = Event.current as! Displace
        let target = ev.gridTo.players.first{pl in pl.team != player.team}!
        var use = true
        if player.skills.contains(where: {sk in sk is CrossHorseSkill}){
            // TODO: provide choice when having a horse
            use = player.GetBool(prompt: "是否发动【冲杀】？")
        }
        if use{
            var push = false
            if let nei = target.grid.neighbor(on: ev.direction){
                if player.canMoveTo(grid: nei){
                    push = true
                    Displace(player: target, to: nei).execute()
                }
            }
            if !push{
                // TODO: move target to nearest grid
                Damage(from: player, to: target, point: 1).execute()
            }
        }
    }
}

class Kurou: PlayerSkill{
    override func Setup() {
        self.name = "苦肉"
        self.reusable = true
    }
    override func canUse() -> Bool {
        return player.atMoment("出牌阶段")
    }
    override func onUse() {
        HPLose(player: player, point: 1).execute()
        if player.alive{
            player.Draw(n: 2)
        }
    }
}

class Zhiheng: PlayerSkill{
    override func Setup() {
        self.name = "制衡"
    }
    override func canUse() -> Bool {
        return player.atMoment("出牌阶段")
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择至少一张牌进行【制衡】"
        Input.selectableCardAreas = [player.equip, player.hand]
        Input.cardNumRange = (1,-1)
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let cards = Input.selectedCards
        CardMove(cards, to: .discard).execute()
        player.Draw(n: cards.count)
    }
}

class Mashu: PlayerSkill{
    override func Setup() {
        self.name = "马术"
        self.reusable = true
    }
    override func canUse() -> Bool {
        return player.atMoment("出牌阶段") && player.movePoint > 0
    }
    override func onUse() {
        let move = Move(player: player, distRange: (0,player.movePoint))
        move.useMovePoint = true
        move.execute()
    }
}

class Tieji: PlayerSkill{
    override func Setup() {
        self.name = "铁骑"
    }
    override func canUse() -> Bool {
        if let ev: CardUse = player.atMoment("指定目标后"),
           ev.lCard is Sha, ev.lCard.user === player{
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否要发动【铁骑】？")
    }
    override func onUse() {
        let judge = Judge(player: player)
        judge.execute()
        if judge.resultColor == .Red{
            let carduse = Event.current as! CardUse
            carduse.lCard.directEffectTargets.append(carduse.currentTarget)
        }
    }
}

class Guanxing: PlayerSkill{
    override func Setup() {
        self.name = "观星"
    }
    override func canUse() -> Bool {
        if player.atMoment("准备阶段"){
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否要发动【观星】？")
    }
    override func onUse() {
        let game = Game.current
        let n = player.hp == player.maxHp ? 5 : 3
        game.RequireDeck(n: n)
        let cards = game.deck.GetCards(n: n)
        CardMove(cards, to: .handle, visibleTo: [player]).execute()
        Input.Reset(player: player)
        Input.prompt = "依次选择放在牌堆顶的牌，先选的在上"
        Input.cardNumRange = (0,n)
        Input.selectableCards = cards
        Input.Get()
        let topCards = Input.ok ? Input.selectedCards : []
        let remainCards = cards.filter{ !topCards.has($0) }
        var bottomCards = remainCards
        if !remainCards.isEmpty{
            if remainCards.count > 1{
                Input.Reset(player: player)
                Input.prompt = "依次选择放在牌堆底的牌，后选的在下"
                Input.cardNumRange = (remainCards.count, remainCards.count)
                Input.selectableCards = remainCards
                Input.Get()
                if Input.ok{
                    bottomCards = Input.selectedCards
                }
            }
        }
        if !topCards.isEmpty{
            CardMove(topCards, to: .deck, front: true).execute()
        }
        if !bottomCards.isEmpty{
            CardMove(bottomCards, to: .deck).execute()
        }
    }
}

class Kongcheng: PlayerSkill{
    override func Setup() {
        name = "空城"
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "牌目标规则合法性"{
            let (lCard, target) = info as! (LogicCard, Player)
            if lCard is Sha || lCard is Juedou, target === player, player.hand.cards.isEmpty{
                return false
            }
        }
        return value
    }
}

class Longdan: PlayerSkill{
    override func Setup() {
        self.name = "龙胆"
        self.reusable = true
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
        let shan = Shan(cards: [], user: player)
        shan.abstract = true
        if shan.canUse(){
            status = 3
            return true
        }
        if shan.canPlay(){
            status = 4
            return true
        }
        return false
    }
    override func preUse()->Bool {
        Input.Reset(player: player)
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand]
        if status == 1 || status == 2{
            Input.prompt = "选择一张【闪】当【杀】" + (status == 1 ? "使用" : "打出")
            Input.cardFilter = { $0.name == "闪" }
            if status == 1{
                Input.playerNumRange = (1,1)
                Input.playerFilter = {pl in
                    let cards = Input.selectedCards
                    return cards.count == 1 && Sha(cards: cards, user: self.player).canTarget(pl)
                }
            }
            Input.okFilter = {
                let sha = Sha(cards: Input.selectedCards, user: self.player)
                return self.status == 1 ? sha.canUse() : sha.canPlay()
            }
        }else{
            Input.prompt = "选择一张【杀】当【闪】" + (status == 3 ? "使用" : "打出")
            Input.cardFilter = { $0.name == "杀" }
            Input.okFilter = {
                let shan = Shan(cards: Input.selectedCards, user: self.player)
                return self.status == 3 ? shan.canUse() : shan.canPlay()
            }
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        if status == 1 || status == 2{
            let sha = Sha(cards: Input.selectedCards, user: player)
            if status == 1{
                sha.onUse()
                CardUse(lCard: sha).execute()
            }else{
                CardPlay(logicCard: sha).execute()
            }
        }
        if status == 3 || status == 4{
            let shan = Shan(cards: Input.selectedCards, user: player)
            if status == 3{
                shan.onUse()
                CardUse(lCard: shan).execute()
            }else{
                CardPlay(logicCard: shan).execute()
            }
        }
    }
}

class Jizhi: PlayerSkill{
    override func Setup() {
        name = "集智"
    }
    override func canUse() -> Bool {
        if let ev:CardUse = player.atMoment("使用牌时"),
           ev.lCard.subtype == .Normal{
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否发动【集智】？")
    }
    override func onUse() {
        player.Draw(n: 1)
    }
}

class Qicai: PlayerSkill{
    override func Setup() {
        name = "奇才"
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "牌范围"{
            let lCard = info as! LogicCard
            if lCard.type == .Spell, lCard.user === player{
                return (value as! Int) + 2
            }
        }
        return value
    }
}

class Jianxiong: PlayerSkill{
    override func Setup() {
        name = "奸雄"
    }
    var cards: [Card] = []
    override func canUse() -> Bool {
        if player.atMoment("受到伤害后"), let ev1 = Event.last(2) as? CardEffect, ev1.currentSkill == nil{
            let cs = ev1.lCard.cards.filter{ $0.area.type == .Handle }
            if !cs.isEmpty{
                self.cards = cs
                return true
            }
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否发动【奸雄】？")
    }
    override func onUse() {
        CardMove(cards, to: player.hand).execute()
    }
}

class Luoshen: PlayerSkill{
    override func Setup() {
        name = "洛神"
    }
    override func canUse() -> Bool {
        if player.atMoment("准备阶段"){
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否发动【洛神】？")
    }
    override func onUse() {
        while true{
            let j = Judge(player: player)
            j.clearHandleCards = false
            j.execute()
            let black = j.resultColor == .Black
            CardMove([j.card], to: black ? player.hand : .discard).execute()
            let cont = black ? player.GetBool(prompt: "是否继续【洛神】？") : false
            if !cont { break }
        }
    }
}

class Qingguo: PlayerSkill{
    override func Setup() {
        self.name = "倾国"
    }
    var status = 0
    override func canUse() -> Bool {
        let shan = Shan(cards: [], user: player)
        shan.abstract = true
        if shan.canUse(){
            status = 1
            return true
        }
        if shan.canPlay(){
            status = 2
            return true
        }
        return false
    }
    override func preUse()->Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张黑色手牌当作【闪】\(status==1 ? "使用" : "打出")"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand]
        Input.cardFilter = { $0.color == .Black }
        Input.okFilter = {
            let shan = Shan(cards: Input.selectedCards, user: self.player)
            return self.status == 1 ? shan.canUse() : shan.canPlay()
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let shan = Shan(cards: Input.selectedCards, user: player)
        if status == 1{
            shan.onUse()
            CardUse(lCard: shan).execute()
        }else{
            CardPlay(logicCard: shan).execute()
        }
    }
}

class Tiandu: PlayerSkill{
    override func Setup() {
        self.name = "天妒"
    }
    var judge: Judge!
    override func canUse() -> Bool {
        if let j: Judge = player.atMoment("判定牌生效后"){
            judge = j
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否发动【天妒】？")
    }
    override func onUse() {
        CardMove([judge.card], to: player.hand).execute()
    }
}

class Yiji: PlayerSkill{
    override func Setup() {
        self.name = "遗计"
        self.reusable = true
    }
    override func canUse() -> Bool {
        if let damage: Damage = player.atMoment("受到伤害后"){
            let n_used = damage.usedSkills.filter{ $0 === self }.count
            return n_used < damage.point
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否发动【遗计】？")
    }
    override func onUse() {
        Game.current.RequireDeck(n: 2)
        let cards = Game.current.deck.GetCards(n: 2)
        CardMove(cards, to: .handle, visibleTo: [player]).execute()
        Input.Reset(player: player)
        Input.prompt = "选择一到两名距离3以内的角色获得这些牌"
        Input.selectableCards = cards // not selectable, just view
        Input.playerNumRange = (1,2)
        Input.playerFilter = { self.player.rangeHas($0, range: 3) }
        Input.Get()
        if Input.ok{
            let players = Input.selectedPlayers
            if players.count == 1{
                CardMove(cards, to: players[0].hand).execute()
            }else{
                CardMove([cards[0]], to: players[0].hand).execute()
                CardMove([cards[1]], to: players[1].hand).execute()
            }
        }else{
            CardMove(cards, to: player.hand).execute()
        }
    }
}

class Guicai: PlayerSkill{
    override func Setup() {
        self.name = "鬼才"
    }
    var judge: Judge!
    override func canUse() -> Bool {
        if let j:Judge = player.atMoment("判定牌生效前", global: true), !player.hand.cards.isEmpty{
            judge = j
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "是否发动【鬼才】？请选择一张手牌"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand]
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let card = Input.selectedCards[0]
        let lCard = card.createLogicCard(user: player)
        let play = CardPlay(logicCard: lCard)
        play.clearHandleCards = false
        play.execute()
        CardMove([judge.card], to: .discard).execute()
        judge.card = card
    }
}

class Fuying: PlayerSkill{
    override func Setup() {
        self.name = "伏膺"
    }
    var source: Player!
    override func canUse() -> Bool {
        if player.atMoment("受到伤害后"){
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "是否发动【伏膺】？请选择一名角色。"
        Input.playerNumRange = (1,1)
        Input.playerFilter = {pl in pl.CountCards()>0 }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let target = Input.selectedPlayers[0]
        Input.Reset(player: player)
        Input.prompt = "请选择一张卡牌获得"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [target.hand, target.equip]
        Input.Get()
        let card = Input.ok ? Input.selectedCards[0] : (target.hand.cards + target.equip.cards)[0]
        CardMove([card], to: player.hand).execute()
    }
}

class Ganglie: PlayerSkill{
    override func Setup() {
        self.name = "刚烈"
    }
    var source: Player! = nil
    override func canUse() -> Bool {
        if let dam: Damage = player.atMoment("受到伤害后"),
           let source = dam.source, source.alive
        {
            self.source = source
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        player.GetBool(prompt: "是否发动【刚烈】？")
    }
    override func onUse() {
        let j = Judge(player: player)
        j.execute()
        if j.resultSuit != .Heart{
            var discard = false
            if !source.hand.cards.isEmpty{
                Input.Reset(player: source)
                Input.prompt = "选择两张手牌弃置，或受到夏侯惇造成的1点伤害"
                Input.cardNumRange = (2,2)
                Input.selectableCardAreas = [source.hand]
                Input.Get()
                if Input.ok{
                    discard = true
                    CardMove(Input.selectedCards, to: .discard).execute()
                }
            }
            if !discard{
                Damage(from: player, to: source, point: 1).execute()
            }
        }
    }
}

class Luoyi: PlayerSkill{
    override func Setup() {
        self.name = "裸衣"
    }
    var activated = false
    override func Update() {
        if player.atMoment("回合开始时"), activated{
            activated = false
        }
    }
    var status = 0
    override func canUse() -> Bool {
        if let pd: PhaseDraw = player.atMoment("摸牌阶段"), pd.n_draw > 0{
            status = 1
            return true
        }
        if player.atMoment("造成伤害时"), activated,
           let cardUse = Event.last(2) as? CardEffect{
            if cardUse.lCard is Sha || cardUse.lCard is Juedou{
                status = 2
                return true
            }
        }
        return false
    }
    override func preUse() -> Bool {
        if status == 1{
            return player.GetBool(prompt: "是否发动【裸衣】？")
        }else{
            return true
        }
    }
    override func onUse() {
        if status == 1{
            (Event.current as! PhaseDraw).n_draw -= 1
            activated = true
        }else{
            (Event.current as! Damage).point += 1
        }
    }
}

class Tuxi: PlayerSkill{
    override func Setup() {
        self.name = "突袭"
    }
    var targets: [Player] = []
    override func canUse() -> Bool {
        if let pd: PhaseDraw = player.atMoment("摸牌阶段"), pd.n_draw > 0{
            targets = Game.current.players.filter{pl in
                pl !== player && !pl.hand.cards.isEmpty && player.rangeHas(pl, range: 3)
            }
            if !targets.isEmpty{
                return true
            }
        }
        return false
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "是否发动【突袭】？请选择一至两名角色"
        Input.playerNumRange = (1,2)
        Input.playerFilter = { self.targets.has($0) }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        (Event.current as! PhaseDraw).n_draw = 0
        targets = Input.selectedPlayers
        for pl in targets{
            Input.Reset(player: player)
            Input.autoConfirm = true
            Input.prompt = "请选择一张牌获得"
            Input.cardNumRange = (1,1)
            Input.selectableCardAreas = [pl.hand]
            Input.Get()
            let card = Input.ok ? Input.selectedCards[0] : pl.hand.cards[0]
            CardMove([card], to: player.hand).execute()
        }
    }
}

class Xiaorui: PlayerSkill{
    override func Setup() {
        name = "骁锐"
    }
    var target: Player? = nil
    override func Update() {
        if player.atMoment("回合结束时", global: true), target != nil{
            target = nil
        }
    }
    var status = 0
    override func canUse() -> Bool {
        if let turn: Turn = player.atMoment("回合开始时", global: true),
           turn.player.team == player.team, player.rangeHas(turn.player, range: 2)
        {
            status = 1
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        (Event.current as! Turn).player.GetBool(prompt: "是否发动曹纯的【骁锐】？")
    }
    override func onUse() {
        target = (Event.current as! Turn).player
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "移动力"{
            let player = info as! Player
            if player === target{
                return (value as! Int) + 1
            }
        }
        if name == "攻击范围"{
            let player = info as! Player
            if player === target{
                return (value as! Int) + 1
            }
        }
        return value
    }
}

class Qixi: PlayerSkill{
    override func Setup() {
        name = "奇袭"
        reusable = true
    }
    override func canUse() -> Bool {
        let guochai = Guochai(cards: [], user: player)
        guochai.abstract = true
        return guochai.canUse()
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张黑色牌当作【过河拆桥】使用"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand, player.equip]
        Input.cardFilter = { $0.color == .Black }
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in
            let cards = Input.selectedCards
            return cards.count == 1 && Guochai(cards: cards, user: self.player).canTarget(pl)
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let guochai = Guochai(cards: Input.selectedCards, user: player)
        guochai.onUse()
        CardUse(lCard: guochai).execute()
    }
}

class Yingzi: PlayerSkill{
    override func Setup() {
        name = "英姿"
    }
    override func canUse() -> Bool {
        if player.atMoment("摸牌阶段"){
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        player.GetBool(prompt: "是否发动【英姿】？")
    }
    override func onUse() {
        (Event.current as! PhaseDraw).n_draw += 1
    }
}

class Fanjian: PlayerSkill{
    override func Setup() {
        name = "反间"
    }
    override func canUse() -> Bool {
        if player.atMoment("出牌阶段"), !player.hand.cards.isEmpty{
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一名距离3以内的其他角色"
        Input.playerNumRange = (1,1)
        Input.playerFilter = {pl in
            self.player.rangeHas(pl, range: 3) && pl !== self.player
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let target = Input.selectedPlayers[0]
        Input.Reset(player: target)
        Input.prompt = "周瑜对你发动【反间】，请选择一种花色"
        Input.choiceNumRange = (1,1)
        let suits: [Suit] = [.Spade, .Heart, .Diamond, .Club]
        Input.choices = suits.map{ $0.symbol }
        Input.Get()
        let suit = Input.ok ? suits[Input.selectedChoices[0]] : Suit.Diamond
        let card = player.hand.cards[0] // TODO: 随机选牌机制
        CardMove([card], to: target.hand).execute()
        target.ShowCards(cards: [card])
        if suit != card.suit{
            Damage(from: player, to: target, point: 1).execute()
        }
    }
}

class Guose: PlayerSkill{
    override func Setup() {
        name = "国色"
        reusable = true
    }
    override func canUse() -> Bool {
        let lebu = Lebusishu(cards: [], user: player)
        lebu.abstract = true
        return lebu.canUse()
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张方片牌当作【乐不思蜀】使用"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand, player.equip]
        Input.cardFilter = { $0.suit == .Diamond }
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in
            let cards = Input.selectedCards
            return cards.count == 1 && Lebusishu(cards: cards, user: self.player).canTarget(pl)
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let lebu = Lebusishu(cards: Input.selectedCards, user: player)
        lebu.onUse()
        CardUse(lCard: lebu).execute()
    }
}

class Liuli: PlayerSkill{
    override func Setup() {
        name = "流离"
    }
    var sha: Sha!
    override func canUse() -> Bool {
        if let carduse: CardUse = player.atMoment("成为目标时"),
           let s = carduse.lCard as? Sha, player.CountCards() > 0{
            sha = s
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "是否发动【流离】？请选择一张卡牌与一名距离3以内的其他角色"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand, player.equip]
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in
            pl !== self.player && self.player.rangeHas(pl, range: 3)
            && !self.sha.targets.has(pl) && self.sha.canTarget(pl, checkRange: false)
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let card = Input.selectedCards[0]
        let target = Input.selectedPlayers[0]
        CardMove([card], to: .discard).execute()
        sha.targets.remove(player)
        sha.targets.append(target)
    }
}

class Yanmie: PlayerSkill{
    override func Setup() {
        name = "炎灭"
        reusable = true
    }
    override func canUse() -> Bool {
        player.atMoment("出牌阶段") && !player.hand.cards.isEmpty
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张红桃手牌当作【火烧连营】使用"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand]
//        Input.cardFilter = { $0.suit == .Heart }
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in
            let cards = Input.selectedCards
            return cards.count == 1 && Huoshao(cards: cards, user: self.player).canTarget(pl)
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let huoshao = Huoshao(cards: Input.selectedCards, user: player)
        huoshao.onUse()
        CardUse(lCard: huoshao).execute()
    }
}

class Zhibian: PlayerSkill{
    override func Setup() {
        name = "智变"
    }
    override func canUse() -> Bool {
        player.atMoment("出牌阶段") && !player.hand.cards.isEmpty
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张手牌与一名其他角色"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand]
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in
            pl !== self.player && self.player.rangeHas(pl, range: 3)
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let card = Input.selectedCards[0]
        let target = Input.selectedPlayers[0]
        CardMove([card], to: target.hand).execute()
        let move = Move(player: target, distRange: (1,1))
        move.controller = player
        move.execute()
    }
}

class Xiaoji: PlayerSkill{
    override func Setup() {
        name = "枭姬"
    }
    override func canUse() -> Bool {
        if let cardmove: CardMove = player.atMoment("牌移动后", global: true){
            let n_lost = cardmove.origs.filter{ $0 === player.equip }.count
            if n_lost > 0{
                let n_used = cardmove.usedSkills.filter{ $0 === self }.count
                return n_used < n_lost
            }
        }
        return false
    }
    override func preUse() -> Bool {
        player.GetBool(prompt: "是否发动【枭姬】？")
    }
    override func onUse() {
        player.Draw(n: 2)
    }
}

class Jieyin: PlayerSkill{
    override func Setup() {
        name = "结姻"
    }
    override func canUse() -> Bool {
        player.atMoment("出牌阶段") && player.hand.cards.count >= 2
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择两张手牌与一名距离3以内受伤的男性角色"
        Input.cardNumRange = (2,2)
        Input.selectableCardAreas = [player.hand]
        Input.playerNumRange = (1,1)
        Input.playerFilter = {pl in
            self.player.rangeHas(pl, range: 3) && pl.hp < pl.maxHp && pl.hero.gender == .Male
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        CardMove(Input.selectedCards, to: .discard).execute()
        HPRecover(player: player, point: 1).execute()
        HPRecover(player: Input.selectedPlayers[0], point: 1).execute()
    }
}

class Jijiu: PlayerSkill{
    override func Setup() {
        name = "急救"
        reusable = true
    }
    override func canUse() -> Bool {
        if let turn = Event.ofType(Turn.self), turn.player !== player{
            let tao = Tao(cards: [], user: player)
            tao.abstract = true
            let canUse = tao.canUse()
            let canTarget = Game.current.players.contains{ tao.canTarget($0) }
            return canUse && canTarget
        }
        return false
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张红色牌当作【桃】使用"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand, player.equip]
        Input.cardFilter = { $0.color == .Red }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        let tao = Tao(cards: Input.selectedCards, user: player)
        tao.onUse()
        CardUse(lCard: tao).execute()
    }
}

class Qingnang: PlayerSkill{
    override func Setup() {
        name = "青囊"
    }
    override func canUse() -> Bool {
        player.atMoment("出牌阶段") && !player.hand.cards.isEmpty
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张手牌与一名距离1以内的已受伤角色"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand]
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in
            self.player.rangeHas(pl, range: 1) && pl.hp < pl.maxHp
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        HPRecover(player: Input.selectedPlayers[0], point: 1).execute()
    }
}

class Wushuang: PlayerSkill{
    override func Setup() {
        name = "无双"
        fangtian = FangtianSkill(player: player, card: nil)
    }
    var fangtian: FangtianSkill! = nil
    override func Update() {
        let has = player.equip.cards.contains{ CardSubType.of($0.name) == .Weapon }
        if has{
            if player.skills.has(fangtian){
                player.skills.remove(fangtian)
            }
        }else{
            if !player.skills.has(fangtian){
                player.skills.append(fangtian)
            }
        }
    }
    var status = 0
    override func canUse() -> Bool {
        if let carduse: CardUse = player.atMoment("指定目标时"){
            if carduse.lCard is Sha{
                status = 1
                return true
            }
            if carduse.lCard is Juedou{
                status = 2
                return true
            }
        }
        if let carduse: CardUse = player.atMoment("成为目标时"), carduse.lCard is Juedou{
            status = 3
            return true
        }
        return false
    }
    override func onUse() {
        let lCard = (Event.current as! CardUse).lCard
        if let sha = lCard as? Sha{
            sha.shanRequired = 2
        }
        if let jd = lCard as? Juedou{
            if status == 2{
                jd.targetShaRequired = 2
            }else{
                jd.userShaRequired = 2
            }
        }
    }
}

class Lijian: PlayerSkill{
    override func Setup() {
        self.name = "离间"
    }
    override func canUse() -> Bool {
        return player.atMoment("出牌阶段") && player.CountCards()>0
    }
    override func preUse() -> Bool {
        Input.Reset(player: player)
        Input.prompt = "选择一张牌，然后选择两名男性角色（先选择【决斗】的使用者）"
        Input.cardNumRange = (1,1)
        Input.selectableCardAreas = [player.hand, player.equip]
        Input.playerNumRange = (2,2)
        Input.playerFilter = {pl in
            if pl.hero.gender != .Male { return false }
            if Input.selectedPlayers.isEmpty{
                return self.player.rangeHas(pl, range: 1) && Juedou(cards: [], user: pl).canUse(checkMoment: false)
            }else{
                return Juedou(cards: [], user: Input.selectedPlayers[0]).canTarget(pl)
            }
        }
        Input.Get()
        return Input.ok
    }
    override func onUse() {
        CardMove(Input.selectedCards, to: .discard).execute()
        let lCard = Juedou(cards: [], user: Input.selectedPlayers[0])
        lCard.targets = [Input.selectedPlayers[1]]
        CardUse(lCard: lCard).execute()
    }
}

class Biyue: PlayerSkill{
    override func Setup() {
        self.name = "闭月"
    }
    override func canUse() -> Bool {
        let ev = Event.current
        if let ev = ev as? Turn, ev.currentMoment == "结束阶段", ev.player === player{
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否发动【闭月】？")
    }
    override func onUse() {
        player.Draw(n: 1)
    }
}

class Hande: PlayerSkill{
    override func Setup() {
        name = "汉德"
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "手牌上限"{
            let target = info as! Player
            if player.rangeHas(target, range: 4){
                if player.team == target.team{
                    return (value as! Int) + 1
                }else{
                    return (value as! Int) - 1
                }
            }
        }
        return value
    }
}

class Tianxing: PlayerSkill{
    override func Setup() {
        name = "天幸"
    }
    override func canUse() -> Bool {
        if let rec: HPRecover = player.atMoment("回复体力后"), rec.currentSkill !== self{
            return true
        }
        return false
    }
    override func onUse() {
        let recover = player.GetBool(prompt: "点确定回复一点体力，点取消摸一张牌")
        if recover{
            HPRecover(player: player, point: 1).execute()
        }else{
            player.Draw(n: 1)
        }
    }
}
