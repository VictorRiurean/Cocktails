//
//  CocktailsViewController.swift
//  Cocktails
//
//  Created by Victor on 01/06/2021.
//

import UIKit
import Alamofire
import RealmSwift

class CocktailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var customView = UIView()
    
    let allLetters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
//    let allLetters = ["a","b","c","f","g", "u", "y", "z"]
    var loadedLetters = ["a"]
    
    var cocktailDictionary = [String: [CocktailDetails]]()
    var filteredDictionary = [String: [CocktailDetails]]()
    
    var api = ""
    var apiBase = "https://thecocktaildb.com/api/json/v1/1/search.php?f="
    
    var hasConnection = true
    
    var isLoading: [Bool] = { () -> [Bool] in
        var booleans = [Bool]()
        for i in 0...25 {
            booleans.append(true)
        }
        return booleans
    }()
    
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

        cocktailDictionary[allLetters[0]] = [CocktailDetails]()
        filteredDictionary[allLetters[0]] = [CocktailDetails]()
        
        setupUI()
    }
    
//    //MARK: - Check internet
//
//    func checkConnection() {
//        if ReachabilityTest.isConnectedToNetwork() {
//            if !hasConnection {
//                hasConnection = !hasConnection
//                customView.isHidden = true
//            }
//            setupUI()
//        } else {
////            for index in 0...25 {
////                isLoading[index] = true
////            }
//            hasConnection = false
//            let size = self.view.bounds
//            customView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            customView.backgroundColor = AppColors.myGray
//            let label = UILabel(frame: CGRect(x: 20, y: size.height / 2, width: size.width - 40, height: 100))
//            label.text = "Please connect to the internet, the entire app relies on having an internet connection"
//            label.numberOfLines = 0
//            label.textAlignment = .center
//            label.sizeToFit()
//            customView.addSubview(label)
//            self.view.addSubview(customView)
//        }
//    }
    
    //MARK: - Prepare UI
    
//    override func viewWillAppear(_ animated: Bool) {
//        checkConnection()
//        tableView.reloadData()
//    }
    
    func setupUI() {
        let nib = UINib(nibName: "MainCocktailTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "mainCocktailCellID")
        
        let loadingNib = UINib(nibName: "LoadingTableViewCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCellID")
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    //MARK: - Networking
    
    func getCocktails(with index: Int) {
        if index < allLetters.count {
            self.isLoading[index] = false
            let letter = allLetters[index]
            
            api = apiBase + letter
            AF.request(api).response { response in
                switch response.result {
                case .success(let value): do {
                    if let dataValue = value {
                        let decoder = JSONDecoder()
                        if let list = try? decoder.decode(CocktailDetailed?.self, from: dataValue) {
                            self.cocktailDictionary[letter] = list.drinks
                            self.filteredDictionary[letter] = list.drinks
                            if index < self.allLetters.count - 1 {
                                self.cocktailDictionary[self.allLetters[index + 1]] = [CocktailDetails]()
                                self.filteredDictionary[self.allLetters[index + 1]] = [CocktailDetails]()
                                self.loadedLetters.append(self.allLetters[index + 1])
                            }
                            self.search()
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } else {
                            if index < self.allLetters.count - 1 {
                                self.cocktailDictionary[self.allLetters[index + 1]] = [CocktailDetails]()
                                self.filteredDictionary[self.allLetters[index + 1]] = [CocktailDetails]()
                                self.loadedLetters.append(self.allLetters[index + 1])
                            }
                            self.search()
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                case .failure(let error): do {
                    print(error)
                }
                }
            }
        }
    }
    
    //MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return loadedLetters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return loadedLetters[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = loadedLetters[section]
        if isLoading[section] {
            if let cocktails = filteredDictionary[letter] {
                return cocktails.count > 0 ? cocktails.count : 1
            }
        } else {
            return filteredDictionary[letter]?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isKind(of: LoadingTableViewCell.self) {
            getCocktails(with: indexPath.section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cocktails = filteredDictionary[allLetters[indexPath.section]] else {
            return UITableViewCell()
        }
        
        if cocktails.count == 0 && isLoading[indexPath.section] {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellID") as? LoadingTableViewCell {
                cell.textLabel?.text = "Loading cocktails ..."
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mainCocktailCellID") as? MainCocktailTableViewCell {
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
            
            let cocktails = realm!.objects(CocktailFavourites.self)
            for cocktail in cocktails {
                if cocktail.strDrink == currentCocktail.strDrink {
                    if cocktail.isFavourite {
                        cell.favouritesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    } else {
                        cell.favouritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailDetailsVC") as? CocktailDetailsViewController {
            if let cocktailName = filteredDictionary[allLetters[indexPath.section]]?[indexPath.row].strDrink.lowercased() {
                let api = "https://thecocktaildb.com/api/json/v1/1/search.php?s=" + cocktailName
                if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    vc.apiKey = api
                }
                vc.title = filteredDictionary[allLetters[indexPath.section]]?[indexPath.row].strDrink
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Search
    
    func search() {
        if searchBar.text == "" {
            filteredDictionary = cocktailDictionary
        } else {
            for (key, value) in cocktailDictionary {
                filteredDictionary[key] = []
                for val in value {
                    if let text = searchBar.text {
                        if val.strDrink.lowercased().contains(text.lowercased()) {
                            filteredDictionary[key]?.append(val)
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredDictionary = cocktailDictionary
        } else {
            for (key, value) in cocktailDictionary {
                filteredDictionary[key] = []
                for val in value {
                    if val.strDrink.lowercased().contains(searchText.lowercased()) {
                        filteredDictionary[key]?.append(val)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
}
