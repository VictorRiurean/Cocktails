//
//  Model.swift
//  Cocktails
//
//  Created by Victor on 17/05/2021.
//

import Foundation
import Alamofire
import RealmSwift

class Glass: NSObject, Codable {
    @objc dynamic var strGlass: String
}

class Drinks: NSObject, Codable {
    @objc dynamic var drinks: [Glass]
}

class Ingredient: NSObject, Codable {
    @objc dynamic var strIngredient1: String
}

class Ingredients: NSObject, Codable {
    @objc var drinks: [Ingredient]
}

class Drink: NSObject, Codable {
    @objc dynamic var drinks: [Cocktail]
}

class Category: NSObject, Codable {
    @objc var strCategory: String
}

class Categories: NSObject, Codable {
    @objc dynamic var drinks: [Category]
}

class Cocktail: NSObject, Codable {
    @objc dynamic var strDrink: String
    @objc dynamic var strDrinkThumb: String?
}

class CocktailDetailed: NSObject, Codable {
    @objc dynamic var drinks: [CocktailDetails]
}

class CocktailDetails: Object, Codable {
    @objc dynamic var strDrink: String
    @objc dynamic var strCategory: String
    @objc dynamic var strAlcoholic: String
    @objc dynamic var strGlass: String
    @objc dynamic var strInstructions: String?
    @objc dynamic var strDrinkThumb: String?
    @objc dynamic var strImageSource: String?
    @objc dynamic var strIngredient1: String?
    @objc dynamic var strIngredient2: String?
    @objc dynamic var strIngredient3: String?
    @objc dynamic var strIngredient4: String?
    @objc dynamic var strIngredient5: String?
    @objc dynamic var strIngredient6: String?
    @objc dynamic var strIngredient7: String?
    @objc dynamic var strIngredient8: String?
    @objc dynamic var strIngredient9: String?
    @objc dynamic var strIngredient10: String?
    @objc dynamic var strIngredient11: String?
    @objc dynamic var strIngredient12: String?
    @objc dynamic var strIngredient13: String?
    @objc dynamic var strIngredient14: String?
    @objc dynamic var strIngredient15: String?
    @objc dynamic var strMeasure1: String?
    @objc dynamic var strMeasure2: String?
    @objc dynamic var strMeasure3: String?
    @objc dynamic var strMeasure4: String?
    @objc dynamic var strMeasure5: String?
    @objc dynamic var strMeasure6: String?
    @objc dynamic var strMeasure7: String?
    @objc dynamic var strMeasure8: String?
    @objc dynamic var strMeasure9: String?
    @objc dynamic var strMeasure10: String?
    @objc dynamic var strMeasure11: String?
    @objc dynamic var strMeasure12: String?
    @objc dynamic var strMeasure13: String?
    @objc dynamic var strMeasure14: String?
    @objc dynamic var strMeasure15: String?
}

class CocktailFavourites: Object, Codable {
    @objc dynamic var strDrink: String = ""
    @objc dynamic var strCategory: String = ""
    @objc dynamic var strAlcoholic: String = ""
    @objc dynamic var strGlass: String = ""
    @objc dynamic var strInstructions: String?
    @objc dynamic var strDrinkThumb: String?
    @objc dynamic var strImageSource: String?
    @objc dynamic var strIngredient1: String?
    @objc dynamic var strIngredient2: String?
    @objc dynamic var strIngredient3: String?
    @objc dynamic var strIngredient4: String?
    @objc dynamic var strIngredient5: String?
    @objc dynamic var strIngredient6: String?
    @objc dynamic var strIngredient7: String?
    @objc dynamic var strIngredient8: String?
    @objc dynamic var strIngredient9: String?
    @objc dynamic var strIngredient10: String?
    @objc dynamic var strIngredient11: String?
    @objc dynamic var strIngredient12: String?
    @objc dynamic var strIngredient13: String?
    @objc dynamic var strIngredient14: String?
    @objc dynamic var strIngredient15: String?
    @objc dynamic var strMeasure1: String?
    @objc dynamic var strMeasure2: String?
    @objc dynamic var strMeasure3: String?
    @objc dynamic var strMeasure4: String?
    @objc dynamic var strMeasure5: String?
    @objc dynamic var strMeasure6: String?
    @objc dynamic var strMeasure7: String?
    @objc dynamic var strMeasure8: String?
    @objc dynamic var strMeasure9: String?
    @objc dynamic var strMeasure10: String?
    @objc dynamic var strMeasure11: String?
    @objc dynamic var strMeasure12: String?
    @objc dynamic var strMeasure13: String?
    @objc dynamic var strMeasure14: String?
    @objc dynamic var strMeasure15: String?
    @objc dynamic var isFavourite = false
    
    required override init() {
//        fatalError("init() has not been implemented")
    }
    
     init(cocktail: CocktailDetails) {
        self.strDrink = cocktail.strDrink
        self.strCategory = cocktail.strCategory
        self.strAlcoholic = cocktail.strAlcoholic
        self.strGlass = cocktail.strGlass
        self.strInstructions = cocktail.strInstructions
        self.strDrinkThumb = cocktail.strDrinkThumb
        self.strImageSource = cocktail.strImageSource
        self.strIngredient1 = cocktail.strIngredient1
        self.strIngredient2 = cocktail.strIngredient2
        self.strIngredient3 = cocktail.strIngredient3
        self.strIngredient4 = cocktail.strIngredient4
        self.strIngredient5 = cocktail.strIngredient5
        self.strIngredient6 = cocktail.strIngredient6
        self.strIngredient7 = cocktail.strIngredient7
        self.strIngredient8 = cocktail.strIngredient8
        self.strIngredient9 = cocktail.strIngredient9
        self.strIngredient10 = cocktail.strIngredient10
        self.strIngredient11 = cocktail.strIngredient11
        self.strIngredient12 = cocktail.strIngredient12
        self.strIngredient13 = cocktail.strIngredient13
        self.strIngredient14 = cocktail.strIngredient14
        self.strIngredient15 = cocktail.strIngredient15
        self.strMeasure1 = cocktail.strMeasure1
        self.strMeasure2 = cocktail.strMeasure2
        self.strMeasure3 = cocktail.strMeasure3
        self.strMeasure4 = cocktail.strMeasure4
        self.strMeasure5 = cocktail.strMeasure5
        self.strMeasure6 = cocktail.strMeasure6
        self.strMeasure7 = cocktail.strMeasure7
        self.strMeasure8 = cocktail.strMeasure8
        self.strMeasure9 = cocktail.strMeasure9
        self.strMeasure10 = cocktail.strMeasure10
        self.strMeasure11 = cocktail.strMeasure11
        self.strMeasure12 = cocktail.strMeasure12
        self.strMeasure13 = cocktail.strMeasure13
        self.strMeasure14 = cocktail.strMeasure14
        self.strMeasure15 = cocktail.strMeasure15
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {  [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
