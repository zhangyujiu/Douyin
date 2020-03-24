//
//  ViewController.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/17.
//  Copyright © 2020 张玉久. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var videos:[VideoEntity]=[]
    var pageIndex = 1
    var currentPage = 0
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidLoad() {
           super.viewDidLoad()
           self.extendedLayoutIncludesOpaqueBars=false
           self.loadData(page:pageIndex)
           
           NotificationCenter.default.addObserver(self,
           selector: #selector(self.appEnteredFromBackground),
           name: UIApplication.willEnterForegroundNotification, object: nil)
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        let videoEntity = videos[indexPath.row]
        cell.videoEntity = videoEntity
        //去除点击cell的阴影效果
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    //拖动结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()

        currentPage=tableView.indexPathsForVisibleRows!.last!.row
        if currentPage == (videos.count - 1)  {
            pageIndex+=1
            self.loadData(page:pageIndex)
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showComment"{
            let button=sender as! UIButton
            let pointInTable=button.convert(button.bounds.origin, to: tableView)
            let cellIndexPath = tableView.indexPathForRow(at: pointInTable)
            let commentController=segue.destination as! CommentController
            commentController.videoId=videos[cellIndexPath!.row]._id
            commentController.commentCount=videos[cellIndexPath!.row].comment_count
        }
    }


    private func loadData(page:Int){
        AF.request("\(Api.baseUrl)\(Api.videos)?page=\(page)").responseJSON(){ response in
            
            let jsonData=response.data
            let decoder = JSONDecoder()
            do{
                let datas = try decoder.decode([VideoEntity].self, from: jsonData!)
                self.videos += datas
                self.tableView.reloadData()
            }catch{
                print(error)
            }
        }
       
    }
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    @objc func appEnteredFromBackground(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
}

