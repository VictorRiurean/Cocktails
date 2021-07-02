//
//  IngredientAndImageCell.swift
//  Cocktails
//
//  Created by Victor on 31/05/2021.
//

import UIKit

class IngredientAndImageTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "ingredientAndImageCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "IngredientAndImageTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
