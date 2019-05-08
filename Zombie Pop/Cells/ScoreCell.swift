//
//  ScoreCell.swift
//  Zombie Pop
//
//  Created by Charlie on 6/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class ScoreCell: UITableViewCell {

	/*	Score Cell

		- Describes the standardised cell used to display a players score in the Scores Controller.

	*/

	let playerName = UILabel()
	let playerScore = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.selectionStyle = .none
		
		playerName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		playerScore.font = UIFont.systemFont(ofSize: 16, weight: .black)
		playerName.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		playerScore.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		playerScore.textAlignment = .right
		
		playerName.translatesAutoresizingMaskIntoConstraints = false
		playerScore.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(playerName)
		self.addSubview(playerScore)
		
		self.addConstraints([
		
			// Player Name
			NSLayoutConstraint(item: playerName, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: playerName, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: playerName, attribute: .bottom, multiplier: 1.0, constant: 10),
			
			// Player Score
			NSLayoutConstraint(item: playerScore, attribute: .leading, relatedBy: .equal, toItem: playerName, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: playerScore, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: playerScore, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: playerScore, attribute: .bottom, multiplier: 1.0, constant: 10),
			
		])
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
