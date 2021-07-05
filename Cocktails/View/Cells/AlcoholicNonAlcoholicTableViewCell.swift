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
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width - 40, height: 100))
        
        let alcoholicLabel = UILabel(frame: CGRect(x: view.bounds.width * 0.15, y: 37.5, width: 50, height: 20))
        alcoholicLabel.text = "Alcoholic"
        alcoholicLabel.textColor = .white
        alcoholicLabel.font = UIFont.boldSystemFont(ofSize: 25)
        alcoholicLabel.sizeToFit()
        let nonAlcoholicLabel = UILabel(frame: CGRect(x: view.bounds.width * 0.62, y: 37.5, width: 50, height: 20))
        nonAlcoholicLabel.text = "Non Alcoholic"
        nonAlcoholicLabel.textColor = .white
        nonAlcoholicLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nonAlcoholicLabel.sizeToFit()
        
        let alcoholicButton = UIButton(frame: CGRect(x: 5, y: 5, width: (bounds.width - 10) / 2, height: 90))
        alcoholicButton.setImage(UIImage(named: "alcoholic"), for: .normal)
        alcoholicButton.setTitle("Alcoholic", for: .normal)
        alcoholicButton.clipsToBounds = true
        alcoholicButton.addTarget(self, action: #selector(didTouchAlcoholicButton), for: .touchUpInside)
        
        let nonAlcoholicButton = UIButton(frame: CGRect(x: bounds.width / 2 + 5 , y: 5, width: (bounds.width - 20) / 2, height: 90))
        nonAlcoholicButton.setImage(UIImage(named: "nonAlcoholic"), for: .normal)
        nonAlcoholicButton.clipsToBounds = true
        nonAlcoholicButton.addTarget(self, action: #selector(didTouchAlcoholicButton), for: .touchUpInside)
        
        view.addSubview(alcoholicButton)
        view.addSubview(nonAlcoholicButton)
        view.addSubview(alcoholicLabel)
        view.addSubview(nonAlcoholicLabel)
        view.bringSubviewToFront(alcoholicLabel)
        view.bringSubviewToFront(nonAlcoholicLabel)
        self.addSubview(view)
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
