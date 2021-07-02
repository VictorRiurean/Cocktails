//
//  DiscoverViewController.swift
//  Cocktails
//
//  Created by Victor on 17/05/2021.
//

import UIKit
import Alamofire
import SDWebImage
import RealmSwift

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DidTouchButtonProtocol, DidTouchAlcoholicNonAlcoholicProtocol, GoToCategoriesProtocol, GoToCocktailDetailsProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var customView = UIView()
    
    var categories = [Category]()
    var randomCocktails = [CocktailDetails]()
    var randomCocktail: CocktailDetails?
    
    let allLetters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    var api = ""
    var apiBase = "https://thecocktaildb.com/api/json/v1/1/search.php?f="
    
    let defaults = UserDefaults.standard
    let gotAllCocktailsKey = "sawTutorialBool"
    
    var hasConnection = true
    
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
        
    }
    
    //MARK: - Check internet
    
    func checkConnection() {
        if ReachabilityTest.isConnectedToNetwork() {
            if !hasConnection {
                hasConnection = !hasConnection
                customView.isHidden = true
            }
            setupUI()
        } else {
            hasConnection = false
            let size = self.view.bounds
            customView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            customView.backgroundColor = AppColors.myGray
            let label = UILabel(frame: CGRect(x: 20, y: size.height / 2, width: size.width - 40, height: 100))
            label.text = "Please connect to the internet, the entire app relies on having an internet connection"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.sizeToFit()
            customView.addSubview(label)
            self.view.addSubview(customView)
        }
    }
    
    //MARK: - Prepare UI
    
    override func viewWillAppear(_ animated: Bool) {
        checkConnection()
    }
    
    func setupUI() {
        self.title = "Discover"
        
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.bounds = self.view.bounds
        spinner.backgroundColor = AppColors.myGray
        spinner.alpha = 0.7
        spinner.startAnimating()
        
        let gotAllCocktails = defaults.bool(forKey: gotAllCocktailsKey)
        if !gotAllCocktails {
            getAllCocktails()
            UserDefaults.standard.setValue(true, forKey: gotAllCocktailsKey)
        }
        
        tableView.register(HorizontalCollectionTableViewCell.nib(), forCellReuseIdentifier: HorizontalCollectionTableViewCell.identifier)
        tableView.register(VerticalCollectionTableViewCell.nib(), forCellReuseIdentifier: VerticalCollectionTableViewCell.identifier)
        tableView.register(ShowMoreButtonTableViewCell.nib(), forCellReuseIdentifier: ShowMoreButtonTableViewCell.identifier)
        tableView.register(AlcoholicNonAlcoholicTableViewCell.nib(), forCellReuseIdentifier: AlcoholicNonAlcoholicTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        if !self.categories.isEmpty && !self.randomCocktails.isEmpty {
            spinner.stopAnimating()
        } else {
            getCategories()
            getRandomCocktails()
        }
    }
    
    //MARK: - Networking
    
    func getCategories() {
        AF.request("https://thecocktaildb.com/api/json/v1/1/list.php?c=list").response { response in
            switch response.result {
            case .success(let value): do {
                if let dataValue = value {
                    let decoder = JSONDecoder()
                    if let categoryList = try? decoder.decode(Categories.self, from: dataValue) {
                        self.categories = categoryList.drinks
                    }
                    DispatchQueue.main.async {
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
    
    func getRandomCocktails() {
        for index in 0...2 {
            AF.request("https://thecocktaildb.com/api/json/v1/1/random.php").response { response in
                switch response.result {
                case .success(let value): do {
                    if let dataValue = value {
                        let decoder = JSONDecoder()
                        if let randomCocktail = try? decoder.decode(CocktailDetailed.self, from: dataValue) {
                            self.randomCocktails.append(randomCocktail.drinks[0])
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            if index == 2 {
                                self.spinner.stopAnimating()
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
    
    func getAllCocktails() {
        for letter in allLetters {
            api = apiBase + letter
            AF.request(api).response { response in
                switch response.result {
                case .success(let value): do {
                    if let dataValue = value {
                        let decoder = JSONDecoder()
                        if let list = try? decoder.decode(CocktailDetailed.self, from: dataValue) {
                            for drink in list.drinks {
                                let favDrink = CocktailFavourites(cocktail: drink)
                                try! self.realm?.write {
                                    self.realm?.add(favDrink)
                                }
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let screenSize = UIScreen.main.bounds
                return screenSize.height * 0.4
            } else {
                return 80
            }
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Cocktail Categories"
        } else if section == 1 {
            return "Iconic Cocktails"
        } else {
            return "Cocktail Types"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.font.withSize(50)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalCollectionTableViewCell.identifier) as? HorizontalCollectionTableViewCell {
                cell.categories = self.categories
                cell.collectionView.reloadData()
                cell.delegate = self
                return cell
            }
            return UITableViewCell()
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: VerticalCollectionTableViewCell.identifier) as? VerticalCollectionTableViewCell {
                    cell.randomCocktail = self.randomCocktail
                    cell.randomCocktails = self.randomCocktails
                    cell.collectionView.reloadData()
                    cell.delegate = self
                    return cell
                }
                return UITableViewCell()
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreButtonTableViewCell.identifier) as? ShowMoreButtonTableViewCell {
                    cell.delegate = self
                    return cell
                }
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AlcoholicNonAlcoholicTableViewCell.identifier) as? AlcoholicNonAlcoholicTableViewCell {
                cell.delegate = self
                return cell
            }
            return UITableViewCell()
        }
    }
    
    //MARK: - Protocol Methods
    
    func goToCategoriesController(with index: Int) {
        if let vc = storyboard?.instantiateViewController(identifier: "categoryDetailsVC") as? CategoryDetailsViewController {
            let api = "https://thecocktaildb.com/api/json/v1/1/filter.php?c=" + categories[index].strCategory.lowercased()
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.api = api
                vc.category = categories[index].strCategory
            }
            vc.title = categories[index].strCategory
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToCocktail(with index: Int) {
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailDetailsVC") as? CocktailDetailsViewController {
            let api = "https://thecocktaildb.com/api/json/v1/1/search.php?s=" + randomCocktails[index - 1].strDrink.lowercased()
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.apiKey = api
            }
            vc.title = randomCocktails[index - 1].strDrink
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToRandomCocktail() {
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailDetailsVC") as? CocktailDetailsViewController {
            let api = "https://thecocktaildb.com/api/json/v1/1/random.php"
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.apiKey = api
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTouchAlcoholicButton() {
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailTypeVC") as? CocktailTypeViewController {
            vc.segment = 0
            vc.api = "https://thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"
            vc.title = "Alcoholic"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTouchNonAlcoholicButton() {
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailTypeVC") as? CocktailTypeViewController {
            vc.segment = 1
            vc.api = "https://thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"
            vc.title = "Non-Alcoholic"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTouchShowMoreButton() {
        self.tabBarController?.selectedIndex = 1
    }
}
