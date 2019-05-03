//
//  GameController.swift
//  Zombie Pop
//
//  Created by Charlie on 3/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameController: UIViewController {

	let maxZombies = 15
	let gameSeconds = 60
	var gameTimer = Timer(timeInterval: 5, target: self, selector: #selector(outputHello), userInfo: nil, repeats: false)
	
	override func viewDidLoad() {
	
		
	
	}
	
	
}

extension GameController {

	@objc func outputHello() {
	
		print("HELLO")
	
	}

}
