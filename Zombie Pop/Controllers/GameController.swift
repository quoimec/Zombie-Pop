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
	
	/*	Game Controller
	
		- The main game routine of the application encapsulating the timers, scoring/settings models and the zombie controlling functions, all of which are individually documented below.
		- The controller needs to be initialised with a SettingsModel struct. This controller is initialised inside the Home Controller when the user taps the Start button, if there is no existing SettingsModel saved in UserDefaults, the controller will provide a default Settings Model of medium difficulty.

	*/
	
	var gameScore = ScoreModel()
	var gameSettings: SettingsModel
	
	var zombieIndex = 0
	var zombieArray = Array<Zombie>()
	
	var gameSeconds: Int
	var introCountdown = 5
	
	var gameTimer = Timer()
	var gameTicker = Timer()
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
		
		var highscoreString: String? = nil
		
		// If it exists, set the highest score in the Info View.
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
		
			let managedContext = appDelegate.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Score")
			fetchRequest.fetchLimit = 1
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playerScore", ascending: false)]
		
			var fetchResponse = Array<NSManagedObject>()
			
			do {
				fetchResponse = try managedContext.fetch(fetchRequest)
			} catch let error as NSError {
				print("Could not fetch. \(error), \(error.userInfo)")
			}
			
			if fetchResponse.count > 0, let currentHighscore = fetchResponse[0].value(forKey: "playerScore") as? Int {
				highscoreString = "HIGH: \(currentHighscore)"
			}
		
		}
		
		infoLayer = InfoView(gameTime: passedSettings.gameTime, highScore: highscoreString)
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
			
			/*	Countdown Timer
			
				- The coundown timer is initialised at the end of VDL and controls the animated zombie hand counting down the game.
				- Once the countdown has reached zero, it initialises both the GameTimer and the GameTick timers, thus starting the game.
			
			*/
			
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
				safe.gameTicker = Timer.scheduledTimer(timeInterval: Double(safe.gameSettings.gameTicks), target: safe, selector: #selector(safe.gameTick), userInfo: nil, repeats: true)
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
		
			- A function for detirmining the number of zombies to spawn in a given game tick.
			- See graph of scaling function here: https://www.desmos.com/calculator/zsc9eu2aws
		
		*/
	
		return Int(pow(Double.random(in: 0 ... 100), 2.0) * 0.0004 + Double(gameSettings.spawnRate))
	}
	
	func despawnCount() -> Int {
	
		/*	Despawn Count
		
			- A function for detirmining the number of zombies to despawn in a given game tick
		
		*/
	
		return Int(pow(Double.random(in: 0 ... 100) + Double(gameSettings.despawnRate), 2.0) * 0.0002)
	
	}

	func spawnLocation(zombieObject: Zombie, zombieBorder: Int, edgeInset: Int) -> Int? {
		
		/*	Spawn Location

			- Spawn Location is a function that attempts to generate a valid X coordinate for the passed Zombie object, given it's type and speed.
			- The function considers each existing zombie in the game, their type and speed and calculates how long it will take before that Zombie reaches the end of the game board.
			- If the function is sure that a zombie will finish it's run before the new Zombie object it ignores it. If however, the function detirmines that the new Zombie would run over the existing Zombie, it blacklists the X coordinates around that Zombie so that the new Zombie cannot spawn in it's "lane".
			- In this way, the game is able to adheer to requirement 7 of the assessment and will only consider spawning a Zombie in locations where it is legal and there is enough space to do so.
			- If the Zombie cannot find a valid location to spawn, the function will return a value of nil. If it can, it will return the X coordinate for it's spawn.
			- A repercussion of the moving Zombies and requirement 7 is that although the Zombies are created according to the necessary distribution in table 1, some Zombies cannot spawned, meaning the actual spawn rate differs from table 1.

		*/
		
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
		
		// Spawn Location selects a random X value from the remaining set.
		guard let randomOrigin = completeSet.randomElement() else { return nil }
		
		// To ensure it has enough space to spawn, the function checks to make sure there is enough valid space on either side of the Zombie. If not, it returns nil. 
		let randomSet: Set<Int> = Set(randomOrigin - Int(zombieRadius) ... randomOrigin + Int(zombieRadius))
		
		if randomSet.isSubset(of: completeSet) {
			return randomOrigin
		} else {
			return nil
		}
		
	}

	func spawnZombie(zombieID: Int) -> Zombie? {
	
		/*	Spawn Zombie
		
			- Spawn Zombie is a function that may return a Zombie object when it is called. It will only return a Zombie object if Spawn Location (above) returns a valid X coordinate for the Zombie to spawn in. If Spawn Location returns nil, the Zombie will not be spawned and the struct is destroyed.
			- Spawn Zombie needs to be passed an integer value which will serve as the unique ID for the new Zombie. Importantly, Spawn Zombie assosicates this value with both the Zombie object and it's view through the tag attribute. This is so that when the view is tapped, the assosicated Zombie object can be found by comparing the tag with all known Zombie object's IDs.
			- If a valid X coordinate is allocated to the Zombie, Spawn Zombie creates the necessary view and animator functions and then updates the Zombie object to reference them with the mutating zombieWillAppear function. Spawn Zombie also attaches a tap gesture recogniser to the Zombie's view so that it will be killed if the user taps the zombie.
			- After this has all been completed, Spawn Zombie adds the Zombie's view to the game view, starts the movement animation and returns the Zombie object, so that it can be stored in the Zombie Array.

		*/
		
		var zombieObject = Zombie(passedID: zombieID, speedScale: Double(gameSettings.zombieSpeed))
		
		guard let zombieOrigin = spawnLocation(zombieObject: zombieObject, zombieBorder: 2, edgeInset: 10) else { return nil }
	
		let zombieView = UIImageView(frame: CGRect(x: zombieOrigin, y: 0, width: 50, height: 50))
		zombieView.isUserInteractionEnabled = true
		zombieView.tag = zombieID
		
		let zombieAnimator = UIViewPropertyAnimator(duration: zombieObject.zombieTime, curve: .linear, animations: {
			zombieView.frame.origin.y = UIScreen.main.bounds.height
		})
		
		// Zombie Animator Completion: If the animator completes, it means the zombie reached the end of the game board without being killed. In this case, the zombie will despawn iself while also subtracting it's score from the total score.
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
	
		/* Despawn Zombie
	
			- This function serves to unwind all of the operations that Spawn Zombie starts up and allows the Zombie object to be deallocated from memory. It does this by stopping any running animations and disabling user interation. Then it animates the zombie out of the scene and finally removes both the Zombie object and the Zombie's view from the Game Controller.
			- Despawn Zombie needs to be passed an ID value for the Zombie that is about to be despawned.\
			- Despawn Zombie does not contain any scoring funcionality as this is encapsulated inside the Kill Zombie function, which then calls Despawn Zombie.

		*/
	
		guard let zombieIndex = zombieArray.firstIndex(where: { $0.zombieID == zombieID }) else { return }
		
		zombieArray[zombieIndex].zombieAnimator?.stopAnimation(true)
		zombieArray[zombieIndex].zombieView?.isUserInteractionEnabled = false

		let viewReference = self.zombieArray[zombieIndex].zombieView

		self.zombieArray.remove(at: zombieIndex)

		// Small animation for the disapearing Zombie.
		UIView.animate(withDuration: 0.3, animations: {
			viewReference?.alpha = 0.0
			viewReference?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
		}, completion: { completed in
			viewReference?.removeFromSuperview()
		})
	
	}

	func bounceHand() {
	
		/*	Bounce Hand
	
			- This simple function is used to animate the bouncing of the coundown hand at the begining of the game.
			- It scales the hand up and back to it's original location to give the impression of movement.

		*/
	
		UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			self.countdownLayer.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
		}, completion: nil)
		
		UIView.animate(withDuration: 0.5, delay: 0.31, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
			self.countdownLayer.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
		}, completion: nil)
		
	}

	@objc func gameTick() {
	
		/*	Game Loop
		
			- The Game Loop function is associated with the Game Ticker timer.
			- Because the frequency of game ticks is a variable that the user is able to control in the game settings, Game Tick has been decoupled from the Game Time timer which always conunts down in seconds.
			- In each Game Tick, the function decides how many Zombies it will both spawn and despawn for that tick. It then goes through and executes those despawn/spawn actions.

		*/
		
		let tickDespawns = despawnCount()
		let tickSpawns = spawnCount()
		
		for _ in 0 ..< tickDespawns {
		
			if zombieArray.count == 0 { break }
			
			let despawnIndex = Int.random(in: 0 ..< zombieArray.count)
			
			despawnZombie(zombieID: zombieArray[despawnIndex].zombieID)
			
		}
	
		for _ in 0 ..< tickSpawns {
			
			if zombieArray.count >= gameSettings.zombieCount { break }
			
			guard let zombieObject = spawnZombie(zombieID: zombieIndex) else {
				return
			}
			
			zombieArray.append(zombieObject)
			zombieIndex += 1
			
		}
	
	}
	
	@objc func gameSecond() {
	
		/*	Game Second
		
			- Game Second is the primary game timer and as mentioned above, is decoupled from the spawning of Zombies. It's sole purpose is to fire each second and update the countdown view.
			- Once the second count reaches 0, the Game Second function invalidates both itself and the Game Ticker timer and despawns all of the onscreen Zombies. It then presents an input to the user so that they can enter their name into the Scores record.

		*/
	
		gameSeconds -= 1
		infoLayer.updateTimer(newTime: self.gameSeconds)
		
		if gameSeconds <= 0 {
		
			gameTicker.invalidate()
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
	
		/*	Kill Zombie

			- Kill Zombie is the function that is called when a user taps on a Zombie view. It uses the view's tag attribute (which is a unique ID set when the Zombie was spawned) to find it's associaed Zombie object.
			- Once it has found the right object, it appends the correct score to the total, adjusts the multiplier and then despawns the Zombie.

		*/
	
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
	
		/* Text Field

			- This function controlls the text field where the user inputs their name at the end of a game run.
			- If the user has not entered any text, the function will pulse the text input area to indicate to the user that they must input text.
			- If there is valid text in the field, it checks against the Core Data storage to see if that name already exists. If it does, the program checks to see if the new score is higher than the old score for that user. If it is, it overwrites the score. If not it does nothing. This is in accordance to requirement 10 where the system only keeps the players highest scores. If there is no existing score with the given name, the system creates a new entity and stores in the database.
			- The before the function returns, it pushes an instance of Scores Controller into the navigation stack, highlighting the users highest score in red.

		*/

		guard let unwrappedText = textField.text else { return false }

		if unwrappedText == "" {
		
			UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
				self.nameInput.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
			}, completion: nil)
		
			UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
				self.nameInput.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
			}, completion: nil)
			
			return false
			
		}
		
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
