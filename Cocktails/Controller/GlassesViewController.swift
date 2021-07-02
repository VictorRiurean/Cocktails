//
//  GlassesViewController.swift
//  Cocktails
//
//  Created by Victor on 17/05/2021.
//

import UIKit
import Alamofire

class GlassesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var glasses = [Glass]()
    var filteredGlasses = [Glass]()
    
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
        self.title = "Glasses"
        
        tableView.register(GlassTableViewCell.nib(), forCellReuseIdentifier: GlassTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        getGlasses()
        
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.bounds = self.view.bounds
        spinner.backgroundColor = AppColors.myGray
        spinner.alpha = 0.7
        spinner.startAnimating()
    }
    
    //MARK: - Networking

    func getGlasses() {
        AF.request("https://thecocktaildb.com/api/json/v1/1/list.php?g=list").response { response in
            switch response.result {
            case .success(let value): do {
                if let dataValue = value {
                    let decoder = JSONDecoder()
                    if let drinksCollection = try? decoder.decode(Drinks.self, from: dataValue) {
                        self.glasses = drinksCollection.drinks
                        self.filteredGlasses = self.glasses
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
        return filteredGlasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GlassTableViewCell.identifier) as? GlassTableViewCell {
            cell.nameLabel.text = filteredGlasses[indexPath.row].strGlass
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailsInGlassVC") as? CocktailsInGlassViewController {
            vc.title = glasses[indexPath.section].strGlass
            let api = "https://thecocktaildb.com/api/json/v1/1/filter.php?g=" + filteredGlasses[indexPath.section].strGlass.lowercased()
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.apiKey = api
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredGlasses = []
        if searchText == "" {
            filteredGlasses = glasses
        } else {
            for glass in glasses {
                if glass.strGlass.lowercased().contains(searchText.lowercased()) {
                    filteredGlasses.append(glass)
                }
            }
        }
        self.tableView.reloadData()
    }
}
