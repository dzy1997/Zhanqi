//
//  ViewController.swift
//  TestOld
//
//  Created by William Dong on 2021/1/2.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet var yesButton: UIButton?
    @IBOutlet var heroButtons: [UIButton] = []
    @IBOutlet var selectHeroButtons: [UIButton] = []
    @IBOutlet var heroPickerView: UIPickerView!
    var heroAllNames: [String] = []
    var activeHeroButton: UIButton? = nil
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
    
    override func viewDidLoad() {
        heroAllNames = heroAll.keys.sorted()
        heroPickerView.delegate = self
        heroPickerView.dataSource = self
        heroPickerView.alpha = 0.0
        for i in 0..<6{
            let name = defaultHeros[i]
            heroButtons[i].setTitle(name, for: .normal)
        }
//        for i in 0..<6{
//            let button = heroButtons[i]
//            button.showsMenuAsPrimaryAction = true
//            if #available(iOS 15.0, *) {
//                button.changesSelectionAsPrimaryAction = true
//            }
//            let children: [UIAction] = names.map{ name in
//                UIAction(title: name,
//                         state: name == defaultHeros[i] ? .on : .off,
//                         handler: {_ in return})
//            }
//            button.menu = UIMenu(children: children)
//        }
        ResetSelect()
    }
    
    @IBAction func PickHero(_ sender: UIButton){
        activeHeroButton = sender
        heroPickerView.alpha = 1.0
        heroPickerView.center = sender.center
        var idx = 0
        let name = sender.title(for: .normal)
        while idx < heroAllNames.count{
            if name == heroAllNames[idx]{
                break
            }
            idx += 1
        }
        heroPickerView.selectRow(idx, inComponent: 0, animated: false)
    }
    
    @IBAction func Start(){
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        let inset = self.view.safeAreaInsets
        let w = self.view.frame.width
        let h = self.view.frame.height
        let rect = CGRect(x: 0, y: inset.top, width: w, height: h-inset.top-inset.bottom)
        Game.current = Game()
        let game = Game.current
        let heroNames = heroButtons.map{ $0.title(for: .normal)! }
        game.setHeros(heroNames)
        let gameView = GameView(frame: rect, game: game)
        game.gameView = gameView
        vc.view.addSubview(gameView)
        if #available(iOS 13.0, *) {
            vc.view.backgroundColor = .systemBackground
        } else {
            vc.view.backgroundColor = .white
            // Fallback on earlier versions
        }
        present(vc, animated: true, completion: nil)
        DispatchQueue.global(qos: .userInteractive).async{
            print("Starting game")
            GameEvent(game: game).execute()
        }
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
    }
    let selectOrder = [0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0]
    let selectTints: [UIColor] = [.systemRed, .systemBlue]
    var selectedNames: [String] = []
    @IBAction func ToggleSelect(sender: UIButton){
        let name = sender.title(for: .normal)!
        if selectedNames.contains(name){
            if name == selectedNames.last!{
                if #available(iOS 13.0, *) {
                    sender.tintColor = .label
                } else {
                    sender.tintColor = .black
                }
                selectedNames.removeLast()
            }
        }else{
            let side = selectOrder[selectedNames.count]
            sender.tintColor = selectTints[side]
            selectedNames.append(name)
        }
    }
    @IBAction func ResetSelect(){
        let names = heroAll.keys.shuffled()
        selectedNames = []
        for i in 0..<selectHeroButtons.count {
            selectHeroButtons[i].setTitle(names[i], for: .normal)
            if #available(iOS 13.0, *) {
                selectHeroButtons[i].tintColor = .label
            } else {
                selectHeroButtons[i].tintColor = .black
            }
        }
    }
    
    @IBAction func NO(){
        Input.FillDefaultSelection()
    }
    
    @IBAction func CANCEL(){
        Input.Cancel()
    }
    var boolInput: Bool = false
    let inputSem: DispatchSemaphore
    
    required init?(coder aDecoder: NSCoder) {
        inputSem = DispatchSemaphore(value: 0)
        super.init(coder: aDecoder)
    }
    
    func InputBool() -> Bool{
        // Set up buttons
        inputSem.wait()
        return boolInput
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    // datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heroAll.count
    }
    
    // delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return heroAllNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let b = activeHeroButton{
            let name = heroAllNames[row]
            b.setTitle(name, for: .normal)
            heroPickerView.alpha = 0.0
        }
    }
}
