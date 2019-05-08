//
//  SettingsModel.swift
//  Zombie Pop
//
//  Created by Charlie on 5/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation

enum SettingsType {
	
	/*	Settings Type
	
		- The two different settings types.
		- This value is only used to detirmine the formatting of slider value labels.

	*/

	case Int, Float
}

enum SettingsDifficulty: Int, Codable {

	/*	Settings Difficulty

		- The three different settings preset values.
		- It has the Int type so that it can be directly initialsied from the segmented control values.
		- It has the codable type so that it can be saved in the Settings Model below.

	*/
	
	case Easy, Medium, Hard
}

struct SettingsModel: Codable {

	/*	Settings Model
	
		- Contains all of the settings for the game.
		- There are two initialsiers, one where the values can be directly set and the other where the settings can be initialised by a SettingsDifficulty type, where default values are provided for each case.
		- Settings Model is Codable so that this struct can be encoded and stored in User Defaults with the key "SettingsModel". This is how the game settings persist between sessions.

	*/
	
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
