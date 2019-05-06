//
//  SegmentView.swift
//  Zombie Pop
//
//  Created by Charlie on 6/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class SegmentView: UIView {

	let settingsHeader = UILabel()
	let settingsSegment = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
	
	init() {
		super.init(frame: CGRect.zero)
		
		settingsHeader.text = "Difficulty Presets"
		settingsHeader.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		settingsHeader.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		
		settingsSegment.tintColor = UIColor(red: 0.69, green: 0.20, blue: 0.29, alpha: 1.00)
		settingsSegment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)], for: .normal)
		
		settingsHeader.translatesAutoresizingMaskIntoConstraints = false
		settingsSegment.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(settingsHeader)
		self.addSubview(settingsSegment)
		
		self.addConstraints([
		
			// Settings Header
			NSLayoutConstraint(item: settingsHeader, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: settingsHeader, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: settingsHeader, attribute: .trailing, multiplier: 1.0, constant: 0),
			
			// Settings Slider
			NSLayoutConstraint(item: settingsSegment, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: settingsSegment, attribute: .top, relatedBy: .equal, toItem: settingsHeader, attribute: .bottom, multiplier: 1.0, constant: 12),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: settingsSegment, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: settingsSegment, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
