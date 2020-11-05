//
//  RecipeListing.swift
//  ios-sample-listing
//
//  Created by Meng on 03/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import SwiftyXMLParser
import Foundation
import UIKit


class RecipeListing : UIViewController {
	
	var recipes: [Recipe] = []
	var recipes_: [Recipe] = []
	var recipeTitle = ""
	
	var currentFilter = "All"
	var types: [String] = []

	@IBOutlet var tv: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Recipes"
		
		let button = Button()
		button.setTitle("ADD", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.tintColorDidChange()
		button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
		button.onTappedListener = {
			let recipeForm = RecipeForm()
			recipeForm.completion = {
				self.recipes = RecipeManager.instance.recipes
				self.tv.reloadData()
			}
			self.navigationController?.show(recipeForm, sender: self)
		}

		self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button)]
		
		self.recipes = RecipeManager.instance.recipes
		self.recipes_ = self.recipes

		self.tv.delegate = self
		self.tv.dataSource = self
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		RecipeManager.instance.save()
	}
	
}

extension RecipeListing: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.recipes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?.first as? Cell else {
			fatalError("The dequeued cell is not an instance of Cell")
		}
		
		let recipe = self.recipes[indexPath.row]
		cell.labelTitle?.text = recipe.title
		cell.labelDetail?.text = recipe.type
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let recipeForm = RecipeForm()
		recipeForm.recipe = self.recipes[indexPath.row]
		recipeForm.completion = {
			self.recipes = RecipeManager.instance.recipes
			self.tv.reloadData()
		}
		
		self.navigationController?.show(recipeForm, sender: self)
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			// Delete the row from the data source
			RecipeManager.instance.remove(recipe: self.recipes[indexPath.row]) {
				self.recipes.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .none)
				tableView.reloadData()
			}
			
		}
	}
}
