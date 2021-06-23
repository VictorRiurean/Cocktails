//
//  TipsViewController.swift
//  Cocktails
//
//  Created by Victor on 03/06/2021.
//

import UIKit

class TipsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tips = [Tips(image: UIImage(named: "qualityDrinks")!, shortDescription: "Use premium liquors.", longDescription: """
                It cannot be overstated how important premium liquor is for a quality cocktail. We’re not saying you need to mix Macallan 25 year old scotch into that Dry Rob Roy, but don’t scrape the bottom of barrel, either.
                """),
                Tips(image: UIImage(named: "iceCold")!, shortDescription: "Chill your glasses ahead of time.", longDescription: """
                Either chill them in your fridge or fill it with ice and water. By chilling the glass you help ensure the cocktail remains refreshingly cool to the very last sip.
                """),
                Tips(image: UIImage(named: "jigger")!, shortDescription: "Use a high quality jigger.", longDescription: """
                This lets you accurately measure cocktails with ease. Many cocktails which include numerous ingredients can be ruined with an uneven balance of booze. For shame.
                """),
                Tips(image: UIImage(named: "lotsOfIce")!, shortDescription: "When shaking, use lots of ice.", longDescription: """
                More ice helps chill the cocktail further. Always add the ice last as it can dilute the drink if left there too long.
                """),
                Tips(image: UIImage(named: "shake")!, shortDescription: "Shake, shake, and shake some more!", longDescription: """
                Shake the cocktails vigorously until you notice condensation on the outside of the jigger. This lets the cold fully permeate the drink and delivers a cool, crisp finish to the cocktail.
                """),
                Tips(image: UIImage(named: "smallGlasses")!, shortDescription: "Use small glasses.", longDescription: """
                Yes, it will be more work in the long run, but – unless you’re Arthur – large glasses leave you with a warm cocktail.
                """),
                Tips(image: UIImage(named: "sample")!, shortDescription: "Sample before serving.", longDescription: """
                Fruit juices can vary in sweetness from fruit to fruit; try every drink (through a straw of course!) before serving it to unsuspecting patrons.
                """),
                Tips(image: UIImage(named: "freshIngredients")!, shortDescription: "Use fresh ingredients.", longDescription: """
                Fresh squeezed juice goes a long way with cocktails. If you can’t squeeze it yourself, purchase quality juices instead. Rose’s Lime Juice is your best bet if you can’t get fresh limes.
                """),
                Tips(image: UIImage(named: "barTools")!, shortDescription: "Get a solid set of bar tools.", longDescription: """
                Like a chef’s knives, you’ll want a quality jigger, shaker, stirrer, muddler, etc. There are several bar sets available , including this one and this travel bar kit.
                """),
                Tips(image: UIImage(named: "qualityGlasses")!, shortDescription: "Quality glassware ...", longDescription: """
                Every respectable home bar needs a proper cocktail shaker, mojito glasses, old fashioned glasses and the obligatory whiskey glasses.
                """),
                Tips(image: UIImage(named: "bubbles")!, shortDescription: "Keep the buzz!", longDescription: """
                When mixing cocktails with sparkling ingredients – sparkling wine, club soda or sparkling water – be sure to add them at the last second.
                """),
                Tips(image: UIImage(named: "stirr")!, shortDescription: "Shaken or stirred?", longDescription: """
                It’s an honest question, and mostly up to personal preference. The only exception, to this, however, is when the cocktail includes heavy ingredients like cream… in which case heavy shaking is required to fully mix the ingredients.
                """)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Prepare UI
    
    func setupUI() {
        let nib = UINib(nibName: "IngredientAndImageCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ingredientAndImageCellID")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        for i in 0...11 {
            print(tips[i].longDescription)
        }
        
        self.title = "Tips & Tricks"
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientAndImageCellID") as? IngredientAndImageCell {
            let index = indexPath.row % AppColors.count
            cell.backgroundColor = AppColors.getColor(index: index)
            cell.label.text = tips[indexPath.row].shortDescription
            cell.icon.image = tips[indexPath.row].image
            cell.icon.layer.cornerRadius = 10
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 3
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "tipDetailsVC") as? TipDetailsViewController {
            vc.longDescription = tips[indexPath.row].longDescription
            vc.icon = tips[indexPath.row].image ?? UIImage()
            vc.shortDescription = tips[indexPath.row].shortDescription
            present(vc, animated: true, completion: nil)
        }
    }
}

