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

	let infoTimer = UILabel(frame: CGRect.zero)
	let infoScore = UILabel(frame: CGRect.zero)
	
	init(gameTime: Int) {
		super.init(frame: CGRect.zero)
		
		updateTimer(newTime: gameTime)
		updateScore(newScore: 0)
		
		infoTimer.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
		infoScore.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
		
		infoTimer.alpha = 0.40
		infoScore.alpha = 0.40
		infoTimer.textColor = UIColor.white
		infoScore.textColor = UIColor.white
		infoTimer.textAlignment = .left
		infoScore.textAlignment = .right
		
		infoTimer.translatesAutoresizingMaskIntoConstraints = false
		infoScore.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(infoTimer)
		self.addSubview(infoScore)
		
		self.addConstraints([
		
			// Info Timer
			NSLayoutConstraint(item: infoTimer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoTimer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: infoTimer, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoTimer, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0),
			
			// Info Score
			NSLayoutConstraint(item: infoScore, attribute: .leading, relatedBy: .equal, toItem: infoTimer, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoScore, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: infoScore, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: infoScore, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoScore, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0)
		
		])
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateScore(newScore: Int) { infoScore.text = "\(newScore)" }

	func updateTimer(newTime: Int) {
	
		let timerMinutes = Int(floor(Double(newTime) / 60.0))
		let timerSeconds = newTime - (timerMinutes * 60)
		
		infoTimer.text = String(format: "%02d:%02d", timerMinutes, timerSeconds)
		
	}

}
