//
//  ZombieModel.swift
//  Zombie Pop
//
//  Created by Charlie on 3/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

enum ZombieType {
	
	/*	Zombie Type
	
		- An enum of the five different types of zombies

	*/
	
	case Red, Pink, Green, Blue, Black
}

struct Zombie {

	/*	Zombie
	
		- The struct containing all of the data for a single onscreen zombie
		- Each zombie object is randomly assigned a type based on the zombieDistribution below
		- Each type has a different icon, speed and score attribute
		- Because these values are initialised inside of the zombie and the coordinates of the zombie are unknown, it is not guarenteed that the zombie will be placed on the screen. This is due to functionality requirement 7. where a bubble (zombie) cannot overlap another bubble (zombie). To meet this requirement, it is necessary to check the proposed zombie against the existing zombies and their speed to detirmine if the zombie can be placed.
		- If the zombie can be placed, it is necessary to call the zombieWillAppear function (below) to update the zombie object with references to the animator and view objects associated with this zombie.

	*/

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
	
		// Zombies are randomly initialised based on this distribution, which was made according to assessment spec
		let zombieDistribution: Array<ZombieType> = [.Red, .Red, .Red, .Red, .Red, .Red, .Red, .Red, .Pink, .Pink, .Pink, .Pink, .Pink, .Pink, .Green, .Green, .Green, .Blue, .Blue, .Black]
		
		self.zombieType = zombieDistribution[Int.random(in: 0 ..< zombieDistribution.count)]
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
	
		/*	zombieWillAppear
		
			- As above, zombieWillAppear needs to be called after the Zombie object has been initialised to update it with the references to the class

		*/
	
		self.zombieView = passedView
		self.zombieAnimator = passedAnimator
		self.zombieView?.image = UIImage(named: self.zombieIcon)
		
	}

}
