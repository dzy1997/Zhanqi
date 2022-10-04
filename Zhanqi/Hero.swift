//
//  Hero.swift
//  TestOld
//
//  Created by William Dong on 2021/4/17.
//

import Foundation

enum Gender: Int{
    case None
    case Male
    case Female
}

class Hero{ // 武将牌
    var name: String = "姓名"
    var gender: Gender = .Male
    var nation: String = "势力"
    var maxHp: Int = 4
    var startHp: Int = 4
    var skills: [PlayerSkill] = []
    init(){
        
    }
    func SetHero(name: String, player: Player){
        self.name = name
        let (skillNames, gender, maxHp, hp) = heroStandard[name]!
        for name in skillNames{
            skills.append(heroSkillAll[name]!.init(player:player))
            self.gender = gender
            self.maxHp = maxHp
            self.startHp = hp
        }
    }
}
