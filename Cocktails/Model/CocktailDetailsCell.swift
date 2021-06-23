//
//  CocktailDetailsCell.swift
//  Cocktails
//
//  Created by Victor on 19/05/2021.
//

import UIKit

class CocktailDetailsCell: UITableViewCell {

    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var glassLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
