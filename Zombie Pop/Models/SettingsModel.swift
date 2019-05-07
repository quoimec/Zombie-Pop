//
//  SettingsModel.swift
//  Zombie Pop
//
//  Created by Charlie on 5/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation

enum SettingsType {
	case Int, Float
}

enum SettingsDifficulty: Int, Codable {
	case Easy, Medium, Hard
}

struct SettingsModel: Codable {
	
	var settingsDifficulty: SettingsDifficulty?
	var gameTime: Int
	var gameTicks: Float
	var spawnRate: Float
	var despawnRate: Float
	var zombieSpeed: Float
	var zombieCount: Int
	
	init(gameTime: Int, gameTicks: Float, spawnRate: Float, despawnRate: Float, zombieSpeed: Float, zombieCount: Int) {
	
		self.settingsDifficulty = nil
		self.gameTime = gameTime
		self.gameTicks = gameTicks
		self.spawnRate = spawnRate
		self.despawnRate = despawnRate
		self.zombieSpeed = zombieSpeed
		self.zombieCount = zombieCount
	
	}
	
	init(fromDifficulty: SettingsDifficulty) {
	
		self.settingsDifficulty = fromDifficulty
	
		switch fromDifficulty {
		
			case .Easy:
			self.gameTime = 30
			self.gameTicks = 1.0
			self.spawnRate = 0.5
			self.despawnRate = 1.0
			self.zombieSpeed = 1.5
			self.zombieCount = 10
		
			case .Medium:
			self.gameTime = 60
			self.gameTicks = 0.5
			self.spawnRate = 1.0
			self.despawnRate = 0.5
			self.zombieSpeed = 1.0
			self.zombieCount = 15
		
			case .Hard:
			self.gameTime = 90
			self.gameTicks = 0.25
			self.spawnRate = 2.0
			self.despawnRate = 0.0
			self.zombieSpeed = 0.5
			self.zombieCount = 20
		
		}
	
	}
	
}
