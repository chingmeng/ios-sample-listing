//
//  RecipeDetail.swift
//  ios-sample-listing
//
//  Created by Meng on 04/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class RecipeDetail : UIViewController {
	
	var recipe: Recipe? = nil
	
	@IBOutlet var image: UIImageView!
	@IBOutlet var labelTitle: UILabel!
	@IBOutlet var labelDetail: UILabel!
	@IBOutlet var labelListing: UILabel!
	
	@IBOutlet var scrollView: UIScrollView!
	
	static func newInstance(recipe: Recipe) -> RecipeDetail {
		let recipeDetail = RecipeDetail()
		recipeDetail.recipe = recipe
		return recipeDetail
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Recipe Detail"
		
		self.scrollView.showsVerticalScrollIndicator = false
		
		self.image.image = .actions
		if let recipe = self.recipe  {
			
			self.image.kf.indicatorType = .activity
			self.image.kf.setImage(
				with: URL(string: recipe.image),
				placeholder: UIImage.actions,
				options: [
					.scaleFactor(UIScreen.main.scale),
					.transition(.fade(1)),
					.cacheOriginalImage
			])
			
			self.image?.contentMode = .scaleAspectFill
			self.image?.clipsToBounds = true
		}
		
		self.labelTitle.text = recipe?.title
		
		let ingredientsMappedArray = self.recipe?.ingredients.map{ e in e.name } ?? []
		
		self.labelDetail.text = " - " + ingredientsMappedArray.joined(separator: "\n - ")
		self.labelDetail.sizeToFit()
		
		self.labelListing.text = self.recipe?.preparation.map { e in e.trimmingCharacters(in: .whitespaces)}.joined(separator: "\n\n")
		self.labelListing.sizeToFit()
		
	}
	
}
