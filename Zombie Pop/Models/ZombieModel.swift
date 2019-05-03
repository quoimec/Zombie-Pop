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

	init() {
	
		let zombieDistribution = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4]
		
		self.zombieType = ZombieType.init(rawValue: zombieDistribution[Int.random(in: 0 ..< zombieDistribution.count)])!
		
		switch self.zombieType {
		
			case .Red:
			self.zombieIcon = "Red_Zombie"
			self.zombieSpeed = 1.0
			
			default:
			self.zombieIcon = "Default_Zombie"
			self.zombieSpeed = 2.0
		
		}
		
	}

}
