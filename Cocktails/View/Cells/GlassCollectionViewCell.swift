//
//  GlassCollectionViewCell.swift
//  Cocktails
//
//  Created by Victor on 17/05/2021.
//

import UIKit

class GlassCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "glassCollectionViewCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "GlassCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.layer.cornerRadius = 33
    }

}
