//
//  EnergyCompareContentVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

protocol EnergyCompareContentVCDelegate:NSObjectProtocol
{
    func refreshData()
}

class EnergyCompareContentVC: UIViewController {
    
    var tableView : UITableView!
    var headView : EnergyCompareHeadView!
    
    var delegate:EnergyCompareContentVCDelegate?
    
    
    func setData(model:EnergyCompareStandardVoModel) {
        
        self.tableView.es.stopPullToRefresh()
        self.headView.updateData(model: model)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView = UITableView(frame:CGRect(x:0 , y : CGFloat(NavHeight + 20.0 + 30 + 10) , width:ScreenW , height: 412))
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = RGBCOLOR(r: 242, 242, 242)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0 , 0, 0))
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.setHeadView()
        
        self.tableView.es.addPullToRefresh {
            
            [weak self] in
            
            if((self?.delegate) != nil)
            {
                self?.delegate?.refreshData()
            }

        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func setHeadView() {
        
        let headerView = UIView()
        headerView.frame = CGRect(x:0 , y : 0, width:ScreenW , height: 522)
        
        let view = (Bundle.main.loadNibNamed("EnergyCompareHeadView", owner: nil, options: nil)![0] as! EnergyCompareHeadView)
        self.headView = view
        headerView.addSubview(view)
        view.frame = headerView.bounds
        self.tableView.tableHeaderView = headerView
        
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
