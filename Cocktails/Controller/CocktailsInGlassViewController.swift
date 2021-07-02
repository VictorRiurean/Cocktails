//
//  CocktailsInGlassViewController.swift
//  Cocktails
//
//  Created by Victor on 17/05/2021.
//

import UIKit
import Alamofire

class CocktailsInGlassViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var apiKey = ""
    var glasses = [Cocktail]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        collectionView.register(GlassCollectionViewCell.nib(), forCellWithReuseIdentifier: GlassCollectionViewCell.identifier)
        
        getGlasses()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.bounds = self.view.bounds
        spinner.backgroundColor = AppColors.myGray
        spinner.alpha = 0.7
        spinner.startAnimating()
    }
    
    //MARK: - Networking
    
    func getGlasses() {
        AF.request(apiKey).response { response in
            switch response.result {
            case .success(let value): do {
                if let dataValue = value {
                    let decoder = JSONDecoder()
                    if let drinksCollection = try? decoder.decode(Drink.self, from: dataValue) {
                        self.glasses = drinksCollection.drinks
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
        return glasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlassCollectionViewCell.identifier, for: indexPath) as? GlassCollectionViewCell {
            let index = indexPath.row % AppColors.count
            cell.backgroundColor = AppColors.getColor(index: index)
            cell.nameLabel.text = glasses[indexPath.row].strDrink
            if let image = glasses[indexPath.row].strDrinkThumb {
                cell.imageView.downloaded(from: image)
            }
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 3
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
            let api = "https://thecocktaildb.com/api/json/v1/1/search.php?s=" + glasses[indexPath.row].strDrink.lowercased()
            if let api = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                vc.apiKey = api
            }
            vc.title = glasses[indexPath.row].strDrink
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
