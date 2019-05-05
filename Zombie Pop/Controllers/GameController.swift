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
	var gameSeconds = 60
	var zombieArray = Array<Zombie>()
	var zombieIndex = 0
	
	var gameScore = ScoreModel()
	
	var tickerTimer = Timer()
	var gameTimer = Timer()
	
	let zombieLayer = UIView()
	let nightLayer = NightView()
	let infoLayer: InfoView
	
	init() {
		infoLayer = InfoView(gameTime: self.gameSeconds)
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
	
		self.view.backgroundColor = UIColor(red: 0.27, green: 0.42, blue: 0.30, alpha: 1.00)
		
		tickerTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
		
		gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
			
			guard let safe = self else { return }
			
			safe.gameSeconds -= 1
			safe.infoLayer.updateTimer(newTime: safe.gameSeconds)
			
			if safe.gameSeconds <= 0 {
				safe.tickerTimer.invalidate()
				safe.gameTimer.invalidate()
			}
			
		})
		
		zombieLayer.translatesAutoresizingMaskIntoConstraints = false
		nightLayer.translatesAutoresizingMaskIntoConstraints = false
		infoLayer.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(zombieLayer)
		self.view.addSubview(nightLayer)
		self.view.addSubview(infoLayer)
		
		self.view.addConstraints([
		
			// Zombie Layer
			NSLayoutConstraint(item: zombieLayer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: zombieLayer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: zombieLayer, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: zombieLayer, attribute: .bottom, multiplier: 1.0, constant: 0),
		
			// Night Layer
			NSLayoutConstraint(item: nightLayer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: nightLayer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: nightLayer, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: nightLayer, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Info Layer
			NSLayoutConstraint(item: infoLayer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: infoLayer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: infoLayer, attribute: .trailing, multiplier: 1.0, constant: 20)
		
		])
		
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

	func spawnLocation(zombieObject: Zombie, zombieBorder: Int, edgeInset: Int) -> Int? {
		
		let zombieRadius = CGFloat((zombieObject.zombieSize / 2) + zombieBorder)
		let zombieInset = Int((Double(zombieObject.zombieSize) / 2.0).rounded(FloatingPointRoundingRule.up)) + edgeInset
		
		var completeSet: Set<Int> = Set(zombieInset ... Int(UIScreen.main.bounds.width) - zombieInset)
		
		for eachZombie in zombieArray {
		
			guard let zombieView = eachZombie.zombieView, let zombieAnimator = eachZombie.zombieAnimator else { continue }
			
			if (1.0 - Double(zombieAnimator.fractionComplete)) * (eachZombie.zombieTime * 1.1) < zombieObject.zombieTime { continue }
			
			let zombieSet: Set<Int> = Set(Int(zombieView.frame.origin.x - zombieRadius) ... Int(zombieView.frame.origin.x + zombieRadius))

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
		
		var zombieObject = Zombie(passedID: zombieID, speedScale: 0.5)
		
		guard let zombieOrigin = spawnLocation(zombieObject: zombieObject, zombieBorder: 2, edgeInset: 10) else {
			return nil
		}
	
		let zombieView = UIImageView(frame: CGRect(x: zombieOrigin, y: 0, width: 50, height: 50))
		zombieView.isUserInteractionEnabled = true
		zombieView.tag = zombieID
		
		let zombieAnimator = UIViewPropertyAnimator(duration: zombieObject.zombieTime, curve: .linear, animations: {
			zombieView.frame.origin.y = UIScreen.main.bounds.height
		})
		
		zombieAnimator.addCompletion({ [weak self] animatingPosition in
			
			guard let safe = self else { return }
			
			safe.gameScore.gameScore -= zombieObject.zombieScore
			safe.infoLayer.updateScore(newScore: safe.gameScore.gameScore)
			safe.despawnZombie(zombieID: zombieID)
			
		})
		
		zombieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(killZombie(sender:))))
	
		zombieObject.zombieWillAppear(passedView: zombieView, passedAnimator: zombieAnimator)
	
		zombieLayer.addSubview(zombieView)
		zombieAnimator.startAnimation()
		
		return zombieObject
	
	}
	
	func despawnZombie(zombieID: Int) {
	
		guard let zombieIndex = zombieArray.firstIndex(where: { $0.zombieID == zombieID }) else { return }
		
		zombieArray[zombieIndex].zombieAnimator?.stopAnimation(true)
		zombieArray[zombieIndex].zombieView?.removeFromSuperview()
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
	
		guard let zombieObject = zombieArray.first(where: { $0.zombieID == zombieView.tag }) else { return }
		
		if let lastTapped = gameScore.lastTapped, lastTapped == zombieObject.zombieType {
			gameScore.gameScore += Int(Double(zombieObject.zombieScore) * 1.5)
		} else {
			gameScore.gameScore += zombieObject.zombieScore
		}
		
		gameScore.lastTapped = zombieObject.zombieType
		
		infoLayer.updateScore(newScore: gameScore.gameScore)
		infoLayer.updateMulti(zombieImage: zombieObject.zombieIcon)
	
		despawnZombie(zombieID: zombieView.tag)
	
	}

}
