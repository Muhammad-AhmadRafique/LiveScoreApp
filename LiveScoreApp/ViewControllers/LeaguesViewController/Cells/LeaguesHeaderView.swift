//
//  LeaguesHeaderView.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 17/07/2024.
//

import UIKit

class LeaguesHeaderView: UIView {

    static func view() -> LeaguesHeaderView {
        let v = Bundle.main.loadNibNamed(LeaguesHeaderView.className, owner: nil, options: nil)?.first as! LeaguesHeaderView
        return v
    }
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var countryImageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leaguesCountLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    var leagueHeaderButtonTapped:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(section: Int) {
        countryImageLabel.text = "AR".countryFlag()
        headingLabel.isHidden = section != 1
    }
    
    @IBAction func headerButtonWasPressed(_ sender: Any) {
        leagueHeaderButtonTapped?()
    }

}
