//
//  TipDetailsViewController.swift
//  Cocktails
//
//  Created by Victor on 11/06/2021.
//

import UIKit

class TipDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var tapOutsideRecognizer: UITapGestureRecognizer!

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var longDescription = ""
    var shortDescription = ""
    var icon = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Prepare UI

    func setupUI() {
        image.image = icon
        
        descriptionLabel.text = longDescription
        descriptionLabel.sizeToFit()
        
        titleLabel.text = shortDescription
        titleLabel.sizeToFit()
        
        let index = Int.random(in: 0...8)
        view.backgroundColor = AppColors.colors[index]
    }
    
    //MARK: - Closing modal on outside tap
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.tapOutsideRecognizer == nil {
            self.tapOutsideRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBehind))
            self.tapOutsideRecognizer.numberOfTapsRequired = 1
            self.tapOutsideRecognizer.cancelsTouchesInView = false
            self.tapOutsideRecognizer.delegate = self
            self.view.window?.addGestureRecognizer(self.tapOutsideRecognizer)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.tapOutsideRecognizer != nil {
            self.view.window?.removeGestureRecognizer(self.tapOutsideRecognizer)
            self.tapOutsideRecognizer = nil
        }
    }

    func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleTapBehind(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let location: CGPoint = sender.location(in: self.view)

            if !self.view.point(inside: location, with: nil) {
                self.view.window?.removeGestureRecognizer(sender)
                self.close(sender: sender)
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Button(s)
    
    @IBAction func didTouchCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

