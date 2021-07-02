//
//  ShowMoreButtonTableViewCell.swift
//  Cocktails
//
//  Created by Victor on 01/07/2021.
//

import UIKit

protocol DidTouchButtonProtocol: AnyObject {
    func didTouchShowMoreButton()
}

class ShowMoreButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var showMoreButton: UIButton!
    
    var delegate: DidTouchButtonProtocol?
    
    static let identifier = "showMoreButtonCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "ShowMoreButtonTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        showMoreButton.backgroundColor = .red
        showMoreButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchShowMoreButton(_ sender: Any) {
        delegate?.didTouchShowMoreButton()
    }
}
