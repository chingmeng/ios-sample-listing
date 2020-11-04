//
//  models.swift
//  ios-sample-listing
//
//  Created by Meng on 04/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import Foundation


struct Recipe {
	var title: String
	var type: String
	var ingredients: [Ingredient]
	var preparation: [String]
	var image: String
	var comment: String
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
