//
//  NavigationController.swift
//  Zombie Pop
//
//  Created by Charlie on 5/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {

	/*	Navigaiton Controller
	
		- Extremely simple class, only exists to turn the navigation bar off by default.

	*/

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.isNavigationBarHidden = true
	
	}

}
