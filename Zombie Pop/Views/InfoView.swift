//
//  InfoView.swift
//  Zombie Pop
//
//  Created by Charlie on 4/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class InfoView: UIView {

	/*	Info View

		- Describes the view of the highscore, time, current score and multiplier in the Game Controller.
		- Includes built in functions to update the values scored in these views which includes some small animation features.
	
	*/

	let infoTimer = UILabel()
	let infoScore = UILabel()
	let infoMulti = UILabel()
	let infoHigh = UILabel()
	let multiIcon = UIImageView()
	
	init(gameTime: Int, highScore: String?) {
		super.init(frame: CGRect.zero)
		
		if let safeScore = highScore {
			infoHigh.text = safeScore
		}
		
		updateTimer(newTime: gameTime)
		updateScore(newScore: 0)
		
		infoTimer.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
		infoScore.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
		infoMulti.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
		infoHigh.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
		
		infoTimer.alpha = 0.40
		infoScore.alpha = 0.40
		infoMulti.alpha = 0.40
		infoHigh.alpha = 0.40
		infoTimer.textColor = UIColor.white
		infoScore.textColor = UIColor.white
		infoMulti.textColor = UIColor.white
		infoHigh.textColor = UIColor.white
		infoTimer.textAlignment = .left
		infoScore.textAlignment = .right
		infoMulti.textAlignment = .right
		infoHigh.textAlignment = .right
		
		infoTimer.translatesAutoresizingMaskIntoConstraints = false
		infoScore.translatesAutoresizingMaskIntoConstraints = false
		infoMulti.translatesAutoresizingMaskIntoConstraints = false
		multiIcon.translatesAutoresizingMaskIntoConstraints = false
		infoHigh.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(infoTimer)
		self.addSubview(infoScore)
		self.addSubview(infoMulti)
		self.addSubview(multiIcon)
		self.addSubview(infoHigh)
		
		self.addConstraints([
		
			// Info Timer
			NSLayoutConstraint(item: infoTimer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoTimer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			
			// Info Score
			NSLayoutConstraint(item: infoScore, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: infoScore, attribute: .trailing, multiplier: 1.0, constant: 0),
			
			// Info Multi
			NSLayoutConstraint(item: infoMulti, attribute: .leading, relatedBy: .equal, toItem: multiIcon, attribute: .trailing, multiplier: 1.0, constant: 6),
			NSLayoutConstraint(item: infoMulti, attribute: .top, relatedBy: .equal, toItem: infoScore, attribute: .bottom, multiplier: 1.0, constant: 2),
			NSLayoutConstraint(item: infoMulti, attribute: .trailing, relatedBy: .equal, toItem: infoScore, attribute: .trailing, multiplier: 1.0, constant: 0),
			
			// Multi Icon
			NSLayoutConstraint(item: multiIcon, attribute: .top, relatedBy: .equal, toItem: infoMulti, attribute: .top, multiplier: 1.0, constant: 2),
			NSLayoutConstraint(item: multiIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18),
			NSLayoutConstraint(item: multiIcon, attribute: .width, relatedBy: .equal, toItem: multiIcon, attribute: .height, multiplier: 1.0, constant: 0),
			
			// Info High
			NSLayoutConstraint(item: infoHigh, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoHigh, attribute: .top, relatedBy: .equal, toItem: multiIcon, attribute: .bottom, multiplier: 1.0, constant: 2),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: infoHigh, attribute: .bottom, multiplier: 1.0, constant: 0)
			
		])
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateScore(newScore: Int) {
	
		infoScore.text = "\(newScore)"
		
		if newScore > 0 {
			infoScore.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
			UIView.animate(withDuration: 0.3, animations: {
				self.infoScore.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
			})
		}
	
	}

	func updateTimer(newTime: Int) {
	
		let timerMinutes = Int(floor(Double(newTime) / 60.0))
		let timerSeconds = newTime - (timerMinutes * 60)
		
		infoTimer.text = String(format: "%02d:%02d", timerMinutes, timerSeconds)
		
	}
	
	func updateMulti(zombieImage: String) {
	
		infoMulti.text = "1.5x"
		multiIcon.image = UIImage(named: zombieImage)
	
	}

}
