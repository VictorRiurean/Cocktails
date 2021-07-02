//
//  VerticalCollectionTableViewCell.swift
//  Cocktails
//
//  Created by Victor on 01/07/2021.
//

import UIKit

protocol GoToCocktailDetailsProtocol {
    func goToCocktail(with index: Int)
    func goToRandomCocktail()
}

class VerticalCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: GoToCocktailDetailsProtocol?
    
    var randomCocktails = [CocktailDetails]()
    var randomCocktail: CocktailDetails?
    
    static let identifier = "verticalCollectionCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "VerticalCollectionTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TitleCollectionViewCell.nib(), forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.register(GlassCollectionViewCell.nib(), forCellWithReuseIdentifier: GlassCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomCocktails.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlassCollectionViewCell.identifier, for: indexPath) as? GlassCollectionViewCell {
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
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlassCollectionViewCell.identifier, for: indexPath) as? GlassCollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGRect = collectionView.bounds
        let width = (size.width - 20) / 2
        let height = (size.height - 20) / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.goToRandomCocktail()
        } else {
            delegate?.goToCocktail(with: indexPath.row)
        }
    }
}
