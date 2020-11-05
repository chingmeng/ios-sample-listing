//
//  File.swift
//  ios-sample-listing
//
//  Created by Meng on 04/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class RecipeManager {
	
	static let instance = RecipeManager()
	var recipes: [Recipe] = []
	
	private init() {
		self.loadRecipeData()
	}
	
	func save() {
		// save recipes into disk
		DiskManager.instance.save(list: self.recipes, diskPath: "recipes.json")
	}
	
	func update(recipe: Recipe) {
		guard let index = self.recipes.firstIndex(of: recipe) else { return }
		self.recipes[index] = recipe
		self.save()
	}
	
	func remove(recipe: Recipe, completion: (() -> Void)? = nil) {
		guard let index = self.recipes.firstIndex(of: recipe) else { return }
		self.recipes.remove(at: index)
		completion?()
		self.save()
	}
	
	func loadRecipeType() -> [String] {
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
			
			return types
		}
		return []
	}
	
	private func loadRecipeData() {
		// If user have saved data then use
		self.recipes = self.loadFromDisk()
		if self.recipes.count == 0 {
			// If user doesn't have saved data, then
			self.recipes = self.loadDefaultRecipeData()
		}
	}
	
	private func loadFromDisk() -> [Recipe] {
		return DiskManager.instance.load(diskPath: "recipes.json")
	}
	
	
	private func loadDefaultRecipeData() -> [Recipe] {
		if let path = Bundle.main.url(forResource: "recipe", withExtension: "xml") {
			// parse xml document
			let str = try! String.init(contentsOf: path)
			let xml = try! XML.parse(str)
			
			var recipes: [Recipe] = []
			
			// enumerate child Elements in the parent Element
			for item in xml["recipes", "recipe"] {
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
				
				let ingredients__ =  ingredients.map{ e in e.name }
				let ingredientString = " - " + ingredients__.joined(separator: "\n - ")
				let prepartionString = preparations.map { e in e.trimmingCharacters(in: .whitespaces)}.joined(separator: "\n\n")
				
				let recipe = Recipe(
					id: item["id"].text ?? "0",
					title: item["title"].text ?? "-",
					type: item["type"].text ?? "-",
					ingredients: ingredientString,
					preparation: prepartionString,
					image: item["image"].text ?? "-",
					comment: item["comment"].text ?? "-")
				
				recipes.append(recipe)
				
			}
			
			return recipes
			
		}
		return []
	}
	
}
