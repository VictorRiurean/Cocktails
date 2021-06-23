//
//  CocktailsPerCategoryViewController.swift
//  Cocktails
//
//  Created by Victor on 04/06/2021.
//

import UIKit
import Alamofire

class CocktailTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   

    @IBOutlet weak var categorySegments: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var segment = 0
    var api = ""
    
    var drinks = [Cocktail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        let nib = UINib(nibName: "GlassCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "collectionCellID")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        categorySegments.selectedSegmentIndex = segment
        
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.bounds = self.view.bounds
        spinner.backgroundColor = AppColors.myGray
        spinner.alpha = 0.7
        spinner.startAnimating()
        
        getDrinks()
    }
    
    //MARK: - Segment Control
  
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        spinner.startAnimating()
        if sender.selectedSegmentIndex == 0 {
            api = "https://thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"
            self.title = "Alcoholic"
            getDrinks()
        } else {
            api = "https://thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic"
            self.title = "Non-Alcoholic"
            getDrinks()
        }
    }
    
    //MARK: - Networking
    
    func getDrinks() {
        AF.request(api).response { response in
            switch response.result {
            case .success(let value): do {
                if let dataValue = value {
                    let decoder = JSONDecoder()
                    if let cocktailList = try? decoder.decode(Drink.self, from: dataValue) {
                        self.drinks = cocktailList.drinks
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
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
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellID", for: indexPath) as? GlassCollectionViewCell {
            cell.nameLabel.text = drinks[indexPath.row].strDrink
            if let image = drinks[indexPath.row].strDrinkThumb {
                cell.imageView.downloaded(from: image)
            }
            let index = indexPath.row % AppColors.count
            cell.backgroundColor = AppColors.getColor(index: index)
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = (screenSize.width - 60) / 2
        return CGSize(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "cocktailDetailsVC") as? CocktailDetailsViewController {
            let api = "https://thecocktaildb.com/api/json/v1/1/search.php?s=" + drinks[indexPath.row].strDrink.lowercased()
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.apiKey = api
            }
            vc.title = drinks[indexPath.row].strDrink
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
