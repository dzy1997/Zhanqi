//
//  Skill.swift
//  TestOld
//
//  Created by William Dong on 2021/3/6.
//

import Foundation

enum SkillType {
    case None
    case Game
    case Card
    case Equip
    case Hero
    case Map
}

class Skill{
    var name: String = "技能名"
    var type: SkillType = .Hero
    var enabled: Bool = true // 用于临时屏蔽技能
    var reusable: Bool = false // 可多次触发（如遗计，枭姬）或多次使用（如仁德，苦肉）
    init(){
        Setup()
    }
    func Setup(){
        
    }
    func Update(){
        
    }
    func Mod(name: String, value: Any, info: Any) -> Any{
        return value
    }
    func canUse() -> Bool{
        return false
    }
    func preUse() -> Bool{
        // run preprocess and return false if cancelled
        return true
    }
    func onUse(){
        
    }
    func Use(){
        let game = Game.current
        let ev = Event.current
        let owner = (self as? PlayerSkill)?.player.hero.name ?? ""
        let des = "\(owner)发动【\(name)】"
        let line = ev.spaces + des
        game.LogText(line)
        ev.currentSkill = self
        onUse()
        ev.currentSkill = nil
        game.LogText(line+"结束")
    }
}


class PlayerSkill:Skill{
    var player: Player
    required init(player: Player){
        self.player = player
        super.init()
    }
}

class GridSkill: PlayerSkill{
    required init(player: Player) {
        super.init(player: player)
        type = .Map
    }
}

class EquipSkill: PlayerSkill{
    var card: Card? = nil
    var equipSubtype: CardSubType = .None // 神戟无对应牌，需要此变量记录类型
    required init(player: Player, card: Card?){
        self.card = card
        super.init(player: player)
        type = .Equip
    }
    convenience required init(player: Player) {
        self.init(player: player)
    }
}

class WeaponSkill: EquipSkill{
    var attackRange: Int = 0
    required init(player: Player, card: Card? = nil) {
        super.init(player: player, card: card)
        equipSubtype = .Weapon
    }
    convenience required init(player: Player) {
        self.init(player: player)
    }
}
