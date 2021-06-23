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

class DiscoverViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var cocktailCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var iconicCocktailsCollectionView: UICollectionView!
    @IBOutlet weak var alcoholicButton: UIButton!
    @IBOutlet weak var nonAlcoholicButton: UIButton!
    @IBOutlet weak var showMoreButton: UIButton!
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
        
        let nib = UINib(nibName: "TitleCollectionViewCell", bundle: nil)
        let nib1 = UINib(nibName: "GlassCollectionViewCell", bundle: nil)
        cocktailCategoriesCollectionView.register(nib, forCellWithReuseIdentifier: "titleCollectionViewCellID")
        iconicCocktailsCollectionView.register(nib1, forCellWithReuseIdentifier: "collectionCellID")
        
        cocktailCategoriesCollectionView.delegate = self
        cocktailCategoriesCollectionView.dataSource = self
        iconicCocktailsCollectionView.delegate = self
        iconicCocktailsCollectionView.dataSource = self
        
        if let flowLayout = cocktailCategoriesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        showMoreButton.backgroundColor = .red
        showMoreButton.layer.cornerRadius = 5
        
        alcoholicButton.clipsToBounds = true
        alcoholicButton.setBackgroundImage(UIImage(named: "alcoholic"), for: .normal)
        nonAlcoholicButton.clipsToBounds = true
        nonAlcoholicButton.setBackgroundImage(UIImage(named: "nonAlcoholic"), for: .normal)
    
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
                        self.cocktailCategoriesCollectionView.reloadData()
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
                            self.cocktailCategoriesCollectionView.reloadData()
                            self.iconicCocktailsCollectionView.reloadData()
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
    
    //MARK: - Buttons
    
    @IBAction func didTouchAlcoholicButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailTypeVC") as? CocktailTypeViewController {
            vc.segment = 0
            vc.api = "https://thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"
            vc.title = "Alcoholic"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func didTouchNonAlcoholicButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailTypeVC") as? CocktailTypeViewController {
            vc.segment = 1
            vc.api = "https://thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"
            vc.title = "Non-Alcoholic"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func didTouchShowMoreButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cocktailCategoriesCollectionView {
            return categories.count
        } else {
            return randomCocktails.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cocktailCategoriesCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCollectionViewCellID", for: indexPath) as? TitleCollectionViewCell {
                cell.nameLabel.text = categories[indexPath.row].strCategory
                cell.nameLabel.sizeToFit()
                let index = indexPath.row % AppColors.count
                cell.backgroundColor = AppColors.getColor(index: index)
                cell.layer.cornerRadius = 5
                cell.layer.masksToBounds = true
                return cell
            }
            return UICollectionViewCell()
        } else {
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellID", for: indexPath) as? GlassCollectionViewCell {
                    cell.nameLabel.text = "Surprize me!"
                    cell.nameLabel.sizeToFit()
                    cell.imageView.image = UIImage(named: "tomato")
                    let index = indexPath.row % AppColors.count
                    cell.backgroundColor = AppColors.getColor(index: index)
                    cell.layer.cornerRadius = 10
                    cell.layer.masksToBounds = true
                    return cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellID", for: indexPath) as? GlassCollectionViewCell {
                    cell.nameLabel.text = randomCocktails[indexPath.row - 1].strDrink
                    cell.nameLabel.sizeToFit()
                    if let url = randomCocktails[indexPath.row - 1].strDrinkThumb {
                        cell.imageView.sd_setImage(with: URL(string: url), completed: nil)
                    }
                    let index = indexPath.row % AppColors.count
                    cell.backgroundColor = AppColors.getColor(index: index)
                    cell.layer.cornerRadius = 10
                    cell.layer.masksToBounds = true
                    return cell
                }
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == iconicCocktailsCollectionView {
            let screenSize: CGRect = iconicCocktailsCollectionView.bounds
            let width = (screenSize.width - 20) / 2
            let height = (screenSize.height - 20) / 2
            return CGSize(width: width, height: height)
        } else {
            let screenSize: CGRect = cocktailCategoriesCollectionView.bounds
            let width = (screenSize.width - 30) / 2.2
            let height = screenSize.height
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cocktailCategoriesCollectionView {
            if let vc = storyboard?.instantiateViewController(identifier: "categoryDetailsVC") as? CategoryDetailsViewController {
                let api = "https://thecocktaildb.com/api/json/v1/1/filter.php?c=" + categories[indexPath.row].strCategory.lowercased()
                if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    vc.api = api
                    vc.category = categories[indexPath.row].strCategory
                }
                vc.title = categories[indexPath.row].strCategory
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if indexPath.row == 0 {
                if let vc = storyboard?.instantiateViewController(identifier: "cocktailDetailsVC") as? CocktailDetailsViewController {
                    let api = "https://thecocktaildb.com/api/json/v1/1/random.php"
                    if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        vc.apiKey = api
                    }
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if let vc = storyboard?.instantiateViewController(identifier: "cocktailDetailsVC") as? CocktailDetailsViewController {
                    let api = "https://thecocktaildb.com/api/json/v1/1/search.php?s=" + randomCocktails[indexPath.row - 1].strDrink.lowercased()
                    if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        vc.apiKey = api
                    }
                    vc.title = randomCocktails[indexPath.row - 1].strDrink
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
