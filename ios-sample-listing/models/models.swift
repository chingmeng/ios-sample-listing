//
//  models.swift
//  ios-sample-listing
//
//  Created by Meng on 04/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import Foundation


struct Recipe : Codable, Hashable, Comparable {

	var id: String = ""
	var title: String = ""
	var type: String = ""
	var ingredients: String = ""
	var preparation: String = ""
	var image: String = ""
	var comment: String = ""
	
	private enum CodingKeys : String, CodingKey {
		case id, title, type, ingredients, preparation, image, comment
	}
	
	static func == (lhs: Recipe, rhs: Recipe) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func < (lhs: Recipe, rhs: Recipe) -> Bool {
		return lhs.id < rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
	
	
}

struct Ingredient {
	var name: String
	var amount: String
	var unit: String
	var nutrition: String
}

struct Nutrition {
	var calories: Int
	var fat: Int
	var carbohydrates: Int
	var protein: Int
}
