//
//  CommentCell.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/23.
//  Copyright © 2020 张玉久. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var userHead: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    @IBOutlet weak var replayBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userHead.imageView?.contentMode  = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
