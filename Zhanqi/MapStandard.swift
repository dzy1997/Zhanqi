//
//  MapStandard.swift
//  TestOld
//
//  Created by William Dong on 2022/3/19.
//

import Foundation

// 地图规则，1-index(行,列)，左上为(1,1)，左下为(7,1)，暖方为0冷方为1，暖方012冷方345
let mapStandard:[[String]] = [
    ["驿站", "平原", "树林", "山岭", "平原", "军营", "大本营"],
    ["平原", "平原", "树林", "湖泊", "树林", "平原", "军营"],
    ["树林", "平原", "山岭", "平原", "平原", "箭塔", "平原"],
    ["平原", "山岭", "湖泊", "平原", "湖泊", "山岭", "平原"],
    ["平原", "箭塔", "平原", "平原", "山岭", "平原", "树林"],
    ["军营", "平原", "树林", "湖泊", "树林", "平原", "平原"],
    ["大本营", "军营", "平原", "山岭", "树林", "平原", "驿站"],
]

let gridSkillStandard: [String: GridSkill.Type] = [
    "大本营": Camp.self,
    "军营": Camp.self,
    "平原": Plain.self,
    "山岭": Plain.self,
    "湖泊": Lake.self,
    "驿站": Post.self,
    "箭塔": Tower.self,
    "树林": Woods.self,
]

class Camp: GridSkill{
    override func Setup() {
        name = "军营"
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "停留无人合法性"{
            let (_, grid, _) = info as! (Player, Grid, Bool)
            if grid === self.player.grid{
                return true
            }
        }
        return value
    }
}

class Plain: GridSkill{ // TODO: rename to empty placeholder
    override func Setup() {
        name = "空地形"
    }
}

class Lake: GridSkill{
    override func Setup() {
        name = "湖泊"
    }
    var status: Int = 0
    override func canUse() -> Bool {
        let name = Event.current.currentMoment
        status = 0
        if name == "回合结束时", (Event.current as! Turn).player === player{
            status = 1
        }
        if name == "摸牌阶段开始前", (Event.current as! Turn).player === player{
            status = 2
        }
        return status > 0
    }
    override func onUse() {
        if status == 1{
            HPRecover(player: player, point: 1).execute()
        }
        if status == 2{
            (Event.current as! Turn).skipDraw = true
        }
    }
}

class Post: GridSkill{
    override func Setup() {
        name = "驿站"
    }
    
    override func canUse() -> Bool {
        let ev = Event.current
        if ev.currentMoment == "结束阶段", (ev as! Turn).player === player{
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return player.GetBool(prompt: "是否观看牌堆顶一张牌并交给任意角色？")
    }
    override func onUse() {
        Game.current.RequireDeck(n: 1)
        let card = Game.current.deck.cards.first!
        CardMove([card], to: .handle, front: true, visibleTo: [player]).execute()
        Input.Reset(player: player)
        Input.selectableCards = [card]
        Input.playerNumRange = (1,1)
        Input.prompt = "选择一名角色获得此牌"
        Input.Get()
        let player = Input.ok ? Input.selectedPlayers[0] : player
        CardMove([card], to: player.hand).execute()
    }
}

class Woods: GridSkill{
    override func Setup() {
        name = "树林"
    }
    var status = 0
    override func canUse() -> Bool {
        let shan = Shan(cards: [], user: player)
        if shan.canUse(){
            status = 1
            return true
        }
        if shan.canPlay(){
            status = 2
            return true
        }
        if let dam: Damage = player.atMoment("受到伤害时"), dam.isFire{
            status = 3
            return true
        }
        return false
    }
    override func preUse() -> Bool {
        return status == 3 ? true : player.GetBool(prompt: "是否发动【树林】？")
    }
    override func onUse() {
        let status = status
        if status == 3{
            let ev = Event.current as! Damage
            ev.point += 1
        }
        else{
            let ev = Judge(player: player)
            ev.execute()
            if ev.resultSuit == .Heart{
                let shan = Shan(cards: [], user: player)
                if status == 1{
                    CardUse(lCard: shan).execute()
                }else{
                    CardPlay(logicCard: shan).execute()
                }
            }
        }
    }
}

class Tower: GridSkill{
    override func Setup() {
        name = "箭塔"
    }
    var firstSha = true
    override func Update() {
        let ev = Event.current
        if ev.currentMoment == "出牌阶段开始时"{
            firstSha = true
        }
        if ev.currentMoment == "使用牌时" && firstSha{
            let ev = ev as! CardUse
            if ev.lCard is Sha, ev.lCard.user === player{
                firstSha = false
            }
        }
        for sk in player.skills{
            if let sk = sk as? EquipSkill, sk.equipSubtype == .Weapon{
                sk.enabled = false
            }
        }
    }
    override func Mod(name: String, value: Any, info: Any) -> Any {
        if name == "牌目标距离合法性" && firstSha{
            let (lCard, target) = info as! (LogicCard, Player)
            if lCard is Sha, lCard.user === player{
                if player.skills.contains(where: { $0 is WeaponSkill }){
                    return true
                }else{
                    return player.grid.onLineWith(grid: target.grid)
                }
            }
        }
        return value
    }
}
