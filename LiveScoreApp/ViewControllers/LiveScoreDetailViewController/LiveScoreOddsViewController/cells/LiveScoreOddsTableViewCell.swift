//
//  LiveScoreOddsTableViewCell.swift
//  LiveScoreApp
//
//  Created by Ahmad Rafiq on 21/07/2024.
//

import UIKit

class LiveScoreOddsTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var suspendedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: LiveOddModel?) {
        typeLabel.text = model?.oddType
        valueLabel.text = model?.oddValue
        suspendedLabel.text = model?.isOddSuspended
    }
}
