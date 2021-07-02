//
//  MainCocktailTableViewCell.swift
//  Cocktails
//
//  Created by Victor on 16/06/2021.
//

import UIKit
import RealmSwift

class MainCocktailTableViewCell: UITableViewCell {

    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var favouritesButton: UIButton!
    
    static let identifier = "mainCocktailCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "MainCocktailTableViewCell", bundle: nil)
    }
    
    var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchAddToFavouritesButton(_ sender: Any) {
        let cocktails = realm!.objects(CocktailFavourites.self)
        for cocktail in cocktails {
            if cocktail.strDrink == cocktailNameLabel.text {
                try! realm!.write {
                    cocktail.isFavourite = !cocktail.isFavourite
                }
                if cocktail.isFavourite {
                    favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
    }
}
