//
//  MapView.swift
//  TestOld
//
//  Created by William Dong on 2022/3/25.
//

import Foundation
import UIKit

class GridView: UIView{
    var grid: Grid
    var label: UILabel!
    var selectView: SelectView!
    init(frame: CGRect, grid: Grid){
        self.grid = grid
        super.init(frame: frame)
        self.backgroundColor = .clear
        label = UILabel.create()
        label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        label.text = grid.name
        addSubview(label)
        selectView = SelectView(frame: bounds)
        selectView.SetEntity(grid)
        addSubview(selectView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let p1 = CGPoint(x: 0, y: 0)
        let p2 = CGPoint(x: bounds.width, y: 0)
        let p3 = CGPoint(x: bounds.width, y: bounds.height)
        let p4 = CGPoint(x: 0, y: bounds.height)
        let segments:[Direction:(CGPoint, CGPoint)] = [
            .Left : (p1, p4),
            .Right : (p2, p3),
            .Up : (p1, p2),
            .Down : (p3, p4),
        ]
        let border = UIBezierPath(rect: rect)
        UIColor.gray.setStroke()
        border.stroke()
        for dir in grid.whiteBorders{
            let seg = segments[dir]!
            let path = UIBezierPath()
            path.move(to: seg.0)
            path.addLine(to: seg.1)
            path.lineWidth = 3.0
            UIColor.white.setStroke()
            path.stroke()
        }
    }
    func Update(){
        var s = grid.name
        let game = Game.current
        for i in [0,1]{
            if game.flagOwners[i] == nil, game.flagPositions[i] == grid.position{
                s += "⚑"
            }
        }
        label.text = s
    }
}

class MapView: UIView{
    var map: Map
    var unitLength: CGFloat = 0
    var gridViews: [GridView] = []
    var chessViews: [ChessView] = []
    init(frame: CGRect, map: Map){
        self.map = map
        super.init(frame: frame)
        let w = frame.width, h = frame.height
        unitLength = (min(w, h) * 0.9 / 7).rounded()
        // background image
        let img = UIImage(named: "realmap")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleToFill
        imgView.frame = CGRect(x: w/2-unitLength*3.5, y: h/2-unitLength*3.5, width: unitLength * 7, height: unitLength * 7)
        addSubview(imgView)
        for i in 1...7{
            for j in 1...7{
                let x = w/2 + (CGFloat(j)-4.5) * unitLength
                let y = h/2 + (CGFloat(i)-4.5) * unitLength
                let f = CGRect(x: x, y: y, width: unitLength, height: unitLength)
                let gridView = GridView(frame: f, grid: map.getGrid(at: (i,j))!)
                addSubview(gridView)
                gridViews.append(gridView)
            }
        }
        for player in Game.current.players{
            let chessBound = CGRect(x: 0, y: 0, width: unitLength, height: unitLength)
            let chessView = ChessView(frame: chessBound, player: player)
            chessView.alpha = 0.0
            chessViews.append(chessView)
            addSubview(chessView)
        }
        for player in Game.current.players{
            UpdateChess(player: player)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func GetGridView(position: (Int, Int)) -> GridView{
        let i = position.0, j = position.1 // 第i行,第j列
        return gridViews[(i-1)*7+(j-1)]
    }
    func UpdateChess(player: Player){
        let chessView = chessViews[player.id]
        bringSubviewToFront(chessView)
        let pos = chessView.player.position
        if pos == (0,0){ // dummy grid
            if chessView.alpha == 1.0{
                UIView.animate(withDuration: Game.animTime){
                    chessView.alpha = 0.0
                }
            }
        }else{
            let x = self.bounds.width/2+CGFloat(pos.1-4)*self.unitLength
            let y = self.bounds.height/2+CGFloat(pos.0-4)*self.unitLength
            let p = CGPoint(x: x, y: y)
            if chessView.alpha == 0.0{
                chessView.center = p
                UIView.animate(withDuration: Game.animTime){
                    chessView.alpha = 1.0
                }
            }else{
                UIView.animate(withDuration: Game.animTime){
                    chessView.center = p
                    self.GetGridView(position: pos).Update()
                }
            }
        }
    }
    func Update(){
        for view in gridViews{
            view.Update()
        }
        for player in Game.current.players{
            UpdateChess(player: player)
        }
    }
}

class ChessView: UIView{
    var player: Player
    var selectView: SelectView!
    init(frame: CGRect, player: Player){
        self.player = player
        super.init(frame: frame)
        let img = UIImage(named: "liubei_head")
        let imgView = UIImageView(image: img)
        imgView.frame = bounds
        imgView.contentMode = .scaleToFill
        addSubview(imgView)
        let label = UILabel.create()
        label.frame = bounds
        label.text = player.hero.name
        label.textColor = .black
        label.backgroundColor = .white.withAlphaComponent(0.5)
        addSubview(label)
        // custom selectView
        selectView = SelectView(frame: bounds)
        selectView.entity = player
        Tap.on(view: selectView){
            if !Input.done && Input.gridNumRange != (0,0){
                if Input.validGrids.has(player.grid){
                    Input.SelectGrid(player.grid)
                }else if Input.selectedGrids.has(player.grid){
                    Input.DeselectGrid(player.grid)
                }
            }else{
                self.selectView.Toggle()
            }
        }
        addSubview(selectView)
        // Circle mask
        var mask = UIImageView(image: UIImage(named: "circlemask"))
        if #available(iOS 13.0, *) {
            mask = UIImageView(image: UIImage(systemName: "circle.fill"))
        }
        mask.frame = imgView.frame
        self.mask = mask
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
