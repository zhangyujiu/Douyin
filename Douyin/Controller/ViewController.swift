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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars=false
        self.loadData(page:pageIndex)
    }
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    //拖动结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        pageIndex+=1
//        self.loadData(page:pageIndex)
        currentPage=tableView.indexPathsForVisibleRows!.last!.row
    }


    private func loadData(page:Int){
       AF.request("\(Api.baseUrl)?page=\(page)").responseJSON(){ response in
            
            let jsonData=response.data
            let decoder = JSONDecoder()
            let datas = try! decoder.decode([VideoEntity].self, from: jsonData!)
            self.videos += datas
            self.tableView.reloadData()
        }
       
       
        
    }
}

