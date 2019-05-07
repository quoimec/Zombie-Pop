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
import CoreData

class GameController: UIViewController {
	
	var gameScore = ScoreModel()
	var gameSettings: SettingsModel
	
	var zombieIndex = 0
	var zombieArray = Array<Zombie>()
	
	var gameSeconds: Int
	var introCountdown = 5
	
	var gameTimer = Timer()
	var tickerTimer = Timer()
	var countdownTimer = Timer()
	
	let zombieLayer = UIView()
	let nightLayer = NightView()
	let infoLayer: InfoView
	let countdownLayer = UIImageView()
	let nameInput = InputView()
	
	let navigationReference = UIApplication.shared.keyWindow?.rootViewController as! NavigationController
	
	init(passedSettings: SettingsModel) {
	
		gameSettings = passedSettings
		gameSeconds = passedSettings.gameTime
		infoLayer = InfoView(gameTime: passedSettings.gameTime)
		
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
	
		self.view.backgroundColor = UIColor(red: 0.27, green: 0.42, blue: 0.30, alpha: 1.00)
		
		zombieLayer.translatesAutoresizingMaskIntoConstraints = false
		nightLayer.translatesAutoresizingMaskIntoConstraints = false
		infoLayer.translatesAutoresizingMaskIntoConstraints = false
		countdownLayer.translatesAutoresizingMaskIntoConstraints = false
		nameInput.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(zombieLayer)
		self.view.addSubview(nightLayer)
		self.view.addSubview(infoLayer)
		self.view.addSubview(countdownLayer)
		
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
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: infoLayer, attribute: .trailing, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: infoLayer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: -40),
			
			// Countdown Layer
			NSLayoutConstraint(item: countdownLayer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: countdownLayer, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: countdownLayer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.4, constant: 0),
			NSLayoutConstraint(item: countdownLayer, attribute: .height, relatedBy: .equal, toItem: countdownLayer, attribute: .width, multiplier: 1.0, constant: 0)
		
		])
		
		countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
			
			guard let safe = self else { return }
			
			if safe.introCountdown == 4 {
				safe.countdownLayer.image = UIImage(named: "Zombie Three")
			} else if safe.introCountdown == 3 {
				safe.bounceHand()
				safe.countdownLayer.image = UIImage(named: "Zombie Two")
			} else if safe.introCountdown == 2 {
				safe.bounceHand()
				safe.countdownLayer.image = UIImage(named: "Zombie One")
			} else if safe.introCountdown == 1 {
				safe.bounceHand()
				safe.countdownLayer.image = UIImage(named: "Zombie None")
			} else if safe.introCountdown <= 0 {
				safe.countdownLayer.removeFromSuperview()
				safe.tickerTimer = Timer.scheduledTimer(timeInterval: Double(safe.gameSettings.gameTicks), target: safe, selector: #selector(safe.gameLoop), userInfo: nil, repeats: true)
				safe.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: safe, selector: #selector(safe.gameSecond), userInfo: nil, repeats: true)
				safe.countdownTimer.invalidate()
			}
			
			safe.introCountdown -= 1
			
		})
		
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
	
		return Int(pow(Double.random(in: 0 ... 100), 2.0) * 0.0004 + Double(gameSettings.spawnRate))
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
		
		var zombieObject = Zombie(passedID: zombieID, speedScale: Double(gameSettings.zombieSpeed))
		
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
		zombieArray[zombieIndex].zombieView?.isUserInteractionEnabled = false

		let viewReference = self.zombieArray[zombieIndex].zombieView

		self.zombieArray.remove(at: zombieIndex)

		UIView.animate(withDuration: 0.3, animations: {
			viewReference?.alpha = 0.0
			viewReference?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
		}, completion: { completed in
			viewReference?.removeFromSuperview()
		})
	
	}

	func bounceHand() {
	
		UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			self.countdownLayer.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
		}, completion: nil)
		
		UIView.animate(withDuration: 0.5, delay: 0.31, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
			self.countdownLayer.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
		}, completion: nil)
		
	}

	@objc func gameLoop() {
	
		let newSpawns = spawnCount()
	
		for _ in 0 ..< newSpawns {
			
			if zombieArray.count >= gameSettings.zombieCount { break }
			
			guard let zombieObject = spawnZombie(zombieID: zombieIndex) else {
				return
			}
			
			zombieArray.append(zombieObject)
			zombieIndex += 1
			
		}
	
	}
	
	@objc func gameSecond() {
	
		gameSeconds -= 1
		infoLayer.updateTimer(newTime: self.gameSeconds)
		
		if gameSeconds <= 0 {
		
			tickerTimer.invalidate()
			gameTimer.invalidate()
		
			for eachZombie in zombieArray {
				despawnZombie(zombieID: eachZombie.zombieID)
			}
			
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
			
				self.view.addSubview(self.nameInput)
			
				self.view.addConstraints([
				
					// Name Input
					NSLayoutConstraint(item: self.nameInput, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
					NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: self.nameInput, attribute: .trailing, multiplier: 1.0, constant: 0),
					NSLayoutConstraint(item: self.nameInput, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.5, constant: 0)
				
				])
				
				self.nameInput.nameInput.delegate = self
				self.nameInput.nameInput.becomeFirstResponder()
			
			})
			
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

extension GameController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		guard let unwrappedText = textField.text else { return false }

		if unwrappedText == "" { return false }
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
		
  		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Score")
		fetchRequest.fetchLimit = 1
		fetchRequest.predicate = NSPredicate(format: "playerName = %@", unwrappedText)
		
		var fetchResponse = Array<NSManagedObject>()
		
		do {
			fetchResponse = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
		var playerObject: NSManagedObject
		
		if fetchResponse.count > 0 {
			
			playerObject = fetchResponse[0]
			
			if let previousHighscore = playerObject.value(forKey: "playerScore") as? Int, previousHighscore > gameScore.gameScore {
				navigationReference.pushViewController(ScoresController(focusPlayer: unwrappedText), animated: true)
				return true
			}
		
		} else {
		
			let scoreEntity = NSEntityDescription.entity(forEntityName: "Score", in: managedContext)!
			playerObject = NSManagedObject(entity: scoreEntity, insertInto: managedContext)
		
		}
		
		var redZombies = 0
		var blueZombies = 0
		var pinkZombies = 0
		var greenZombies = 0
		var blackZombies = 0

		for eachTapped in gameScore.zombieHistory {

			switch eachTapped {

				case .Red:
				redZombies += 1

				case .Blue:
				blueZombies += 1

				case .Pink:
				pinkZombies += 1

				case .Green:
				greenZombies += 1

				case .Black:
				blackZombies += 1

			}

		}

		playerObject.setValue(textField.text, forKey: "playerName")
		playerObject.setValue(gameScore.gameScore, forKey: "playerScore")
		playerObject.setValue(redZombies, forKey: "zombiesRed")
		playerObject.setValue(blueZombies, forKey: "zombiesBlue")
		playerObject.setValue(pinkZombies, forKey: "zombiesPink")
		playerObject.setValue(greenZombies, forKey: "zombiesGreen")
		playerObject.setValue(blackZombies, forKey: "zombiesBlack")

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
			return false
		}

		navigationReference.pushViewController(ScoresController(focusPlayer: unwrappedText), animated: true)
		return true
	
	}

}
