//
//  InputView.swift
//  Zombie Pop
//
//  Created by Charlie on 6/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class InputView: UIView {

	/*	Input View

		- Describes the text input view presented at the end of the game for the users name input.
		- The delegate methods for this view can be found inside the Game Controller.

	*/

	let nameLabel = UILabel()
	let nameView = UIView()
	let nameInput = UITextField()

	init() {
		super.init(frame: CGRect.zero)
		
		nameLabel.text = "Enter Your Name:"
		
		nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
		nameInput.font = UIFont.systemFont(ofSize: 14, weight: .bold)

		nameLabel.textColor = UIColor.white
		nameInput.textColor = UIColor.white
		nameInput.tintColor = UIColor(red: 0.64, green: 0.14, blue: 0.21, alpha: 0.6)
		nameInput.keyboardType = .namePhonePad
		nameInput.returnKeyType = .go
		nameInput.keyboardAppearance = .dark
		
		nameView.layer.cornerRadius = 20
		nameView.backgroundColor = UIColor.init(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.20)
		
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameView.translatesAutoresizingMaskIntoConstraints = false
		nameInput.translatesAutoresizingMaskIntoConstraints = false
		
		nameView.addSubview(nameInput)
		self.addSubview(nameLabel)
		self.addSubview(nameView)
		
		nameView.addConstraints([
		
			// Name Input
			NSLayoutConstraint(item: nameInput, attribute: .leading, relatedBy: .equal, toItem: nameView, attribute: .leading, multiplier: 1.0, constant: 14),
			NSLayoutConstraint(item: nameInput, attribute: .top, relatedBy: .equal, toItem: nameView, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: nameView, attribute: .trailing, relatedBy: .equal, toItem: nameInput, attribute: .trailing, multiplier: 1.0, constant: 14),
			NSLayoutConstraint(item: nameView, attribute: .bottom, relatedBy: .equal, toItem: nameInput, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
		self.addConstraints([
		
			// Name Label
			NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 48),
			NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: nameLabel, attribute: .trailing, multiplier: 1.0, constant: 48),
			
			// Name View
			NSLayoutConstraint(item: nameView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: nameView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1.0, constant: 4),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: nameView, attribute: .trailing, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: nameView, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: nameView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
		
		])
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
