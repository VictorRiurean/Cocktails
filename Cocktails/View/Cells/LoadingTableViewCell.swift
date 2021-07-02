//
//  LoadingTableViewCell.swift
//  Cocktails
//
//  Created by Victor on 13/06/2021.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    static let identifier = "loadingCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "LoadingTableViewCell", bundle: nil)
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
