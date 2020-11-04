//
//  RecipeTypePicker.swift
//  ios-sample-listing
//
//  Created by Meng on 04/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import UIKit
import SwiftyXMLParser

class RecipeTypePicker : UIViewController {
	
	@IBOutlet var pickerView: UIPickerView!
	
	var types: [String] = []
	var completion: ((String) -> Void)? = nil
	var selectedType: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.pickerView.delegate = self
		self.pickerView.dataSource = self
		

		let doneButton = Button()
		doneButton.setTitle("DONE", for: .normal)
		doneButton.setTitleColor(.systemBlue, for: .normal)
		doneButton.tintColorDidChange()
		doneButton.onTappedListener = {
			self.navigationController?.dismiss(animated: true) {
				self.completion?(self.selectedType)
			}
		}
		
		self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: doneButton)]
		
		let cancelButton = Button()
		cancelButton.setTitle("CANCEL", for: .normal)
		cancelButton.setTitleColor(.systemBlue, for: .normal)
		cancelButton.tintColorDidChange()
		cancelButton.onTappedListener = {
			self.navigationController?.dismiss(animated: true)
		}
		
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: cancelButton)]
		self.navigationItem.title = "Recipe Type"

		
		self.getRecipeType()
		self.pickerView.selectRow(self.types.firstIndex(of: self.selectedType) ?? 0, inComponent:0, animated:true)

	}
	
	func getRecipeType() {
		if let path = Bundle.main.url(forResource: "recipetype", withExtension: "xml") {
			// parse xml document
			let str = try! String.init(contentsOf: path)
			let xml = try! XML.parse(str)
			
			var types: [String] = []
			
			// enumerate child Elements in the parent Element
			for item in xml["recipetypes"] {
				for i in item["recipetype"] {
					types.append(i["name"].text ?? "-")
				}
			}
			
			self.types = types
		}
	}
}


extension RecipeTypePicker: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.types.count
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.selectedType = self.types[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.types[row]
	}

	
}
