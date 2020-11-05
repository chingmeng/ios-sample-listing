//
//  RecipeForm.swift
//  ios-sample-listing
//
//  Created by Meng on 05/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class RecipeForm : UIViewController {
	
	var recipe: Recipe? = nil
	var types: [String] = []
	
	var completion: () -> Void = {}

	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var textFieldTitle: UITextField!
	@IBOutlet var textFieldImageUrl: UITextField!
	@IBOutlet var textViewIngredients: UITextView!
	@IBOutlet var textViewPreparation: UITextView!
	@IBOutlet var textFieldRecipeType: UITextField!
	@IBOutlet var imageViewRecipe: UIImageView!
	
	static func newInstance(recipe: Recipe) -> RecipeForm {
		let recipeForm = RecipeForm()
		recipeForm.recipe = recipe
		return recipeForm
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Screen configuration
		self.setupCreateButton()
		self.navigationItem.title = "New Recipe"
		self.scrollView.showsVerticalScrollIndicator = false
		
		// Setup delegates
		self.textFieldImageUrl.delegate = self
		
		// Prepare recipe types data
		self.types = RecipeManager.instance.loadRecipeType()
		
		// Setup image if available else use placeholder
		self.imageViewRecipe.image = .actions
		if let recipe = self.recipe  {
			self.loadImage(url: recipe.image)
		}
		
		// Setup fields
		self.textFieldTitle.text = recipe?.title
		self.textFieldImageUrl.text = self.recipe?.image
		
		/// Prepare Recipe type picker field
		let recipeTypePicker = UIPickerView()
		recipeTypePicker.delegate = self
		
		self.textFieldRecipeType.text = self.recipe?.type
		self.textFieldRecipeType.inputView = recipeTypePicker
		
		/// Prepare ingerdient field
		self.textViewIngredients.text = self.recipe?.ingredients
		self.textViewIngredients.sizeToFit()

		/// Prepare Preparation field
		self.textViewPreparation.text = self.recipe?.preparation
		self.textViewPreparation.sizeToFit()
		
	}
	
	private func loadImage(url: String) {
		self.imageViewRecipe.kf.indicatorType = .activity
		self.imageViewRecipe.kf.setImage(
			with: URL(string: url),
			placeholder: UIImage.actions,
			options: [
				.scaleFactor(UIScreen.main.scale),
				.transition(.fade(1)),
				.cacheOriginalImage
		])
		
		self.imageViewRecipe?.contentMode = .scaleAspectFill
		self.imageViewRecipe?.clipsToBounds = true

	}
	
	private func setupCreateButton() {
		
		let button = Button()
		if self.recipe == nil {
			button.setTitle("ADD", for: .normal)
		} else {
			button.setTitle("UPDATE", for: .normal)
		}
		button.setTitleColor(.systemBlue, for: .normal)
		button.tintColorDidChange()
		button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
		button.onTappedListener = {
			
			if self.recipe == nil {
				// For creating new recipe
				self.recipe = Recipe(
					id: String(Int.random(in: 100..<9999)),
					title: self.textFieldTitle.text ?? "-",
					type: self.textFieldRecipeType.text ?? "-",
					ingredients: self.textViewIngredients.text ?? "-",
					preparation: self.textViewPreparation.text ?? "-",
					image: self.textFieldImageUrl.text ?? "-",
					comment: "")
				RecipeManager.instance.recipes.append(self.recipe!)
			} else {
				self.recipe?.title = self.textFieldTitle.text ?? "-"
				self.recipe?.type = self.textFieldRecipeType.text ?? "-"
				self.recipe?.ingredients = self.textViewIngredients.text ?? "-"
				self.recipe?.preparation = self.textViewPreparation.text ?? "-"
				self.recipe?.image = self.textFieldImageUrl.text ?? "-"
				self.recipe?.comment = ""
				RecipeManager.instance.update(recipe: self.recipe!)
			}
			
			// After create or update, then validate the fields
			if self.textFieldTitle.text != "" && self.textFieldRecipeType.text != "" {
				self.navigationController?.popViewController(animated: true)
				self.completion()
			} else {
				self.showAlert()
			}
	
		}
		
		self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button)]
	}

	private func showAlert() {
		// Initialize Alert Controller
		let alertController = UIAlertController(title: "Invalid input", message: "Please enter all require field.", preferredStyle: .alert)
	    alertController.addAction(UIAlertAction(title: "OKAY", style: .default, handler: nil))
		self.present(alertController, animated: true, completion: nil)
	}
	
}

extension RecipeForm: UITextFieldDelegate {
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == self.textFieldImageUrl {
			self.textFieldImageUrl.text = textField.text
			self.loadImage(url: textField.text!)
		}
	}

}

extension RecipeForm: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.types.count
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.textFieldRecipeType.text = self.types[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.types[row]
	}
	
	
}
