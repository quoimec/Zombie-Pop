//
//  ScrubbingView.swift
//  Zombie Pop
//
//  Created by Charlie on 5/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class SliderView: UIView {

	let settingsHeader = UILabel()
	let settingsSlider = UISlider()
	let settingsValue = UILabel()
	let stringFormatter: String
	
	init(header: String, minimum: Float, maximum: Float, type: SettingsType) {
		
		switch type {
		
			case .Float:
			stringFormatter = "%.02f"
			
			case .Int:
			stringFormatter = "%.0f"
		
		}
		
		super.init(frame: CGRect.zero)
	
		settingsHeader.text = header
		settingsHeader.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		settingsHeader.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		
		settingsValue.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
		settingsValue.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 0.60)
		settingsValue.textAlignment = .center
		
		settingsSlider.maximumValue = maximum
		settingsSlider.minimumValue = minimum
		settingsSlider.isContinuous = true
		settingsSlider.thumbTintColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
		settingsSlider.minimumTrackTintColor = UIColor(red: 0.69, green: 0.20, blue: 0.29, alpha: 1.00)
		settingsSlider.maximumTrackTintColor = UIColor(red: 0.93, green: 0.83, blue: 0.85, alpha: 1.00)
		
		settingsHeader.translatesAutoresizingMaskIntoConstraints = false
		settingsSlider.translatesAutoresizingMaskIntoConstraints = false
		settingsValue.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(settingsHeader)
		self.addSubview(settingsSlider)
		self.addSubview(settingsValue)
		
		self.addConstraints([
		
			// Settings Header
			NSLayoutConstraint(item: settingsHeader, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: settingsHeader, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: settingsHeader, attribute: .trailing, multiplier: 1.0, constant: 0),
			
			// Settings Slider
			NSLayoutConstraint(item: settingsSlider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: settingsSlider, attribute: .top, relatedBy: .equal, toItem: settingsHeader, attribute: .bottom, multiplier: 1.0, constant: 4),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: settingsSlider, attribute: .trailing, multiplier: 1.0, constant: 80),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: settingsSlider, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Settings Value
			NSLayoutConstraint(item: settingsValue, attribute: .leading, relatedBy: .equal, toItem: settingsSlider, attribute: .trailing, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: settingsValue, attribute: .top, relatedBy: .equal, toItem: settingsSlider, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: settingsValue, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: settingsSlider, attribute: .bottom, relatedBy: .equal, toItem: settingsValue, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateValue(passedValue: Float) {
		settingsValue.text = String(format: stringFormatter, passedValue)
	}
	
}
