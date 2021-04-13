//
//  HotNewsCell.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 13.04.2021.
//

import UIKit

class HotNewsCell: UITableViewCell {
    
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with cellModel: CellModel) {
        
        sourceLabel.text = cellModel.source
        authorLabel.text = cellModel.author
        titleLabel.text = cellModel.title
        descriptionLabel.text = cellModel.description
        newsImageView.image = cellModel.image
    }
    
}
