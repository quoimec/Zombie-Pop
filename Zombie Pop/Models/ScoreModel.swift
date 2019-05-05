//
//  GameModel.swift
//  Zombie Pop
//
//  Created by Charlie on 4/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation

struct ScoreModel {

	var gameScore = 0
	var lastTapped: ZombieType? {
		
		get {
			return zombieHistory.last
		}
		
		set(newType) {
			guard let safeType = newType else { return }
			zombieHistory.append(safeType)
		}
		
	}
	var zombieHistory = Array<ZombieType>()

}
