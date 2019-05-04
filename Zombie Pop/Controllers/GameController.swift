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
	var zombieArray = Array<Zombie>()
	var zombieIndex = 0
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
	
		self.view.backgroundColor = UIColor.red
		gameTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension GameController {

	func spawnCount() -> Int {
	
		/*	Spawn Count
			- A function for detirmining the number of zombies to spawn in a given game tick
			- See graph of scaling function here: https://www.desmos.com/calculator/zsc9eu2aws
		*/
	
		return Int(pow(Double.random(in: 0 ... 100), 2.0) * 0.0004 + 1.0)
	}

	func spawnLocation(zombieWidth: Int, zombieBorder: Int, edgeInset: Int) -> Int? {
		
		let zombieInset = Int((Double(zombieWidth) / 2.0).rounded(FloatingPointRoundingRule.up)) + edgeInset
		let zombieRadius = CGFloat((zombieWidth / 2) + zombieBorder)
		
		var completeSet: Set<Int> = Set(zombieInset ... Int(UIScreen.main.bounds.width) - zombieInset)
		
		for eachZombie in zombieArray {
		
			let zombieSet: Set<Int> = Set(Int(eachZombie.zombieView.frame.origin.x - zombieRadius) ... Int(eachZombie.zombieView.frame.origin.x + zombieRadius))

			completeSet = completeSet.subtracting(zombieSet)

		}
		
		if completeSet.count < Int(zombieRadius) * 2 { return nil }
		
		guard let randomOrigin = completeSet.randomElement() else { return nil }
		
		let randomSet: Set<Int> = Set(randomOrigin - Int(zombieRadius) ... randomOrigin + Int(zombieRadius))
		
		if randomSet.isSubset(of: completeSet) {
			return randomOrigin
		} else {
			return nil
		}
		
	}

	func spawnZombie(zombieID: Int) -> Zombie? {
		
		let zombieSize = 40
		
		guard let zombieOrigin = spawnLocation(zombieWidth: zombieSize, zombieBorder: 4, edgeInset: 10) else {
			return nil
		}
	
		let zombieView = UIView(frame: CGRect(x: zombieOrigin, y: 0, width: zombieSize, height: zombieSize))
		zombieView.tag = zombieID
		zombieView.backgroundColor = UIColor.blue
		
		let zombieAnimator = UIViewPropertyAnimator(duration: 5.0, curve: .linear, animations: {
			zombieView.frame.origin.y = UIScreen.main.bounds.height - 40
		})
		
		zombieAnimator.addCompletion({ [weak self] animatingPosition in
			self?.despawnZombie(zombieID: zombieID)
		})
		
		let zombieObject = Zombie(passedID: zombieID, passedView: zombieView, passedAnimator: zombieAnimator)
		
		zombieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(killZombie(sender:))))
	
		self.view.addSubview(zombieView)
		zombieAnimator.startAnimation()
		
		return zombieObject
	
	}
	
	func despawnZombie(zombieID: Int) {
	
		guard let zombieIndex = zombieArray.firstIndex(where: { $0.zombieID == zombieID }) else {
			return
		}
		
		zombieArray[zombieIndex].zombieAnimator.stopAnimation(true)
		zombieArray[zombieIndex].zombieView.removeFromSuperview()
		zombieArray.remove(at: zombieIndex)
	
	}

	@objc func gameLoop() {
	
		for _ in 1 ... spawnCount() {
			
			guard let zombieObject = spawnZombie(zombieID: zombieIndex) else {
				return
			}
			
			zombieArray.append(zombieObject)
			zombieIndex += 1
			
		}
	
	}
	
	@objc func killZombie(sender: UIGestureRecognizer) {
	
		guard let zombieView = sender.view else { return }
	
		despawnZombie(zombieID: zombieView.tag)
	
	}
	
	

}
