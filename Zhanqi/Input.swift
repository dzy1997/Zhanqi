//
//  Input.swift
//  TestOld
//
//  Created by William Dong on 2021/3/8.
//

import Foundation
import UIKit

extension Int{
    func inRange(_ range: (Int, Int)) -> Bool{
        if self < range.0 { return false }
        if range.1 != -1 && self > range.1 { return false }
        return true
    }
}

class Input { // Input bridges game with UI
    static var player: Player? = nil
    static var prompt: String = "Please input..."
    static var done: Bool = true // thread can proceed
    static var ok: Bool = false // true if confirmed, false on timeout
    static var okFilter: () -> Bool = {true} // whether the player can confirm
    static var autoConfirm: Bool = false
    
    static var selectableCards: [Card] = []
    static var selectableCardAreas: [CardArea] = []
    static var cardNumRange: (Int, Int) = (0,0) // -1 for no upper limit
    static var cardFilter: (Card) -> Bool = {_ in true}
    static var selectedCards: [Card] = []
    static var onSelectCard: (Card) -> Void = {_ in return}
    static var onDeselectCard: (Card) -> Void = {_ in return}
    
    static var playerNumRange: (Int, Int) = (0,0)
    static var playerFilter: (Player) -> Bool = {_ in true}
    static var selectedPlayers: [Player] = []
    static var onSelectPlayer: (Player) -> Void = {_ in return}
    static var onDeselectPlayer: (Player) -> Void = {_ in return}
    
    static var gridNumRange: (Int, Int) = (0,0)
    static var gridFilter: (Grid) -> Bool = {_ in true}
    static var selectedGrids: [Grid] = []
    static var onSelectGrid: (Grid) -> Void = { _ in return }
    static var onDeselectGrid: (Grid) -> Void = { _ in return }
    
    static var choices: [String] = []
    static var choiceNumRange: (Int, Int) = (0,0)
    static var choiceFilter: (Int) -> Bool = {_ in true}
    static var selectedChoices: [Int] = []
    static var onSelectChoice: (Int) -> Void = {_ in return}
    static var onDeselectChoice: (Int) -> Void = {_ in return}
    
    static let inputSem = DispatchSemaphore(value: 0)
    
    static func Reset(player: Player){
        self.player = player
        prompt = "Please input..."
        done = false // thread can proceed
        ok = false // true if confirmed, false on timeout
        okFilter = {true} // whether the player can confirm
        autoConfirm = false
        
        selectableCards = []
        selectableCardAreas = []
        cardNumRange = (0,0) // -1 for no upper limit
        cardFilter = {_ in true}
        selectedCards = []
        onSelectCard = {_ in return}
        onDeselectCard = {_ in return}
        
        playerNumRange = (0,0)
        playerFilter = {_ in true}
        selectedPlayers = []
        onSelectPlayer = {_ in return}
        onDeselectPlayer = {_ in return}
        
        gridNumRange = (0,0)
        gridFilter = {_ in true}
        selectedGrids = []
        onSelectGrid = { _ in return }
        onDeselectGrid = { _ in return }
        
        choices = []
        choiceNumRange = (0,0)
        choiceFilter = {_ in true}
        selectedChoices = []
        onSelectChoice = {_ in return}
        onDeselectChoice = {_ in return}
    }
    
    static func CanConfirm() -> Bool{
        let card = selectedCards.count.inRange(cardNumRange)
        let player = selectedPlayers.count.inRange(playerNumRange)
        let grid = selectedGrids.count.inRange(gridNumRange)
        let choice = selectedChoices.count.inRange(choiceNumRange)
        return card && player && grid && choice && okFilter()
    }
    
    static func Confirm(){
        done = true
        ok = true
        inputSem.signal()
    }
    
    static func Cancel(){
        done = true
        ok = false
        inputSem.signal()
    }
    
    static func Get(){
        let ev = Event.current
        if ev.ended && (ev.nextMoment == "" || ev.currentMoment != ev.nextMoment) {
            done = true
            return
        }
        Game.current.LogText(Event.current.spaces + ">"+prompt)
        Event.WaitForAnim(timeScale: 0.0) {
            Game.current.gameView.EnterInput()
        }
        while !self.done{
            inputSem.wait()
        }
        Event.WaitForAnim(timeScale: 0.0) {
            Game.current.gameView.ExitInput()
        }
    }
    
    static func GetWithAuto(){
        Input.FillDefaultSelection()
        if Input.CanConfirm(){
            Input.Confirm()
        }else{
            print(Event.current.spaces+"<Cancelled>")
            Input.Cancel()
        }
    }
    
    static func UpdateView(){ // update view state using filters
        DispatchQueue.main.async{
            Game.current.gameView.UpdateSelectViews()
        }
    }
    
    static func SelectCard(_ card: Card){
        selectedCards.append(card)
        onSelectCard(card)
        UpdateView()
        AutoConfirm()
    }
    
    static func DeselectCard(_ card: Card){
        selectedCards.remove(card)
        selectedPlayers.removeAll()
        onDeselectCard(card)
        UpdateView()
    }
    
    static func SelectPlayer(_ player: Player){
        selectedPlayers.append(player)
        onSelectPlayer(player)
        UpdateView()
        AutoConfirm()
    }
    
    static func DeselectPlayer(_ player: Player){
        if selectedPlayers.last === player{
            selectedPlayers.removeLast()
        }else{
            selectedPlayers.removeAll()
        }
        onDeselectPlayer(player)
        UpdateView()
    }
    
    static func SelectGrid(_ grid: Grid){
        selectedGrids.append(grid)
        onSelectGrid(grid)
        UpdateView()
        AutoConfirm()
    }
    
    static func DeselectGrid(_ grid: Grid){
        // Special logic here
        while selectedGrids.last !== grid{
            selectedGrids.removeLast()
        }
        selectedGrids.removeLast()
        onDeselectGrid(grid)
        UpdateView()
    }
    
    static func SelectChoice(_ choice: Int){
        selectedChoices.append(choice)
        onSelectChoice(choice)
        UpdateView()
    }
    
    static func DeselectChoice(_ choice: Int){
        selectedChoices.removeAll{ $0 == choice }
        onDeselectChoice(choice)
        UpdateView()
    }
    
    static func AutoConfirm(){
        if autoConfirm, CanConfirm(){
            DispatchQueue.main.asyncAfter(deadline: .now()+Game.animTime){
                self.Confirm()
            }
        }
    }
    
    static func UpdateSelections(){
        while true{
            var removed = false
            while !selectedCards.isEmpty{
                let card = selectedCards.removeLast()
                if !cardFilter(card){
                    removed = true
                }else{
                    selectedCards.append(card)
                    break
                }
            }
            while !selectedPlayers.isEmpty{
                let player = selectedPlayers.removeLast()
                if !playerFilter(player){
                    removed = true
                }else{
                    selectedPlayers.append(player)
                    break
                }
            }
            while !selectedGrids.isEmpty{
                let grid = selectedGrids.removeLast()
                if !gridFilter(grid){
                    removed = true
                }else{
                    selectedGrids.append(grid)
                    break
                }
            }
            while !selectedChoices.isEmpty{
                let choice = selectedChoices.removeLast()
                if !choiceFilter(choice){
                    removed = true
                }else{
                    selectedChoices.append(choice)
                    break
                }
            }
            if !removed { break }
        }
    }
    
    static var randomSelect = true
    static var validCards: [Card]{
        if selectedCards.count == cardNumRange.1 { return [] }
        var cards = selectableCards
        for area in selectableCardAreas{
            cards += area.cards
        }
        cards = cards.filter{ card in !selectedCards.has(card) && cardFilter(card) }
        return cards
    }
    static var validPlayers: [Player] {
        if selectedPlayers.count == playerNumRange.1 { return [] }
        let players = Game.current.players.filter{pl in
            !selectedPlayers.has(pl) && playerFilter(pl)
        }
        return players
    }
    static var validGrids: [Grid] {
        if selectedGrids.count == gridNumRange.1 { return [] }
        let grids = Game.current.map.grids.filter{grid in
            !selectedGrids.has(grid) && gridFilter(grid)
        }
        return grids
    }
    
    static func SelectRandomCard() -> Bool{
        let cards = validCards
        if cards.isEmpty{ return false }
        SelectCard(randomSelect ? cards.randomElement()! : cards[0])
        return true
    }
    
    static func SelectRandomPlayer() -> Bool{
        let players = validPlayers
        if players.isEmpty { return false }
        SelectPlayer(randomSelect ? players.randomElement()! : players[0])
        return true
    }
    
    static func SelectRandomGrid() -> Bool{
        let grids = validGrids
        if grids.isEmpty { return false }
        SelectGrid(randomSelect ? grids.randomElement()! : grids[0])
        return true
    }
    
    static func SelectRandomChoice() -> Bool{
        let chs = Array(0..<Input.choices.count).filter{ch in
            !selectedChoices.contains(ch) && choiceFilter(ch)
        }
        if chs.isEmpty { return false }
        SelectChoice(randomSelect ? chs.randomElement()! : chs[0])
        return true
    }
    
    static func PrintSelection(){
        var s = ">Selected: "
        for c in Input.selectedCards{
            s += "\(c._suit.symbol)\(c._rank)\(c.name),"
        }
        for pl in Input.selectedPlayers{
            s += pl.hero.name + ","
        }
        for gr in Input.selectedGrids{
            s += "\(gr.position.0)-\(gr.position.1)\(gr.name),"
        }
        for ch in Input.selectedChoices{
            s += "\(ch)-\(Input.choices[ch]),"
        }
        print(Event.current.spaces + s)
    }
    
    static func FillDefaultSelection(){
        var cards = Input.selectableCards
        for area in Input.selectableCardAreas{
            cards += area.cards
        }
        while true{
            let card = Input.selectedCards.count >= Input.cardNumRange.1
            let player = Input.selectedPlayers.count >= Input.playerNumRange.1
            let grid = Input.selectedGrids.count >= Input.gridNumRange.1
            let choice = Input.selectedChoices.count >= Input.choiceNumRange.0
            let result = card && player && grid && choice
            if result {break}
            if !card{
                if Input.SelectRandomCard(){
                    continue
                }
            }
            if !player{
                if Input.SelectRandomPlayer(){
                    continue
                }
            }
            if !grid{
                if Input.SelectRandomGrid(){
                    continue
                }
            }
            if !choice{
                if Input.SelectRandomChoice(){
                    continue
                }
            }
            break
        }
        PrintSelection()
    }
}

extension Player{ // Input utility functions
    func GetBool(prompt: String = "请确认") -> Bool{
        Input.Reset(player: self)
        Input.prompt = prompt
        Input.Get()
        return Input.ok
    }
    
    func GetChoice(choices: [String], prompt: String = "请选择") -> Int{
        Input.Reset(player: self)
        Input.prompt = prompt
        Input.choices = choices
        Input.choiceNumRange = (1,1)
        Input.Get()
        return Input.ok ? Input.selectedChoices[0] : 0
    }
    
    func GetPlayer(players: [Player], prompt: String = "请选择一名角色") -> Player{
        Input.Reset(player: self)
        Input.prompt = prompt
        Input.playerNumRange = (1,1)
        Input.playerFilter = { pl in players.has(pl) }
        Input.Get()
        return Input.ok ? Input.selectedPlayers[0] : players[0]
    }
}
