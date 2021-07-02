//
//  CocktailDetailsViewController.swift
//  Cocktails
//
//  Created by Victor on 17/05/2021.
//

import UIKit
import Alamofire
import RealmSwift

class CocktailDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var share: UIBarButtonItem?
    var addToFavourites: UIBarButtonItem?
    
    var apiKey = ""
    
    var cocktails = [CocktailDetails]()
    
    var ingredients = [String]()
    var measures = [String]()
    
    var isFavourite = true
    
    var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Prepare UI
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupUI() {
        tableView.register(CocktailDetailsTableViewCell.nib(), forCellReuseIdentifier: CocktailDetailsTableViewCell.identifier)
        tableView.register(IngredientsTableViewCell.nib(), forCellReuseIdentifier: IngredientsTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.bounds = self.view.bounds
        spinner.backgroundColor = AppColors.myGray
        spinner.alpha = 0.7
        spinner.startAnimating()
        
        getDrinks()
        
        share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        addToFavourites = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(addToFavouritesTapped))
        
        let cocktails = realm!.objects(CocktailFavourites.self)
        for cocktail in cocktails {
            if cocktail.strDrink.lowercased() == self.title?.lowercased() {
                if cocktail.isFavourite {
                    addToFavourites?.image = UIImage(systemName: "heart.fill")
                } else {
                    addToFavourites?.image = UIImage(systemName: "heart")
                    isFavourite = false
                }
            }
        }
        
        navigationItem.rightBarButtonItems = [share!, addToFavourites!]
    }
    
    //MARK: - BarButton Item Methods
    
    @objc func shareTapped() {
        let firstActivityItem = "Share drink on ..."
        var image = UIImage()
        
        if let thumb = cocktails[0].strDrinkThumb, let url = URL(string: thumb), let data = try? Data(contentsOf: url) {
            image = UIImage(data: data) ?? UIImage()
        }
    
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        activityViewController.isModalInPresentation = true
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func addToFavouritesTapped() {
        let cocktails = realm!.objects(CocktailFavourites.self)
        for cocktail in cocktails {
            if cocktail.strDrink == self.title {
                try! realm!.write {
                    cocktail.isFavourite = !cocktail.isFavourite
                    self.isFavourite = !self.isFavourite
                }
            }
        }
        if isFavourite {
            addToFavourites?.image = UIImage(systemName: "heart.fill")
        } else {
            addToFavourites?.image = UIImage(systemName: "heart")
        }
    }
    
    //MARK: - Data formatting
    
    func ingredientsAndMeasures() {
        if let ingredient = cocktails[0].strIngredient1 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure1 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient2 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure2 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient3 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure3 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient4 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure4 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient5 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure5 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient6 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure6 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient7 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure7 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient8 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure8 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient9 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure9 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient10 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure10 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient11 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure1 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient1 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure11 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient12 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure12 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient13 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure13 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient14 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure14 ?? "")
        }
        if let ingredient = cocktails[0].strIngredient15 {
            ingredients.append(ingredient)
            measures.append(cocktails[0].strMeasure15 ?? "")
        }
    }
    
    //MARK: - Networking
    
    func getDrinks() {
        spinner.startAnimating()
        AF.request(apiKey).response { response in
            switch response.result {
            case .success(let value): do {
                if let dataValue = value {
                    let decoder = JSONDecoder()
                    if let drinksCollection = try? decoder.decode(CocktailDetailed.self, from: dataValue) {
                        self.cocktails = drinksCollection.drinks
                        self.ingredientsAndMeasures()
                        self.title = self.cocktails[0].strDrink
                    }
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }
            case .failure(let error): do {
                print(error)
            }
            }
        }
    }
    
    //MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return ingredients.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Ingredients"
        } else if section == 2 {
            return "Preparation"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .center
        header.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CocktailDetailsTableViewCell.identifier) as? CocktailDetailsTableViewCell {
                if !cocktails.isEmpty {
                    if let image = cocktails[0].strDrinkThumb {
                        cell.cocktailImageView.downloaded(from: image)
                    }
                    cell.categoryLabel.text = cocktails[0].strCategory + " | " + cocktails[0].strAlcoholic
                    cell.glassLabel.text = "Served in: " + cocktails[0].strGlass
                    return cell
                }
            }
            return UITableViewCell()
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.identifier) as? IngredientsTableViewCell {
                if !ingredients.isEmpty {
                    cell.nameLabel.text = measures[indexPath.row] + ingredients[indexPath.row]
                    let index = indexPath.row % AppColors.count
                    cell.backgroundColor = AppColors.getColor(index: index)
                    cell.layer.cornerRadius = 12
                    cell.layer.masksToBounds = true
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.layer.borderWidth = 3
                    return cell
                }
            }
        } else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IngredientsTableViewCell.identifier) as? IngredientsTableViewCell {
                if !cocktails.isEmpty {
                    cell.nameLabel.text = cocktails[0].strInstructions
                    cell.nameLabel.sizeToFit()
                    let index = Int.random(in: 0...10) % AppColors.count
                    cell.backgroundColor = AppColors.getColor(index: index)
                    cell.layer.cornerRadius = 8
                    cell.layer.masksToBounds = true
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
