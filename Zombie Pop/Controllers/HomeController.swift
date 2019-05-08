//
//  HomeController.swift
//  Zombie Pop
//
//  Created by Charlie on 6/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController {

	/*	Home Controller

		- A very simple controller that contains 3 buttons; one to start a new game, one to open the scores controller and another to open the settings controller.
		- The Home Controller is designed in exactly the same style as the Game Controller so that it looks like a seamless transition into the game when the user taps Start.

	*/

	let zombieHeader = UILabel()
	let nightLayer = NightView()
	let startButton = ButtonView(buttonText: "Start")
	let settingsButton = ButtonView(buttonText: "Settings")
	let scoresButton = ButtonView(buttonText: "Scores")
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor(red: 0.27, green: 0.42, blue: 0.30, alpha: 1.00)
		
		zombieHeader.text = "ZOMBIE\nPOP"
		zombieHeader.numberOfLines = 2
		zombieHeader.font = UIFont.systemFont(ofSize: 46, weight: .black)
		zombieHeader.textColor = UIColor(red: 0.64, green: 0.14, blue: 0.21, alpha: 1.00)
		
		zombieHeader.translatesAutoresizingMaskIntoConstraints = false
		nightLayer.translatesAutoresizingMaskIntoConstraints = false
		startButton.translatesAutoresizingMaskIntoConstraints = false
		settingsButton.translatesAutoresizingMaskIntoConstraints = false
		scoresButton.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(nightLayer)
		self.view.addSubview(zombieHeader)
		self.view.addSubview(startButton)
		self.view.addSubview(settingsButton)
		self.view.addSubview(scoresButton)
		
		self.view.addConstraints([
		
			// Zombie Header
			NSLayoutConstraint(item: zombieHeader, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 30),
			NSLayoutConstraint(item: zombieHeader, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 50),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: zombieHeader, attribute: .trailing, multiplier: 1.0, constant: 30),
		
			// Night Layer
			NSLayoutConstraint(item: nightLayer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: nightLayer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: nightLayer, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: nightLayer, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Start Button
			NSLayoutConstraint(item: startButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: startButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: startButton, attribute: .trailing, multiplier: 1.0, constant: 40),
			
			// Settings Button
			NSLayoutConstraint(item: settingsButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: settingsButton, attribute: .top, relatedBy: .equal, toItem: startButton, attribute: .bottom, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: settingsButton, attribute: .trailing, multiplier: 1.0, constant: 40),

			// Settings Button
			NSLayoutConstraint(item: scoresButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: scoresButton, attribute: .top, relatedBy: .equal, toItem: settingsButton, attribute: .bottom, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: scoresButton, attribute: .trailing, multiplier: 1.0, constant: 40)
		
		])
		
		startButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGame)))
		settingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSettings)))
		scoresButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openScores)))
		
	}


}

extension HomeController {

	@objc func openGame() {
	
		var settingsModel: SettingsModel
		
		if let settingsData = UserDefaults.standard.object(forKey: "SettingsModel") as? Data, let settingsCached = try? JSONDecoder().decode(SettingsModel.self, from: settingsData) {
			settingsModel = settingsCached
		} else {
			settingsModel = SettingsModel(fromDifficulty: .Medium)
			UserDefaults.standard.set(try? JSONEncoder().encode(settingsModel), forKey: "SettingsModel")
		}
		
		let navigationReference = UIApplication.shared.keyWindow?.rootViewController as! NavigationController
		navigationReference.pushViewController(GameController(passedSettings: settingsModel), animated: false)
	
	}
	
	@objc func openSettings() {
		
		var settingsModel: SettingsModel
		
		if let settingsData = UserDefaults.standard.object(forKey: "SettingsModel") as? Data, let settingsCached = try? JSONDecoder().decode(SettingsModel.self, from: settingsData) {
			settingsModel = settingsCached
		} else {
			settingsModel = SettingsModel(fromDifficulty: .Medium)
		}
		
		let navigationReference = UIApplication.shared.keyWindow?.rootViewController as! NavigationController
		navigationReference.pushViewController(SettingsController(passedSettings: settingsModel), animated: true)
		
	}

	@objc func openScores() {
	
		let navigationReference = UIApplication.shared.keyWindow?.rootViewController as! NavigationController
		navigationReference.pushViewController(ScoresController(), animated: true)
		
	}

}
