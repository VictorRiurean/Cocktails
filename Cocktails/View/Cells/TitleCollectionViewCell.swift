//
//  TitleCollectionViewCell.swift
//  Cocktails
//
//  Created by Victor on 08/06/2021.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "titleCollectionViewCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "TitleCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
