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
import BMPlayer
import AVFoundation

class VideoCell: UITableViewCell,ASAutoPlayVideoLayerContainer {

    
    @IBOutlet weak var playImageView: UIImageView!
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var nikeName: UILabel!
    @IBOutlet weak var title: MarqueeLabel!
   
    @IBOutlet weak var coverImage: UIImageView!
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
    @IBOutlet weak var videoContainer: UIView!
    
    var animator1: ChainableAnimator!
    var animator2: ChainableAnimator!
    var tapGesture : UITapGestureRecognizer!
    
    var videoEntity:VideoEntity!{
        didSet{
            updateUI()
        }
    }
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
        
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
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
         coverImage.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
               
         videoLayer.backgroundColor = UIColor.clear.cgColor
         videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
         videoContainer.layer.addSublayer(videoLayer)
         coverImage.isHidden = true

         //添加全屏暂停 点击
         tapGesture = UITapGestureRecognizer(target: self, action: #selector(pausePlayer))
         self.contentView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(){
        coverImage.kf.setImage(with: URL(string: videoEntity.poster))
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
        videoURL=videoEntity.url
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
    
    func visibleVideoHeight() -> CGFloat {
            let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(coverImage.frame, from: coverImage)
                  guard let videoFrame = videoFrameInParentSuperView,
                      let superViewFrame = superview?.frame else {
                       return 0
                  }
           let visibleVideoFrame = videoFrame.intersection(superViewFrame)
           return visibleVideoFrame.size.height
       }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           
           let width = UIScreen.main.bounds.size.width
           let height = UIScreen.main.bounds.size.height
           videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
       }
    
    /// 暂停/播放功能切换
    @objc func pausePlayer()   {
        showPauseViewAnim(rate: videoLayer.player!.rate)
        ASVideoPlayerController.sharedVideoPlayer.pausePlayer()
    }
    
    /// 视频暂停/播放切换按钮的动画
    ///
    /// - Parameter rate: 视频播放速率
    func showPauseViewAnim(rate:Float) {
        if rate == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.playImageView.alpha = 0
            }) { _ in
                self.playImageView.isHidden = true
            }
        } else {
            playImageView.isHidden = false
            playImageView.transform = CGAffineTransform.init(scaleX: 1.8, y: 1.8)
            playImageView.alpha = 1.0
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.playImageView.transform = .init(scaleX: 1.0, y: 1.0)
            })
        }
    }
}
