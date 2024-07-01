//
//  PicsumPhotosTableViewCell.swift
//  PicsumPhotos
//
//  Created by Umesh  on 30/06/24.
//

import UIKit

class PicsumPhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var picsumImage: UIImageView!
    @IBOutlet weak var descriptions: UILabel!
//    @IBOutlet weak var downloadUrl: UILabel!
    @IBOutlet weak var checkUncheckBox: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
