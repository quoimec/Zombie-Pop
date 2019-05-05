//
//  ZombieModel.swift
//  Zombie Pop
//
//  Created by Charlie on 3/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

enum ZombieType: Int {
	case Red, Pink, Green, Blue, Black
}

struct Zombie {
	
	let zombieID: Int
	let zombieType: ZombieType
	let zombieIcon: String
	let zombieSpeed: Double
	let zombieTime: Double
	let zombieScore: Int
	let zombieSize: Int = 50

	var zombieView: UIImageView?
	var zombieAnimator: UIViewPropertyAnimator?

	init(passedID: Int, speedScale: Double) {
	
		let zombieDistribution = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4]
		
		self.zombieType = ZombieType.init(rawValue: zombieDistribution[Int.random(in: 0 ..< zombieDistribution.count)])!
		self.zombieID = passedID
		
		
		switch self.zombieType {
		
			case .Red:
			self.zombieIcon = "Red Zombie"
			self.zombieSpeed = 0.75
			self.zombieScore = 1
			
			case .Pink:
			self.zombieIcon = "Pink Zombie"
			self.zombieSpeed = 1.0
			self.zombieScore = 2
			
			case .Green:
			self.zombieIcon = "Green Zombie"
			self.zombieSpeed = 1.5
			self.zombieScore = 5
			
			case .Blue:
			self.zombieIcon = "Blue Zombie"
			self.zombieSpeed = 2.5
			self.zombieScore = 8
			
			case .Black:
			self.zombieIcon = "Black Zombie"
			self.zombieSpeed = 4.0
			self.zombieScore = 10
			
		}
		
		self.zombieTime = (5.0 / self.zombieSpeed) * speedScale
		
	}
	
	mutating func zombieWillAppear(passedView: UIImageView, passedAnimator: UIViewPropertyAnimator) {
	
		self.zombieView = passedView
		self.zombieAnimator = passedAnimator
		self.zombieView?.image = UIImage(named: self.zombieIcon)
		
	}

	
//	func timeRemaining() {
//		return zombieAnimator?.fractionComplete
//	}

}
