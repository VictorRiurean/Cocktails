//
//  CocktailDetailsCell.swift
//  Cocktails
//
//  Created by Victor on 19/05/2021.
//

import UIKit

class CocktailDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var glassLabel: UILabel!
    
    static let identifier = "cocktailDetailsCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "CocktailDetailsTableViewCell", bundle: nil)
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
