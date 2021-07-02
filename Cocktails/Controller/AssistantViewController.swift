//
//  AssistantViewController.swift
//  Cocktails
//
//  Created by Victor on 03/06/2021.
//

import UIKit

class AssistantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var hasConnection = true
    var customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Check internet
    
    func checkConnection() {
        if ReachabilityTest.isConnectedToNetwork() {
            if !hasConnection {
                hasConnection = !hasConnection
                customView.isHidden = true
            }
            setupUI()
        } else {
            hasConnection = false
            let size = self.view.bounds
            customView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            customView.backgroundColor = AppColors.myGray
            let label = UILabel(frame: CGRect(x: 20, y: size.height / 2, width: size.width - 40, height: 100))
            label.text = "Please connect to the internet, the entire app relies on having an internet connection"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.sizeToFit()
            customView.addSubview(label)
            self.view.addSubview(customView)
        }
    }
    
    //MARK: - Prepare UI
    
    override func viewWillAppear(_ animated: Bool) {
        checkConnection()
    }
    
    func setupUI() {
        self.title = "Assistant"
    
        tableView.register(IconTitleSubtitleTableViewCell.nib(), forCellReuseIdentifier: IconTitleSubtitleTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IconTitleSubtitleTableViewCell.identifier) as? IconTitleSubtitleTableViewCell {
                cell.titleLabel.text = "Favourite Cocktails"
                cell.subtitleLabel.text = "Mark Cocktails as Favourites so you can have quick access to them"
                cell.icon.image = UIImage(named: "favourite")
                cell.icon.layer.cornerRadius = 4
                return cell
            }
        } else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IconTitleSubtitleTableViewCell.identifier) as? IconTitleSubtitleTableViewCell {
                cell.titleLabel.text = "My Cocktails"
                cell.subtitleLabel.text = "Didn't find your Cocktail in the app? No problem, add it yourself and we will save it for you!"
                cell.icon.image = UIImage(named: "add")
                cell.icon.layer.cornerRadius = 4
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IconTitleSubtitleTableViewCell.identifier) as? IconTitleSubtitleTableViewCell {
                cell.titleLabel.text = "Tips"
                cell.subtitleLabel.text = "Take a deep dive into some of the more advanced topics of mixology!"
                cell.icon.image = UIImage(named: "tips")
                cell.icon.layer.cornerRadius = 4
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            if let vc = storyboard?.instantiateViewController(identifier: "favouriteCocktailsVC") as? FavouriteCocktailsViewController {
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexPath.row == 1 {
            let alert = UIAlertController(title: "Available soon", message: "Stay tuned! We are working to bring this feature to life.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let vc = storyboard?.instantiateViewController(identifier: "tipsVC") as? TipsViewController {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
