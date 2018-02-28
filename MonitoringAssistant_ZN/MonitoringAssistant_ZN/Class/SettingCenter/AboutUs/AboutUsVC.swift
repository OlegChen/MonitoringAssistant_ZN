//
//  AboutUsVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class AboutUsVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于我们"
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
        }
        
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let headerView = UIView()
        headerView.frame = CGRect(x:0 , y : 0 , width:ScreenW , height: 15)
        headerView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        self.tableView.tableHeaderView = headerView
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
    self.tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = RGBCOLOR(r: 58, 58, 58)
        cell?.addSubview(title)
        title.snp.makeConstraints { (make) in
            
            make.left.equalTo((cell?.contentView)!).offset(20)
            make.centerY.equalTo((cell?.contentView.center)!)
        }
        
        title.text = indexPath.row == 0 ? "功能介绍" : (indexPath.row == 1 ? "法律条款" : "检查新版本")
        
        let arrow = UIImageView()
        arrow.contentMode = .scaleAspectFit
        arrow.image = UIImage.init(named: "arror_right")
        cell?.addSubview(arrow)
        arrow.snp.makeConstraints { (make) in
            
            make.right.equalTo((cell?.contentView)!).offset(-15)
            make.centerY.equalTo((cell?.contentView)!)
            make.size.equalTo(CGSize(width:18 , height: 18))
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            
            self.navigationController?.pushViewController(functionVC(), animated: true)
            
        }else  if (indexPath.row == 1) {
            
        }else  if (indexPath.row == 2) {
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
