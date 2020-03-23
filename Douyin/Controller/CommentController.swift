//
//  CommentController.swift
//  Douyin
//
//  Created by 张玉久 on 2020/3/23.
//  Copyright © 2020 张玉久. All rights reserved.
//

import UIKit

class CommentController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 10
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
