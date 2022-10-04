//
//  Game.swift
//  TestOld
//
//  Created by William Dong on 2021/2/24.
//

import Foundation

let heroAll = heroStandard
let heroSkillAll = heroSkillStandard
let cardAll = cardStandard
let deckAll = deckStandard
let equipSkillAll = cardSkillStandard
let mapAll = [mapStandard]
let gridSkillAll = gridSkillStandard

let defaultHeros = ["刘备","甘宁","赵云","诸葛亮","关羽","大乔"]

class Game {
    static var current: Game = Game()
    static var animTime: Double{
        if let gev = Event.ofType(GameEvent.self), gev.gameStarted{
            return 0.2
        }
        return 0.0
    }
    var gameView: GameView!
    
    var roundCount: Int = 0
    var players: [Player] = []
    var currentTurnPlayer: Player{
        if let turn = Event.ofType(Turn.self){
            return turn.player
        }
        return players[0]
    }
    
    var teamScores: [Int] = [0, 0]
    var teamLeaders: [Player] // 最后拥有过旗的角色
    
    var map: Map = Map(name: "yezhan")
    var flagPositions: [(Int, Int)] = [(7,1), (1,7)]
    var flagOwners: [Player?] = [nil, nil]
    
    var deck = CardArea(type: .Deck) // fill with 52*2+4=108 cards
    var discard = CardArea(type: .Discard)
    var handle = CardArea(type: .Handle)// 处理区
    var outside = CardArea(type: .Outside)
    
    var skills: [Skill] = []
    
    var yieldLogicCardMap: [Int:LogicCard] = [:] // card id to logic card
    
    func getAllSkills(type: SkillType = .None, globalOnly: Bool = false)->[Skill]{
        var skills = skills + map.skills
        if !globalOnly{
            for pl in players{
                skills = skills + pl.getSkills()
            }
        }
        if type != .None{
            skills = skills.filter{sk in sk.type == type}
        }
        return skills
    }
    
    var skillsUpToDate: Bool = false
    func updateAllSkills(){
        if skillsUpToDate { return }
        skillsUpToDate = true
        for sk in getAllSkills(){
            sk.enabled = true
        }
        for sk in getAllSkills(){
            sk.Update()
        }
    }
    
    func RequireDeck(n: Int){ // 如摸牌，观星
        if deck.cards.count < n{
            if deck.cards.count + discard.cards.count < n{
                Event.ofType(GameEvent.self)!.End()
                print("游戏结束，平局")
            }else{
                CardMove(Game.current.discard.cards, to: .deck).execute()
                deck.cards.shuffle()
            }
        }
    }
    
    var cardsToShow: [Card] = []
    var showingCards: [Card] = []
    
    init() {
        for i in 0..<6{
            let player = Player()
            player.id = i
            player.team = i<3 ? 0 : 1
            players.append(player)
        }
        flagOwners = [players[0], players[3]]
        teamLeaders = [players[0], players[3]]
        var i = 0
        for (suit, rank, name) in deckAll{
            let card = Card()
            card._suit = suit
            card._rank = rank
            card._name = name
            card.id = i
            card.area = deck
            deck.cards.append(card)
            i += 1
        }
        deck.cards.shuffle()
    }
    
    func setHeros(_ names: [String]){
        for i in 0..<6{
            let player = players[i]
            player.hero.SetHero(name: names[i], player: player)
            player.maxHp = player.hero.maxHp
            player.hp = player.hero.startHp
        }
    }
    
    static func Compute<T>(name: String, value: T, info: Any) -> T{
        var value = value
        // update: 添加/删除视为拥有的技能，更改技能的有效性
        Game.current.updateAllSkills()
        let levels: [SkillType] = [.Game, .Card, .Equip, .Hero, .Map]
        for level in levels{
            let skills = Game.current.getAllSkills(type: level).filter{ $0.enabled }
            for sk in skills{
                sk.enabled = false
                value = sk.Mod(name: name, value: value, info: info) as! T
                sk.enabled = true
            }
        }
        return value
    }
    
    func LogText(_ line: String){
        print(line)
        DispatchQueue.main.async {
            let tv = self.gameView.logTextView!
            tv.text += line + "\n"
            let range = NSMakeRange(tv.text.count - 1, 0)
            tv.scrollRangeToVisible(range)
        }
    }
    
    func fullInfo() -> String{
        var s = ""
        for pl in players{
            s += "\(pl.hero.name)("
            for sk in pl.getSkills(){
                s += sk.name + ", "
            }
            s += "):"
            for c in pl.hand.cards{
                s += c.toStr() + ", "
            }
            if let c = pl.yield.cards.first{
                s += c.toStr() + "(延时区)"
            }
            s += "\n"
        }
        s += "处理区\(handle.cards.count)："
        for c in handle.cards{
            s += c.toStr() + ", "
        }
        s += "\n"
        s += "牌堆\(deck.cards.count)："
        let n = min(deck.cards.count, 10)
        for i in 0..<n{
            s += deck.cards[i].toStr() + ", "
        }
        s += "\n"
        s += "弃牌堆\(discard.cards.count)："
        let n1 = min(discard.cards.count, 10)
        for i in 0..<n1{
            s += discard.cards[i].toStr() + ", "
        }
        s += "\n"
        return s
    }
}
