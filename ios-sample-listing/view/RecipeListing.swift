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
		button.setImage(.add, for: .normal)
		button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
		button.onTappedListener = {
			
			let pickerViewController = RecipeTypePicker()
			pickerViewController.selectedType = self.currentFilter
			pickerViewController.completion = { selected in
				if selected != "All" {
					self.recipes = self.recipes_.filter { r in r.type == selected }
				} else {
					self.recipes = self.recipes_
				}
				self.tv.reloadData()
				self.currentFilter = selected
			}
			self.present(UINavigationController(rootViewController: pickerViewController), animated: true)

		}

		self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button)]
		
		self.getXMLData()

		self.tv.delegate = self
		self.tv.dataSource = self
	}
	
	private func getXMLData() {
		if let path = Bundle.main.url(forResource: "recipe", withExtension: "xml") {
			// parse xml document
			let str = try! String.init(contentsOf: path)
			let xml = try! XML.parse(str)
			
			print(str)
			// enumerate child Elements in the parent Element
			for item in xml["recipes", "recipe"] {
				
				print("parsing....")
				
				var ingredients: [Ingredient] = []
				var preparations: [String] = []
				
				for i in item["ingredient"] {
					let ingredient = Ingredient(
						name: i.attributes["name"] ?? "-",
						amount: i.attributes["amount"] ?? "-",
						unit: i.attributes["unit"] ?? "-",
						nutrition: i.attributes["nutrition"] ?? "-")
					ingredients.append(ingredient)
				}
				
				for i in item["preparation"]["step"] {
					preparations.append(i.text ?? "-")
				}
				
				let recipe = Recipe(
					title: item["title"].text ?? "-",
					type: item["type"].text ?? "-",
					ingredients: ingredients,
					preparation: preparations,
					image: item["image"].text ?? "-",
					comment: item["comment"].text ?? "-")
				
				self.recipes.append(recipe)
				
			}
			
			self.recipes_ = self.recipes
			
		}
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
		let recipeDetail = RecipeDetail()
		recipeDetail.recipe = self.recipes[indexPath.row]
		self.navigationController?.show(recipeDetail, sender: self)
	}
}
