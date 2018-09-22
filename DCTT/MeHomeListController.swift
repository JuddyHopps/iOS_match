//
//  HomerListViewControllerTest2.swift
//  DCTT
//
//  Created by wyg on 2018/8/9.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeListController: UITableViewController {
    var uid:String!
    
    private var canScroll:Bool = false;
    private var dataArray = [[String:Any]]()
    
    var viewM:MeHomeViewM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView();
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)

        //////
        //loadData();
        loadProfile()
        
        //view model
        viewM = MeHomeViewM.init(self)
        viewM._scrollViewDidScroll = { [weak self] scrollView in
            guard let ss = self else {return}
            
            if !ss.canScroll && kchildViewCanScroll == false {
                scrollView.contentOffset = CGPoint.zero
            }
            
            if scrollView.contentOffset.y <= 0 {
                if ss.canScroll || kchildViewCanScroll {
                    ss.canScroll = false
                    NotificationCenter.default.post(name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)
                    
                }
            }
        }
        
        tableView = viewM.tableview
    }
    
    func loadProfile() {
        guard let u = uid else {return}
        let d:[String:Any] = ["uid":u, "type":3]
        
        AlamofireHelper.post(url: update_profile_url, parameters: d, successHandler: { (res) in
            guard String.isNullOrEmpty(res["status"]) == "200" else { return;}
            guard let user = res["body"] as? [String:Any] else {return}
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init("updateProfileNotification"), object: nil, userInfo: user)
            }
        }) { (err) in
            print("加载用户资料失败")
            print(err?.localizedDescription)
        }
    }
    
    
    //MARK:- 控制滑动
    func noti(_ noti:NSNotification) {
        canScroll = true
        //print("child can")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll && kchildViewCanScroll == false {
            scrollView.contentOffset = CGPoint.zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            if canScroll || kchildViewCanScroll {
                canScroll = false
                NotificationCenter.default.post(name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
