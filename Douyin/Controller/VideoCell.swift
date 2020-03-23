//
//  VideoCell.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/19.
//  Copyright © 2020 张玉久. All rights reserved.
//

import UIKit
import MarqueeLabel
import Kingfisher
import KingfisherWebP
import ChainableAnimations
import Lottie

class VideoCell: UITableViewCell {

    @IBOutlet weak var coverImageview: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var nikeName: UILabel!
    @IBOutlet weak var title: MarqueeLabel!
    
   
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var userHeadImage: UIImageView!
    @IBOutlet weak var likeView: UIStackView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentView: UIStackView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var shareView: UIStackView!
    @IBOutlet weak var shareCount: UILabel!
    @IBOutlet weak var gameIcon: UIImageView!
    @IBOutlet weak var gameView: UIView!
    
    var animator1: ChainableAnimator!
    var animator2: ChainableAnimator!
    
    
    var videoEntity:VideoEntity!{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func clickLike(_ sender: ScaleAnimateButton) {
        like()
    }
    @IBAction func clickFollow(_ sender: UIButton) {
        self.animator1=ChainableAnimator(view: sender)
        
        UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve, animations:{
            sender.setImage(UIImage(named: "icon_sign_down"), for: .normal)
        }) { (_) in
            self.animator1.rotate(angle: 360)
                .thenAfter(t: 0.6)//执行0.6s
                .wait(t: 0.3)//等待0.3s
                .transform(scale: 0)
                .animate(t: 0.2)
        }
    }
    override func prepareForReuse() {
        //重置关注按钮的所有状态
        if !(animator1==nil) {
            animator1.stop()
            self.followBtn.transform = .identity
            self.followBtn.layer.removeAllAnimations()
            self.followBtn.setImage(UIImage(named: "ic_video_detail_follow"), for: .normal)
        }
        if !(animator2==nil) {
            animator2.stop()
            self.gameIcon.transform = .identity
            self.gameIcon.layer.removeAllAnimations()
        }
        gameView.resetViewAnimation()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(){
        coverImageview.kf.setImage(with: URL(string: videoEntity.poster))
        gameName.text=videoEntity.game_name
        nikeName.text="@\(videoEntity.user.name)"
        title.text=videoEntity.title
        title.restartLabel()
        userHeadImage.kf.setImage(with: URL(string: videoEntity.user.icon))
    
        
        likeCount.text=videoEntity.vote.description
        commentCount.text=videoEntity.comment_count.description
        shareCount.text=videoEntity.comment_count.description
        gameIcon.kf.setImage(with: URL(string: videoEntity.game_icon))
        
        animator2=ChainableAnimator(view: gameIcon)
        animator2.rotate(angle: 180).animateWithRepeat(t: 3.5, count: 100)
        
        //音符散发动画
        gameView.raiseAnimation(imageName:"ic_music",delay:0)
        gameView.raiseAnimation(imageName:"ic_music",delay:1)
        gameView.raiseAnimation(imageName:"ic_music",delay:2)
    }
    
    func like() {
        let cgRect=likeBtn.convert(CGRect(), to: self)
        let sizeWidth:CGFloat=100.0
        let animationView = AnimationView(name: "like")
        let x=cgRect.minX+likeBtn.bounds.width/2-sizeWidth/2
        let y=cgRect.minY+likeBtn.bounds.width/2-sizeWidth/2
        animationView.frame = CGRect(x: x , y: y, width: sizeWidth, height: sizeWidth)
        self.addSubview(animationView)
        likeBtn.alpha=0
        animationView.play { (isFinished) in
            self.likeBtn.alpha=1
            animationView.removeFromSuperview()
        }
    }

}
