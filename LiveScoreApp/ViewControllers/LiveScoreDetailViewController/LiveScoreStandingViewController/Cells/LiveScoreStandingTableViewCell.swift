//
//  LiveScoreStandingTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreStandingTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var pValueLabel: UILabel!
    @IBOutlet weak var wValueLabel: UILabel!
    @IBOutlet weak var dValueLabel: UILabel!
    @IBOutlet weak var lValueLabel: UILabel!
    @IBOutlet weak var gdValueLabel: UILabel!
    @IBOutlet weak var pointsValueLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: LiveScoreStandingModel) {
        placeLabel.text = "\(model.standingPlace ?? 0)"
        nameLabel.text = model.standingTeam
        
        pValueLabel.text = "\(model.standingP ?? 0)"
        wValueLabel.text = "\(model.standingW ?? 0)"
        dValueLabel.text = "\(model.standingD ?? 0)"
        lValueLabel.text = "\(model.standingL ?? 0)"
        gdValueLabel.text = "\(model.standingGD ?? 0)"
        pointsValueLabel.text = "\(model.standingPTS ?? 0)"
        
    }
    
}
