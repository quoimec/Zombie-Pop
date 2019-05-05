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
	let infoMulti = UILabel(frame: CGRect.zero)
	let multiIcon = UIImageView(frame: CGRect.zero)
	
	init(gameTime: Int) {
		super.init(frame: CGRect.zero)
		
		updateTimer(newTime: gameTime)
		updateScore(newScore: 0)
		
		infoTimer.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
		infoScore.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
		infoMulti.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
		
		infoTimer.alpha = 0.40
		infoScore.alpha = 0.40
		infoMulti.alpha = 0.40
		infoTimer.textColor = UIColor.white
		infoScore.textColor = UIColor.white
		infoMulti.textColor = UIColor.white
		infoTimer.textAlignment = .left
		infoScore.textAlignment = .right
		infoMulti.textAlignment = .right
		
		infoTimer.translatesAutoresizingMaskIntoConstraints = false
		infoScore.translatesAutoresizingMaskIntoConstraints = false
		infoMulti.translatesAutoresizingMaskIntoConstraints = false
		multiIcon.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(infoTimer)
		self.addSubview(infoScore)
		self.addSubview(infoMulti)
		self.addSubview(multiIcon)
		
		self.addConstraints([
		
			// Info Timer
			NSLayoutConstraint(item: infoTimer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoTimer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoTimer, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0),
			
			// Info Score
			NSLayoutConstraint(item: infoScore, attribute: .leading, relatedBy: .equal, toItem: infoTimer, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoScore, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: infoScore, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: infoScore, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0),
			
			// Info Multi
			NSLayoutConstraint(item: infoMulti, attribute: .leading, relatedBy: .equal, toItem: multiIcon, attribute: .trailing, multiplier: 1.0, constant: 6),
			NSLayoutConstraint(item: infoMulti, attribute: .top, relatedBy: .equal, toItem: infoScore, attribute: .bottom, multiplier: 1.0, constant: 2),
			NSLayoutConstraint(item: infoMulti, attribute: .trailing, relatedBy: .equal, toItem: infoScore, attribute: .trailing, multiplier: 1.0, constant: 0),
			
			// Multi Icon
			NSLayoutConstraint(item: multiIcon, attribute: .top, relatedBy: .equal, toItem: infoMulti, attribute: .top, multiplier: 1.0, constant: 2),
			NSLayoutConstraint(item: multiIcon, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: multiIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18),
			NSLayoutConstraint(item: multiIcon, attribute: .width, relatedBy: .equal, toItem: multiIcon, attribute: .height, multiplier: 1.0, constant: 0)
			
		
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
	
	func updateMulti(zombieImage: String) {
	
		infoMulti.text = "1.5x"
		multiIcon.image = UIImage(named: zombieImage)
	
	}

}
