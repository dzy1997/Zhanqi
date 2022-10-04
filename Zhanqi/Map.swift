//
//  Map.swift
//  TestOld
//
//  Created by William Dong on 2021/3/22.
//

import Foundation
import UIKit

enum Direction: Int{
    case None
    case Left
    case Right
    case Up
    case Down
    
    static func fromVector(_ pair: (Int, Int)) -> Direction{
        if pair == (-1, 0) {return .Left}
        if pair == (1, 0) {return .Right}
        if pair == (0, -1) {return .Up}
        if pair == (0, 1) {return .Down}
        return .None
    }
    func toVector() -> (Int, Int){
        if self == .Left { return (-1, 0) }
        if self == .Right { return (1, 0) }
        if self == .Up { return (0, -1) }
        if self == .Down { return (0, 1) }
        return (0,0)
    }
    var inverse: Direction{
        if self == .Left { return .Right }
        if self == .Right { return .Left }
        if self == .Up { return .Down }
        if self == .Down { return .Up }
        return .None
    }
}

class Grid {
    static let dummy = Grid()
    var position: (Int, Int) = (0,0)
    var isDummy: Bool { return position.0==0 && position.1==0 }
    var name: String = "地形名"
    var whiteBorders: [Direction] = [] // left (-1,0), right (1,0), up (0,-1), down (0,1)
    init() {
        
    }
    var players: [Player]{
        return Game.current.players.filter{pl in pl.grid === self}
    }
    func vectorTo(grid: Grid) -> (Int, Int){
        let p1 = position
        let p2 = grid.position
        return (p2.0-p1.0, p2.1-p1.1)
    }
    func distanceTo(grid: Grid) -> Int{
        if (self.isDummy || grid.isDummy) {return -1}
        let vec = vectorTo(grid: grid)
        return abs(vec.0) + abs(vec.1)
    }
    func onLineWith(grid: Grid) -> Bool{
        let p1 = position
        let p2 = grid.position
        return p1.0 == p2.0 || p1.1 == p2.1
    }
    func neighbor(on dir:Direction) -> Grid?{
        if dir != .None{
            let vec = dir.toVector()
            let pos = self.position
            let pos1 = (pos.0+vec.0, pos.1+vec.1)
            return Game.current.map.getGrid(at: pos1)
        }
        return nil
    }
    func createGridSkill(player: Player) -> GridSkill{
        return gridSkillAll[name]!.init(player: player)
    }
}

class Map{
    var name: String = ""
    var grids: [Grid] = []
    var skills: [Skill] = []
    var campPositions: [(Int, Int)] = [(7,1),(6,1),(7,2),(1,7),(1,6),(2,7)]
    init(name: String = "野战"){
        self.name = name
        for i in 1...7{
            for j in 1...7{
                let grid = Grid()
                grid.position = (i,j)
                grid.name = mapStandard[i-1][j-1]
                if grid.name == "山岭"{
                    grid.whiteBorders = [.Left, .Right, .Up, .Down]
                }
                grids.append(grid)
            }
        }
    }
    func getGrid(at pos: (Int,Int)) -> Grid? {
        if 1<=pos.0 && pos.0<=7 && 1<=pos.1 && pos.1<=7{
            return grids[7*(pos.0-1)+pos.1-1]
        }
        return nil
    }
    func baseCampPos(team: Int) -> (Int, Int){
        return campPositions[team == 0 ? 0 : 3]
    }
    func campGrids(team: Int) -> [Grid]{
        let range = team == 0 ? 0..<3 : 3..<6
        var grids: [Grid] = []
        for i in range{
            grids.append(getGrid(at: campPositions[i])!)
        }
        return grids
    }
}

extension Map{
    class func StepDirection(from g1: Grid, to g2: Grid) -> Direction{
        // 相邻且无白边
        let p1 = g1.position
        let p2 = g2.position
        if p1.0 == p2.0 && p2.1 == p1.1-1{ // left
            return .Left
        }
        if p1.0 == p2.0 && p2.1 == p1.1+1{ // right
            return .Right
        }
        if p1.0 == p2.0+1 && p2.1 == p1.1{ // up
            return .Up
        }
        if p1.0 == p2.0-1 && p2.1 == p1.1{ // down
            return .Down
        }
        return .None
    }
    
    class func noPeople(player:Player, grid: Grid) -> Bool{
        for pl in Game.current.players{
            if pl !== player && pl.position == grid.position{
                return false
            }
        }
        return true
    }
}

class Move: Event{
    var player: Player
    var controller: Player
    var grids: [Grid]
    var distRange: (Int, Int)
    var useMovePoint: Bool = false
    var stepsDone: Int = 0
    init(player: Player, distRange: (Int,Int), controller: Player? = nil, grids: [Grid] = []) {
        self.player = player
        self.distRange = distRange
        self.controller = controller ?? player
        self.grids = grids
    }
    override func toStr() -> String {
        return "\(player.hero.name)移动"
    }
    override func process() {
        if grids.isEmpty{
            Input.Reset(player: player)
            Input.prompt = "请选择移动路径"
            Input.gridNumRange = distRange
            Input.gridFilter = {grid in
                let curGrid = self.player.grid
                let fromGrid = Input.selectedGrids.last ?? curGrid
                self.player.grid = fromGrid
                let move = self.player.canMoveTo(grid: grid)
                self.player.grid = curGrid
                let stay = self.player.canStay(grid: grid, passBy: true)
                return move && stay
            }
            Input.okFilter = {
                if let grid = Input.selectedGrids.last{
                    return self.player.canStay(grid: grid)
                }else{
                    return true
                }
            }
            Input.Get()
            if Input.ok{
                self.grids = Input.selectedGrids
            }
        }
        InvokeMoment("移动开始时", player)
        for i in 0..<grids.count{
            Displace(player: player, to: grids[i]).execute()
            stepsDone += 1
            if useMovePoint { player.movePoint -= 1 }
            if ended { break }
        }
        InvokeMoment("移动结束时", player)
    }
}

class Displace: Event{
    var player: Player
    var gridFrom: Grid
    var gridTo: Grid
    var useMovePoint: Bool = false
    var direction: Direction{
        let vec = gridFrom.vectorTo(grid: gridTo)
        return Direction.fromVector(vec)
    }
    init(player: Player, to gridTo: Grid) {
        self.player = player
        self.gridFrom = player.grid
        self.gridTo = gridTo
    }
    override func toStr() -> String {
        "\(player.hero.name)位移到\(gridTo.position)"
    }
    func HandleFlagAndSkill(){
        let game = Game.current
        // Capture the flag
        let team = player.team
        if game.flagOwners[team] == nil{
            let playerPos = player.grid.position
            let flagPos = game.flagPositions[team]
            if playerPos == flagPos{
                game.flagOwners[team] = player
            }
        }
        // Move the flag with player
        if game.flagOwners[team] === player{
            game.flagPositions[team] = player.grid.position
        }
        // Deliver the flag
        if game.flagPositions[team] == game.map.baseCampPos(team: 1-team){
            game.flagPositions[team] = game.map.baseCampPos(team: team)
            game.flagOwners[team] = nil
            Score(team: team, point: 5).execute()
        }
        // remove grid skill
        for sk in player.skills{
            if sk.type == .Map{
                player.skills.remove(sk)
            }
        }
        // add grid skill
        if !gridTo.isDummy{
            let sk = gridTo.createGridSkill(player: player)
            player.skills.append(sk)
        }
    }
    override func process() {
        InvokeMoment("离开地形时", player)
        player.grid = gridTo
        HandleFlagAndSkill()
        Event.WaitForAnim {
            Game.current.gameView.mapView.UpdateChess(player: self.player)
            Game.current.gameView.playerViews[self.player.id].Update()
        }
        InvokeMoment("进入地形时", player)
    }
}

class SwitchDisplace: Displace{
    var players: [Player]
    init(players: [Player]){
        self.players = players
        super.init(player: players[0], to: players[1].grid)
    }
    override func process() {
        let grids:[Grid] = [players[0].grid, players[1].grid]
        
        player = players[0]
        gridTo = grids[0]
        InvokeMoment("离开地形时", player)
        
        player = players[1]
        gridTo = grids[1]
        InvokeMoment("离开地形时", player)
        
        players[0].grid = grids[1]
        players[1].grid = grids[0]
        
        Event.WaitForAnim {
            Game.current.gameView.mapView.UpdateChess(player: self.players[0])
            Game.current.gameView.mapView.UpdateChess(player: self.players[1])
        }
        
        player = players[0]
        gridTo = grids[1]
        HandleFlagAndSkill()
        InvokeMoment("进入地形时", player)
        
        player = players[1]
        gridTo = grids[0]
        HandleFlagAndSkill()
        InvokeMoment("进入地形时", player)
    }
}
