//
//  IngredientsViewController.swift
//  Cocktails
//
//  Created by Victor on 31/05/2021.
//

import UIKit
import Alamofire

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var ingredients = [Ingredient]()
    var filteredIngredients = [Ingredient]()
    
    var customView = UIView()
    
    var hasConnection = true
    
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
        self.title = "Ingredients"
        
        let nib = UINib(nibName: "IngredientAndImageCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ingredientAndImageCellID")
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.bounds = self.view.bounds
        spinner.backgroundColor = AppColors.myGray
        spinner.alpha = 0.7
        spinner.startAnimating()
        
        getIngredients()
    }
    
    //MARK: - Networking
    
    func getIngredients() {
        AF.request("https://thecocktaildb.com/api/json/v1/1/list.php?i=list").response { response in
            switch response.result {
            case .success(let value): do {
                if let dataValue = value {
                    let decoder = JSONDecoder()
                    if let ingredientsList = try? decoder.decode(Ingredients.self, from: dataValue) {
                        self.ingredients = ingredientsList.drinks
                        self.filteredIngredients = self.ingredients
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientAndImageCellID") as? IngredientAndImageCell {
            let index = indexPath.row % AppColors.count
            cell.backgroundColor = AppColors.getColor(index: index)
            cell.label.text = filteredIngredients[indexPath.row].strIngredient1
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 3
            
            let url = "https://thecocktaildb.com/images/ingredients/" + filteredIngredients[indexPath.row].strIngredient1 + "-Small.png"
            if let urlp = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                cell.icon.downloaded(from: urlp)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "ingredientsDetailsVC") as? IngredientsDetailsViewController {
            let api = "https://thecocktaildb.com/api/json/v1/1/filter.php?i=" + filteredIngredients[indexPath.row].strIngredient1.lowercased()
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.api = api
            }
            let url = "https://thecocktaildb.com/images/ingredients/" + filteredIngredients[indexPath.row].strIngredient1 + "-Small.png"
            if let urlp = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.imgURL = urlp
            }
            vc.title = filteredIngredients[indexPath.row].strIngredient1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredIngredients = []
        if searchText == "" {
            filteredIngredients = ingredients
        } else {
            for ingredient in ingredients {
                if ingredient.strIngredient1.lowercased().contains(searchText.lowercased()) {
                    filteredIngredients.append(ingredient)
                }
            }
        }
        self.tableView.reloadData()
    }
}

