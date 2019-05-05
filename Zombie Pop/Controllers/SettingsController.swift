//
//  SettingsController.swift
//  Zombie Pop
//
//  Created by Charlie on 5/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UIViewController {

	let settingsHeader = UILabel()
	let settingsScroll = UIScrollView()
	let timeSlider = SliderView(header: "Game Time", minimum: 0, maximum: 120)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		settingsHeader.text = "Settings"
		settingsHeader.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
		settingsHeader.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		
		settingsScroll.alwaysBounceVertical = true
		settingsScroll.showsVerticalScrollIndicator = false
		
		timeSlider.settingsValue.text = "60"
		timeSlider.settingsSlider.value = 60.0
		
		settingsHeader.translatesAutoresizingMaskIntoConstraints = false
		settingsScroll.translatesAutoresizingMaskIntoConstraints = false
		timeSlider.translatesAutoresizingMaskIntoConstraints = false
		
		settingsScroll.addSubview(timeSlider)
		self.view.addSubview(settingsHeader)
		self.view.addSubview(settingsScroll)
		
		self.view.addConstraints([
		
			// Settings Header
			NSLayoutConstraint(item: settingsHeader, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: settingsHeader, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 60),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: settingsHeader, attribute: .trailing, multiplier: 1.0, constant: 20),
			
			// Settings Scroll
			NSLayoutConstraint(item: settingsScroll, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: settingsScroll, attribute: .top, relatedBy: .equal, toItem: settingsHeader, attribute: .bottom, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: settingsScroll, attribute: .trailing, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: settingsScroll, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
		settingsScroll.addConstraints([
		
			// Time Slider
			NSLayoutConstraint(item: timeSlider, attribute: .leading, relatedBy: .equal, toItem: settingsScroll, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeSlider, attribute: .top, relatedBy: .equal, toItem: settingsScroll, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: settingsScroll, attribute: .trailing, relatedBy: .equal, toItem: timeSlider, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeSlider, attribute: .width, relatedBy: .equal, toItem: settingsScroll, attribute: .width, multiplier: 1.0, constant: 0),
		
		])
		
		timeSlider.settingsSlider.addTarget(self, action: #selector(timeUpdate(slider:)), for: UIControl.Event.valueChanged)
		timeSlider.settingsSlider.addTarget(self, action: #selector(timeFinish(slider:)), for: [UIControl.Event.touchUpInside, UIControl.Event.touchUpOutside])
		
	
	}

}

extension SettingsController {

	@objc func timeUpdate(slider: UISlider) { timeSlider.settingsValue.text = "\(Int(slider.value))" }
	
	@objc func timeFinish(slider: UISlider) { print("FINISH") }

}
