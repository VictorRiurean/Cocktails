//
//  ImageTitleCollectionViewCell.swift
//  Cocktails
//
//  Created by Victor on 14/07/2021.
//

import UIKit

class ImageTitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "imageTitleCollectionCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "ImageTitleCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
