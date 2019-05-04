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

	let zombieType: ZombieType
	let zombieIcon: String
	let zombieSpeed: CGFloat
	var zombieID: Int
	var zombieView: UIImageView
	var zombieAnimator: UIViewPropertyAnimator
	

	init(passedID: Int, passedView: UIImageView, passedAnimator: UIViewPropertyAnimator) {
	
		let zombieDistribution = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4]
		
		self.zombieType = ZombieType.init(rawValue: zombieDistribution[Int.random(in: 0 ..< zombieDistribution.count)])!
		self.zombieID = passedID
		self.zombieView = passedView
		self.zombieAnimator = passedAnimator
		
		switch self.zombieType {
		
			case .Red:
			self.zombieIcon = "Red Zombie"
			self.zombieSpeed = 1.0
			
			case .Pink:
			self.zombieIcon = "Pink Zombie"
			self.zombieSpeed = 1.0
			
			case .Green:
			self.zombieIcon = "Green Zombie"
			self.zombieSpeed = 1.0
			
			case .Blue:
			self.zombieIcon = "Blue Zombie"
			self.zombieSpeed = 1.0
			
			case .Black:
			self.zombieIcon = "Black Zombie"
			self.zombieSpeed = 1.0
			
		}
		
		self.zombieView.image = UIImage(named: self.zombieIcon)
		
	}

	
//	func timeRemaining() {
//		return zombieAnimator?.fractionComplete
//	}

}
