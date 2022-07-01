//
//  MostPopularArticleTableViewCell.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import UIKit
import SDWebImage

class MostPopularArticleTableViewCell: UITableViewCell {
    static let cell = "MostPopularArticleTableViewCell"
    
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var byLineLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!

    var cellModel : MostViewedCellViewModel? {
        didSet{
            self.titleLabel.text = cellModel?.title
            self.byLineLabel.text = cellModel?.byLine
            self.publishedDateLabel.text = cellModel?.PublishedDate
            if let url = URL(string: cellModel?.avatar ?? ""){
                self.articleImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.on.rectangle"))
            }else{
                self.articleImageView.backgroundColor = .gray
                self.articleImageView.image = UIImage(systemName: "photo.on.rectangle")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
