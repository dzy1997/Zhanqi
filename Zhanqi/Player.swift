//
//  Player.swift
//  TestOld
//
//  Created by William Dong on 2021/4/17.
//

import Foundation

class Player {
    static var currentTurnID: Int{
        return 0
    }
    var id: Int = 0
    var team: Int = 0
    var turnExecuted: Bool = false
    
    var hero: Hero = Hero()
    var skills: [PlayerSkill] = []
    
    var alive: Bool = true
    var hp: Int = 4
    var maxHp: Int = 4
    var movePoint: Int = 0
    
    var grid: Grid = Grid.dummy
    var position: (Int, Int){
        return grid.position
    }
    
    var hand: CardArea
    var equip: CardArea
    var yield: CardArea
    
    var shaUsed: Int = 0
    var shaMax: Int = 1
    
    init() {
        hand = CardArea(type: .Hand)
        equip = CardArea(type: .Equip)
        yield = CardArea(type: .Yield)
        hand.owner = self
        equip.owner = self
        yield.owner = self
    }
    
    func distanceTo(_ other: Player) -> Int{
        let g1 = self.grid
        let g2 = other.grid
        if (g1.isDummy || g2.isDummy) { return -1 }
        return g1.distanceTo(grid: g2)
    }
    
    func rangeHas(_ other:Player, range:Int) -> Bool{
        let dist = self.distanceTo(other)
        if dist == -1 {return false}
        return dist <= range
    }
    
    func attackRange() -> Int{
        var range = 1
        for sk in self.skills{
            if let sk = sk as? WeaponSkill{
                if sk.enabled{
                    range = sk.attackRange
                }
                break
            }
        }
        range = Game.Compute(name: "攻击范围", value: range, info: self)
        return range
    }
    
    func canMoveTo(grid: Grid) -> Bool{
        var canMove = false
        let dir = Direction.fromVector(self.grid.vectorTo(grid: grid))
        if dir != .None{
            var border = !self.grid.whiteBorders.contains(dir) && !grid.whiteBorders.contains(dir.inverse)
            border = Game.Compute(name: "移动边界合法性", value: border, info: (self,grid))
            canMove = border
        }
        canMove = Game.Compute(name: "移动合法性", value: canMove, info: (self,grid))
        return canMove
    }
    
    func canStay(grid: Grid, passBy:Bool = false) -> Bool{
        let game = Game.current
        let canstay = grid.whiteBorders.count < 4
        var noPeople = !game.players.contains{pl in pl.grid === grid}
        noPeople = Game.Compute(name: "停留无人合法性", value: noPeople, info: (self, grid, passBy))
        var result = canstay && noPeople
        result = Game.Compute(name: "停留合法性", value: result, info: (self, grid, passBy))
        return result
    }
}

extension Player{
    func Draw(n: Int){
        let game = Game.current
        game.RequireDeck(n: n)
        let cards = game.deck.GetCards(n: n)
        CardMove(cards, to: self.hand).execute()
    }
    
    func CountCards(hand: Bool = true, equip: Bool = true, yield: Bool = false) -> Int{
        var i = 0
        if hand{
            i += self.hand.cards.count
        }
        if equip{
            i += self.equip.cards.count
        }
        if yield{
            i += self.yield.cards.count
        }
        return i
    }
    
    func ShowCards(cards: [Card]){
        let cs = cards.map{ c in c.toStr() }
        Game.current.LogText(Event.current.spaces+"\(hero.name)展示了\(cs)")
        Event.WaitForAnim {
            Game.current.gameView.AnimateShowCards(player: self, cards: cards)
        }
    }
    
    func atMoment<T: Event>(_ name: String, global: Bool = false) -> T?{
        let ev = Event.current
        if ev.currentMoment == name, global || ev.momentPlayer === self, let ev = ev as? T{
            return ev
        }
        return nil
    }
    func atMoment(_ name: String, global: Bool = false) -> Bool{
        let ev = Event.current
        if ev.currentMoment == name, global || ev.momentPlayer === self{
            return true
        }
        return false
    }
    
    func canUseCard() -> Bool{ // if a card is asked as input
        if hand.cards.isEmpty { return false }
        if self.atMoment("出牌阶段") { return true }
        let ev = Event.current
        let name = ev.currentMoment
        if name == "需要使用牌时"{
            return (ev as! CardNeedUseEvent).player === self
        }
        // TODO: make a more general definition
        if name == "牌对目标生效前"{
            let ev = ev as! CardEffect
            if ev.lCard is Sha{
                return ev.currentTarget === self
            }else{
                return ev.lCard.type == .Spell
            }
        }
        if name == "处于濒死状态时"{
            let player = (ev as! Dying).player
            return player.rangeHas(self, range: 4)
        }
//        for cardClass in [Shan.self, Tao.self, Wuxie.self] {
//            let lCard = cardClass.init(cards: [], user: self)
//            lCard.abstract = true
//            if lCard.canUse(){
//                return true
//            }
//        }
        return false
    }
    
    func canPlayCard() -> Bool{
        let ev = Event.current
        let name = ev.currentMoment
        if name == "需要打出牌时"{
            return (ev as! CardNeedPlay).player === self
        }
        return false
    }
    
    func getSkills(type:SkillType = .None)->[PlayerSkill]{
        var allSkills = self.skills + hero.skills
        if type != .None{
            allSkills = allSkills.filter{sk in sk.type == type}
        }
        return allSkills
    }
}
