//
//  NightView.swift
//  Zombie Pop
//
//  Created by Charlie on 4/5/19.
//  Copyright © 2019 Schacher. All rights reserved.
//

import Foundation
import UIKit

class NightView: UIImageView {

	init() {
		super.init(frame: CGRect.zero)
		
		self.image = UIImage(named: "Night Overlay")
	
	}
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool { return false }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
