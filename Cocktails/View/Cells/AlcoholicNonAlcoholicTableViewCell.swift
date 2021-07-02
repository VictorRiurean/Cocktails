//
//  AlcoholicNonAlcoholicTableViewCell.swift
//  Cocktails
//
//  Created by Victor on 01/07/2021.
//

import UIKit

protocol DidTouchAlcoholicNonAlcoholicProtocol {
    func didTouchAlcoholicButton()
    func didTouchNonAlcoholicButton()
}

class AlcoholicNonAlcoholicTableViewCell: UITableViewCell {

    @IBOutlet weak var alcoholicButton: UIButton!
    @IBOutlet weak var nonAlcoholicButton: UIButton!
    
    var delegate: DidTouchAlcoholicNonAlcoholicProtocol?
    
    static let identifier = "alcoholicNonAlcoholicCellID"
    
    static func nib() -> UINib {
        return UINib(nibName: "AlcoholicNonAlcoholicTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bounds = UIScreen.main.bounds
        
        let alcoholicLabel = UILabel()
        alcoholicLabel.text = "Alcoholic"
        alcoholicLabel.textColor = .white
        let nonAlcoholicLabel = UILabel()
        nonAlcoholicLabel.text = "Non Alcoholic"
        nonAlcoholicLabel.textColor = .white
        
        let alcoholicButton = UIButton(frame: CGRect(x: 5, y: 5, width: (bounds.width - 10) / 2, height: 90))
        alcoholicButton.setImage(UIImage(named: "alcoholic"), for: .normal)
        alcoholicButton.setTitle("Alcoholic", for: .normal)
        alcoholicButton.clipsToBounds = true
        alcoholicButton.addTarget(self, action: #selector(didTouchAlcoholicButton), for: .touchUpInside)
        alcoholicButton.addSubview(alcoholicLabel)
        alcoholicButton.bringSubviewToFront(alcoholicLabel)
        
        let nonAlcoholicButton = UIButton(frame: CGRect(x: bounds.width / 2 + 5 , y: 5, width: (bounds.width - 20) / 2, height: 90))
        nonAlcoholicButton.setImage(UIImage(named: "nonAlcoholic"), for: .normal)
        nonAlcoholicButton.clipsToBounds = true
        nonAlcoholicButton.addTarget(self, action: #selector(didTouchAlcoholicButton), for: .touchUpInside)
        nonAlcoholicButton.addSubview(nonAlcoholicLabel)
        nonAlcoholicButton.bringSubviewToFront(nonAlcoholicLabel)
        
        self.addSubview(alcoholicButton)
        self.addSubview(nonAlcoholicButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didTouchAlcoholicButton() {
        delegate?.didTouchAlcoholicButton()
    }
    
    @objc func didTouchNonAlcoholicButton(_ sender: Any) {
        delegate?.didTouchNonAlcoholicButton()
    }
}
