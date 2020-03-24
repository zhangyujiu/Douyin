//
//  CommentController.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/23.
//  Copyright © 2020 张玉久. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class CommentController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var comments:[CommentEntity]=[]
    var pageIndex = 1
    var videoId = ""{
        didSet{
            getComments()
        }
    }
    var commentCount = 0
    
    @IBOutlet weak var commentView: UIView!
    
    @IBAction func tapClose(_ sender: UITapGestureRecognizer) {
        let tapPoint=sender.location(in: commentView)
        if !commentView.layer.contains(tapPoint){
            self.dismiss(animated: true)
        }
    }
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         commentCountLabel.text="\(commentCount)条评论"
        let header=MJRefreshNormalHeader(){
            self.pageIndex=1
            self.getComments()
        }
        header.mormalStyle()

        tableView.mj_header = header
        tableView.mj_footer = MJRefreshBackNormalFooter() {
            self.pageIndex+=1
            self.getComments()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.commentEntity=comments[indexPath.row]
        return cell
       }

    func getComments(){
        AF.request(String(format:"\(Api.baseUrl)\(Api.comments)",videoId)).responseJSON(){ response in
            self.tableView?.mj_header?.endRefreshing()
            self.tableView?.mj_footer?.endRefreshing()
             let jsonData=response.data
             let decoder = JSONDecoder()
            do{
                let datas = try decoder.decode([CommentEntity].self, from: jsonData!)
                if(self.pageIndex==1){
                    self.comments.removeAll()
                }
                if(datas.count < 20){
                    self.tableView?.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.comments+=datas
                self.tableView.reloadData()
                print(String(format:"\(Api.baseUrl)\(Api.comments)",self.videoId))
                print(datas)
            }catch{
                print(error)
            }
            
        }
    }

}
