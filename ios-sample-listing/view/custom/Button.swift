//
//  Button.swift
//  ios-sample-listing
//
//  Created by Meng on 04/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import UIKit

class Button: UIButton {
	
	var onTappedListener:()-> Void = {}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSubviews()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initSubviews()
	}
	
	func initSubviews() {
		self.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
	}
	
	@objc func onTapped(sender: UIButton!) {
		self.onTappedListener()
	}
	
}
