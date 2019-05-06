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
	let difficultySegments = SegmentView()
	let timeSlider = SliderView(header: "Game Time", minimum: 0, maximum: 120, type: .Int)
	let tickSlider = SliderView(header: "Game Ticks", minimum: 0.25, maximum: 1.0, type: .Float)
	let spawnSlider = SliderView(header: "Spawn Rate", minimum: 0.5, maximum: 2.0, type: .Float)
	let despawnSlider = SliderView(header: "Despawn Rate", minimum: 0.0, maximum: 1.0, type: .Float)
	let spacingSlider = SliderView(header: "Zombie Spacing", minimum: 1.0, maximum: 1.5, type: .Float)

	init(passedSettings: SettingsModel) {
		super.init(nibName: nil, bundle: nil)
		
		if let settingsDifficulty = passedSettings.settingsDifficulty {
			difficultySegments.settingsSegment.selectedSegmentIndex = settingsDifficulty.rawValue
		}
		
		timeSlider.settingsSlider.value = Float(passedSettings.gameTime)
		tickSlider.settingsSlider.value = passedSettings.gameTicks
		spawnSlider.settingsSlider.value = passedSettings.spawnRate
		despawnSlider.settingsSlider.value = passedSettings.despawnRate
		spacingSlider.settingsSlider.value = passedSettings.zombieSpacing
		
		timeSlider.updateValue(passedValue: Float(passedSettings.gameTime))
		tickSlider.updateValue(passedValue: passedSettings.gameTicks)
		spawnSlider.updateValue(passedValue: passedSettings.spawnRate)
		despawnSlider.updateValue(passedValue: passedSettings.despawnRate)
		spacingSlider.updateValue(passedValue: passedSettings.zombieSpacing)
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		settingsHeader.text = "Settings"
		settingsHeader.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
		settingsHeader.textColor = UIColor(red: 0.01, green: 0.01, blue: 0.16, alpha: 1.00)
		
		settingsScroll.alwaysBounceVertical = true
		settingsScroll.showsVerticalScrollIndicator = false
		
		settingsHeader.translatesAutoresizingMaskIntoConstraints = false
		settingsScroll.translatesAutoresizingMaskIntoConstraints = false
		difficultySegments.translatesAutoresizingMaskIntoConstraints = false
		timeSlider.translatesAutoresizingMaskIntoConstraints = false
		tickSlider.translatesAutoresizingMaskIntoConstraints = false
		spawnSlider.translatesAutoresizingMaskIntoConstraints = false
		despawnSlider.translatesAutoresizingMaskIntoConstraints = false
		spacingSlider.translatesAutoresizingMaskIntoConstraints = false
		
		settingsScroll.addSubview(difficultySegments)
		settingsScroll.addSubview(timeSlider)
		settingsScroll.addSubview(tickSlider)
		settingsScroll.addSubview(spawnSlider)
		settingsScroll.addSubview(despawnSlider)
		settingsScroll.addSubview(spacingSlider)
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
		
			// Difficulty Segments
			NSLayoutConstraint(item: difficultySegments, attribute: .leading, relatedBy: .equal, toItem: settingsScroll, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: difficultySegments, attribute: .top, relatedBy: .equal, toItem: settingsScroll, attribute: .top, multiplier: 1.0, constant: 10),
			NSLayoutConstraint(item: settingsScroll, attribute: .trailing, relatedBy: .equal, toItem: difficultySegments, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: difficultySegments, attribute: .width, relatedBy: .equal, toItem: settingsScroll, attribute: .width, multiplier: 1.0, constant: 0),
		
			// Time Slider
			NSLayoutConstraint(item: timeSlider, attribute: .leading, relatedBy: .equal, toItem: settingsScroll, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeSlider, attribute: .top, relatedBy: .equal, toItem: difficultySegments, attribute: .bottom, multiplier: 1.0, constant: 60),
			NSLayoutConstraint(item: settingsScroll, attribute: .trailing, relatedBy: .equal, toItem: timeSlider, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: timeSlider, attribute: .width, relatedBy: .equal, toItem: settingsScroll, attribute: .width, multiplier: 1.0, constant: 0),
			
			// Tick Slider
			NSLayoutConstraint(item: tickSlider, attribute: .leading, relatedBy: .equal, toItem: settingsScroll, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: tickSlider, attribute: .top, relatedBy: .equal, toItem: timeSlider, attribute: .bottom, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: settingsScroll, attribute: .trailing, relatedBy: .equal, toItem: tickSlider, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: tickSlider, attribute: .width, relatedBy: .equal, toItem: settingsScroll, attribute: .width, multiplier: 1.0, constant: 0),
			
			// Spawn Slider
			NSLayoutConstraint(item: spawnSlider, attribute: .leading, relatedBy: .equal, toItem: settingsScroll, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: spawnSlider, attribute: .top, relatedBy: .equal, toItem: tickSlider, attribute: .bottom, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: settingsScroll, attribute: .trailing, relatedBy: .equal, toItem: spawnSlider, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: spawnSlider, attribute: .width, relatedBy: .equal, toItem: settingsScroll, attribute: .width, multiplier: 1.0, constant: 0),
			
			// Despawn Slider
			NSLayoutConstraint(item: despawnSlider, attribute: .leading, relatedBy: .equal, toItem: settingsScroll, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: despawnSlider, attribute: .top, relatedBy: .equal, toItem: spawnSlider, attribute: .bottom, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: settingsScroll, attribute: .trailing, relatedBy: .equal, toItem: despawnSlider, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: despawnSlider, attribute: .width, relatedBy: .equal, toItem: settingsScroll, attribute: .width, multiplier: 1.0, constant: 0),
			
			// Spacing Slider
			NSLayoutConstraint(item: spacingSlider, attribute: .leading, relatedBy: .equal, toItem: settingsScroll, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: spacingSlider, attribute: .top, relatedBy: .equal, toItem: despawnSlider, attribute: .bottom, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: settingsScroll, attribute: .trailing, relatedBy: .equal, toItem: spacingSlider, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: spacingSlider, attribute: .width, relatedBy: .equal, toItem: settingsScroll, attribute: .width, multiplier: 1.0, constant: 0)
		
		])
		
		difficultySegments.settingsSegment.addTarget(self, action: #selector(segmentUpdate(segment:)), for: UIControl.Event.valueChanged)
		
		timeSlider.settingsSlider.addTarget(self, action: #selector(timeUpdate(slider:)), for: UIControl.Event.valueChanged)
		tickSlider.settingsSlider.addTarget(self, action: #selector(tickUpdate(slider:)), for: UIControl.Event.valueChanged)
		spawnSlider.settingsSlider.addTarget(self, action: #selector(spawnUpdate(slider:)), for: UIControl.Event.valueChanged)
		despawnSlider.settingsSlider.addTarget(self, action: #selector(despawnUpdate(slider:)), for: UIControl.Event.valueChanged)
		spacingSlider.settingsSlider.addTarget(self, action: #selector(spacingUpdate(slider:)), for: UIControl.Event.valueChanged)
		
		timeSlider.settingsSlider.addTarget(self, action: #selector(sliderTouched), for: UIControl.Event.touchDown)
		tickSlider.settingsSlider.addTarget(self, action: #selector(sliderTouched), for: UIControl.Event.touchDown)
		spawnSlider.settingsSlider.addTarget(self, action: #selector(sliderTouched), for: UIControl.Event.touchDown)
		despawnSlider.settingsSlider.addTarget(self, action: #selector(sliderTouched), for: UIControl.Event.touchDown)
		spacingSlider.settingsSlider.addTarget(self, action: #selector(sliderTouched), for: UIControl.Event.touchDown)
		
	
	}

}

extension SettingsController {

	// Update Functions
	
	@objc func segmentUpdate(segment: UISegmentedControl) {
	
		guard let settingsDifficulty = SettingsDifficulty.init(rawValue: segment.selectedSegmentIndex) else {
			return
		}
		
		let settingsModel = SettingsModel(fromDifficulty: settingsDifficulty)
		
		timeSlider.settingsSlider.value = Float(settingsModel.gameTime)
		tickSlider.settingsSlider.value = settingsModel.gameTicks
		spawnSlider.settingsSlider.value = settingsModel.spawnRate
		despawnSlider.settingsSlider.value = settingsModel.despawnRate
		spacingSlider.settingsSlider.value = settingsModel.zombieSpacing
		
		timeUpdate(slider: timeSlider.settingsSlider)
		tickUpdate(slider: tickSlider.settingsSlider)
		spawnUpdate(slider: spawnSlider.settingsSlider)
		despawnUpdate(slider: despawnSlider.settingsSlider)
		spacingUpdate(slider: spacingSlider.settingsSlider)
	
	}

	@objc func sliderTouched() { difficultySegments.settingsSegment.selectedSegmentIndex = UISegmentedControl.noSegment }

	@objc func timeUpdate(slider: UISlider) { timeSlider.updateValue(passedValue: slider.value) }
	
	@objc func tickUpdate(slider: UISlider) { tickSlider.updateValue(passedValue: slider.value) }
	
	@objc func spawnUpdate(slider: UISlider) { spawnSlider.updateValue(passedValue: slider.value) }
	
	@objc func despawnUpdate(slider: UISlider) { despawnSlider.updateValue(passedValue: slider.value) }
	
	@objc func spacingUpdate(slider: UISlider) { spacingSlider.updateValue(passedValue: slider.value) }
	
}
