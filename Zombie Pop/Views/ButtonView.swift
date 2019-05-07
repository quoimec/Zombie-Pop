//
//  ButtonView.swift
//  Zombie Pop
//
//  Created by Charlie on 6/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class ButtonView: UIView {

	let buttonLabel = UILabel()
	
	init(buttonText: String) {
		super.init(frame: CGRect.zero)
		
		self.backgroundColor = UIColor(red: 0.64, green: 0.14, blue: 0.21, alpha: 0.8)
		self.layer.cornerRadius = 16
		
		buttonLabel.text = buttonText
		buttonLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
		buttonLabel.textColor = UIColor.white
		buttonLabel.textAlignment = .center
		
		buttonLabel.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(buttonLabel)
		
		self.addConstraints([
		
			// Button Label
			NSLayoutConstraint(item: buttonLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: buttonLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: buttonLabel, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: buttonLabel, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: buttonLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 42)
		
		])
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
