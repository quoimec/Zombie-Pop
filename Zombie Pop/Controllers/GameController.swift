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
	var zombieObject = Zombie(passedSpawn: CGPoint(x: 60, y: 0))
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
	
		self.view.backgroundColor = UIColor.red
		gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(outputHello), userInfo: nil, repeats: false)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension GameController {

	func spawnZombie() {
	
		let zombieView = UIView(frame: CGRect(x: 60, y: 0, width: 40, height: 40))
		zombieView.tag = 1
		zombieView.backgroundColor = UIColor.blue
		
		let zombieAnimator = UIViewPropertyAnimator(duration: 5.0, curve: .easeInOut, animations: {
			zombieView.frame.origin.y = UIScreen.main.bounds.height - 40
		})
		
		zombieAnimator.addCompletion({ animatingPosition in
			
			print(zombieView.frame)
			
		})
		
		zombieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(killZombie(sender:))))
		
		zombieObject.zombieWillSpawn(passedView: zombieView, passedAnimator: zombieAnimator)
		
		self.view.addSubview(zombieView)
	
		zombieAnimator.startAnimation()
	
	}

	func spawnLocations() -> Array<Range<CGFloat>>? { return nil }

	@objc func outputHello() {
	
		spawnZombie()
	
	}
	
	@objc func killZombie(sender: UIGestureRecognizer) {
	
		print("KILL")
		
		zombieObject.zombieView?.removeFromSuperview()
	
	}

}
