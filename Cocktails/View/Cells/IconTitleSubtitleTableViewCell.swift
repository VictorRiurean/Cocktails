//
//  IconTitleSubtitleCell.swift
//  Cocktails
//
//  Created by Victor on 03/06/2021.
//

import UIKit

class IconTitleSubtitleTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    static let identifier = "iconTitleSubtitleCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "IconTitleSubtitleTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = AppColors.myGray
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
