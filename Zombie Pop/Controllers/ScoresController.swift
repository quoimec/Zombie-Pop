//
//  ScoresController.swift
//  Zombie Pop
//
//  Created by Charlie on 6/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScoresController: UIViewController {

	/*	Scores Controller

		- A simple controller containing a table view displaying the top score for each player.
		- Scores Controller may be initialised with a players name, in which case it will highlight that players score in red. This is specifically used after the player has completed a game and entered their name and the scores controller is automatically opened. This clearly shows the player where they stand on the leaderboard.
		- Scores controller retrieves it's list of players from Core Data.
		- Because Scores Controller is can be pushed on top of a Game Controller instance, it's done button will always pop back to the root Home Controller.

	*/
	
	let focusPlayer: String
	let scoresHeader = UILabel()
	let scoresDone = UILabel()
	let scoresTable = UITableView()
	var scoresArray = Array<NSManagedObject>()
	
	let navigationReference = UIApplication.shared.keyWindow?.rootViewController as! NavigationController

	init(focusPlayer: String = "") {
		self.focusPlayer = focusPlayer
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		scoresTable.delegate = self
		scoresTable.dataSource = self
		
		self.view.backgroundColor = UIColor.white
		
		scoresHeader.text = "Scores"
		scoresHeader.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
		scoresHeader.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		
		scoresDone.text = "Done"
		scoresDone.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		scoresDone.textColor = UIColor(red: 0.15, green: 0.67, blue: 0.75, alpha: 1.00)
		scoresDone.isUserInteractionEnabled = true
		
		scoresTable.separatorStyle = .none
		scoresTable.register(ScoreCell.self, forCellReuseIdentifier: "ScoreCell")
		
		scoresHeader.translatesAutoresizingMaskIntoConstraints = false
		scoresDone.translatesAutoresizingMaskIntoConstraints = false
		scoresTable.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(scoresHeader)
		self.view.addSubview(scoresDone)
		self.view.addSubview(scoresTable)
		
		self.view.addConstraints([
		
			// Scores Header
			NSLayoutConstraint(item: scoresHeader, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: scoresHeader, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 60),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: scoresHeader, attribute: .trailing, multiplier: 1.0, constant: 20),
			
			// Scores Done
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: scoresDone, attribute: .trailing, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: scoresHeader, attribute: .bottom, relatedBy: .equal, toItem: scoresDone, attribute: .bottom, multiplier: 1.0, constant: 2),
			
			// Scores Table
			NSLayoutConstraint(item: scoresTable, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: scoresTable, attribute: .top, relatedBy: .equal, toItem: scoresHeader, attribute: .bottom, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: scoresTable, attribute: .trailing, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: scoresTable, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
		scoresDone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissScores)))
		
	}

	override func viewWillAppear(_ animated: Bool) {
  		super.viewWillAppear(animated)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		
  		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Score")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "playerScore", ascending: false)]
		
		do {
			scoresArray = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
	}

}

extension ScoresController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return scoresArray.count }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let scoreCell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! ScoreCell
		
		let scoreObject = scoresArray[indexPath.row]

		let playerName = scoreObject.value(forKey: "playerName") as! String

		scoreCell.playerName.text = playerName
		scoreCell.playerScore.text = "\(scoreObject.value(forKey: "playerScore") as! Int16)"
		
		if playerName == focusPlayer {
			scoreCell.playerName.textColor = UIColor(red: 0.64, green: 0.14, blue: 0.21, alpha: 0.8)
			scoreCell.playerScore.textColor = UIColor(red: 0.64, green: 0.14, blue: 0.21, alpha: 0.8)
		} else {
			scoreCell.playerName.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
			scoreCell.playerScore.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		}
		
		return scoreCell
		
	}
	
}

extension ScoresController {

	@objc func dismissScores() {
	
		navigationReference.popToRootViewController(animated: true)
	
	}
	
}
