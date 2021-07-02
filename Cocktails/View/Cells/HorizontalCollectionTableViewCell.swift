//
//  HorizontalCollectionTableViewCell.swift
//  Cocktails
//
//  Created by Victor on 01/07/2021.
//

import UIKit

protocol GoToCategoriesProtocol {
    func goToCategoriesController(with index: Int)
}

class HorizontalCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: GoToCategoriesProtocol?
    
    var categories = [Category]()
    
    static let identifier = "horizontalCollectionCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "HorizontalCollectionTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TitleCollectionViewCell.nib(), forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell {
            cell.nameLabel.text = categories[indexPath.row].strCategory
            cell.nameLabel.sizeToFit()
            let index = indexPath.row % AppColors.count
            cell.backgroundColor = AppColors.getColor(index: index)
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGRect = collectionView.bounds
        let width = (size.width - 30) / 2.2
        let height = size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToCategoriesController(with: indexPath.row)
    }
}
