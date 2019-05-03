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
	var gameTimer = Timer()
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
	
		self.view.backgroundColor = UIColor.red
		gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(outputHello), userInfo: nil, repeats: false)
		
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension GameController {

	func spawnZombie() {
	
		let zombieView = UIView(frame: CGRect(x: 60, y: 0, width: 40, height: 40))
		zombieView.backgroundColor = UIColor.blue
		
		self.view.addSubview(zombieView)
		
		UIView.animate(withDuration: 5.0, animations: {
			zombieView.frame.origin.y = UIScreen.main.bounds.height - 40
		})
	
	}

	func spawnLocations() -> Array<Range<CGFloat>>? { return nil }

	@objc func outputHello() {
	
		spawnZombie()
	
	}

}
