//
//  SelectView.swift
//  TestOld
//
//  Created by William Dong on 2022/3/27.
//

import Foundation
import UIKit

class SelectView: UIView{
    enum State: Int{
        case Idle = 0
        case Selectable
        case Unselectable
        case Selected
    }
    var state: State = .Idle
    var entity: Any? = nil // Card, Player or Grid
    func SetEntity(_ entity: Any){
        if self.entity == nil{
            Tap.on(view: self){ self.Toggle() }
        }
        self.entity = entity
    }
    func SetState(_ newState: State){
        state = newState
        let colors: [UIColor] = [
            .clear,
            .white.withAlphaComponent(0.3),
            .black.withAlphaComponent(0.3),
            .green.withAlphaComponent(0.3),
        ]
        UIView.animate(withDuration: Game.animTime/2){
            self.backgroundColor = colors[self.state.rawValue]
        }
    }
    func Toggle(){
        switch state {
        case .Selectable:
//            SetState(.Selected)
            if !Input.done{
                if let card = entity as? Card{
                    Input.SelectCard(card)
                }
                if let player = entity as? Player{
                    Input.SelectPlayer(player)
                }
                if let grid = entity as? Grid{
                    Input.SelectGrid(grid)
                }
            }
            break
        case .Selected:
//            SetState(.Selectable)
            if !Input.done{
                if let card = entity as? Card{
                    Input.DeselectCard(card)
                }
                if let player = entity as? Player{
                    Input.DeselectPlayer(player)
                }
                if let grid = entity as? Grid{
                    Input.DeselectGrid(grid)
                }
            }
            break
        default:
            break
        }
    }
}

class Tap: NSObject, UIGestureRecognizerDelegate {
    private static var instances: [Tap] = []
    
    private weak var view: UIView?
    private var action: () -> Void
    private var tapGesture: UITapGestureRecognizer
    
    @discardableResult static func on(view: UIView, fires action: @escaping ()->()) -> Tap {
        let tap = Tap(view: view, action: action)
        instances.append(tap)
        instances = instances.filter { $0.view != nil }
        return tap
    }
    
    var isEnabled: Bool {
        set { tapGesture.isEnabled = newValue }
        get { return tapGesture.isEnabled }
    }
    
    private init(view: UIView, action: @escaping () -> Void) {
        self.view = view
        self.action = action
        self.tapGesture = UITapGestureRecognizer()
        
        super.init()
        
        tapGesture.addTarget(self, action: #selector(Tap.onTap(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        view.isUserInteractionEnabled = true
    }
    
    @objc private func onTap(_ gesture: UIGestureRecognizer) {
        if (gesture.state == .ended) {
            fireAction()
        }
    }
    
    private func fireAction() {
        action()
    }
}
