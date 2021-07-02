//
//  FavouriteCocktailsViewController.swift
//  Cocktails
//
//  Created by Victor on 03/06/2021.
//

import UIKit
import RealmSwift

class FavouriteCocktailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
      
    @IBOutlet weak var tableView: UITableView!
    
    var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    var cocktails = [CocktailFavourites]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Prepare UI
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        self.title = "Favourite Cocktails"
        
        tableView.register(MainCocktailTableViewCell.nib(), forCellReuseIdentifier: MainCocktailTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        cocktails = []
        let cocktailList = Array(realm!.objects(CocktailFavourites.self))
        for item in cocktailList {
            if item.isFavourite {
                cocktails.append(item)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainCocktailTableViewCell.identifier) as? MainCocktailTableViewCell {
            let index = indexPath.row % AppColors.count
            cell.backgroundColor = AppColors.getColor(index: index)
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 3
            
            let currentCocktail = cocktails[indexPath.row]
            cell.cocktailNameLabel?.text = currentCocktail.strDrink
            
            if let ingredient1 = currentCocktail.strIngredient1 {
                cell.ingredientsLabel.text! = ingredient1
                if let ingredient2 = currentCocktail.strIngredient2 {
                    cell.ingredientsLabel.text! += ", " + ingredient2
                    if let ingredient3 = currentCocktail.strIngredient3 {
                        cell.ingredientsLabel.text! += ", " + ingredient3
                        if let _ = currentCocktail.strIngredient4 {
                            cell.ingredientsLabel.text! += " and more!"
                        }
                    }
                }
            }
            
            if let image = currentCocktail.strDrinkThumb {
                cell.icon.downloaded(from: image)
            }
            cell.icon.layer.cornerRadius = 25
            
            if currentCocktail.isFavourite {
                cell.favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                cell.favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailDetailsVC") as? CocktailDetailsViewController {
            let cocktailName = cocktails[indexPath.row].strDrink.lowercased()
            let api = "https://thecocktaildb.com/api/json/v1/1/search.php?s=" + cocktailName
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.apiKey = api
            }
            vc.title = cocktailName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
