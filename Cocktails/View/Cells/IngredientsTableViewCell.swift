//
//  IngredientsCell.swift
//  Cocktails
//
//  Created by Victor on 19/05/2021.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "ingredientsCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "IngredientsTableViewCell", bundle: nil)
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
