//
//  OrderDetailVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/25.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class OrderDetailVC: BaseVC ,UITableViewDelegate,UITableViewDataSource {

    var workNo : String?
    
    var headView : OrderDetailHeaderView?
    var dataModel : WorkOrderDetailModel?
    
    var dispatchBtn : UIButton!
    
    var tableView : UITableView!
    
    var headerHeight = 215.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单详情"
        self.view.backgroundColor = RGBCOLOR(r: 242, 242, 242)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "派单记录", target: self, action: #selector(toDispatchOrderListVC))

        self.tableView = UITableView()
        self.tableView.backgroundColor = RGBCOLOR(r: 242, 242, 242)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.view).offset(NavHeight)
            make.bottom.equalTo(self.view).offset(-80)
        }
        self.tableView.register(UINib.init(nibName: "OrderDetailCell" , bundle: nil), forCellReuseIdentifier: OrderDetailCell_id)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.frame = CGRect(x:0 , y : 0 , width:Int(ScreenW) , height: Int(self.headerHeight))
       
        let view = (Bundle.main.loadNibNamed("OrderDetailHeaderView", owner: nil, options: nil)![0] as! OrderDetailHeaderView)
        self.headView = view
        headerView.addSubview(view)
        view.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView = headerView
    
        self.setupBottomBtn()
        self.getdata()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航栏颜色
        navBarBarTintColor = UIColor.init(red: 71/255.0, green: 143/255.0, blue: 183/255.0, alpha: 1.0)
        
        // 设置初始导航栏透明度
        navBarBackgroundAlpha = 1.0
        
        // 设置导航栏按钮和标题颜色
        navBarTintColor = .white
        navBarTitleColor = .white
        statusBarStyle = UIStatusBarStyle.lightContent
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCell_id) as? OrderDetailCell
        cell?.levelL.text = self.dataModel?.returnObj?.urgencyName
        if let a = self.dataModel?.returnObj?.repairsDesc {
            
            cell?.contentL.text = "　　" + a
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return dataModel == nil ? 86 :  CGFloat((self.dataModel?.returnObj?.cellHeight)!)
    }
    
    func setupBottomBtn() {
        
        let btn = UIButton()
        self.dispatchBtn = btn
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.tableView.snp.bottom).offset(40)
            make.left.equalTo(self.view).offset(45)
            make.right.equalTo(self.view).offset(-45)
            make.height.equalTo(50)
        }
        btn.layer.cornerRadius = 4
        btn.backgroundColor = RGBCOLOR(r: 71, 143, 183)
        btn.setTitle("派  单", for: UIControlState.normal)
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(sureBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func sureBtnClick(btn: UIButton) {
        
        if(self.dataModel == nil){return}
        
        let vc = SelectWorkerVCViewController()
        vc.lat = self.dataModel?.returnObj?.latitude
        vc.lon = self.dataModel?.returnObj?.longitude
        vc.workNo = self.dataModel?.returnObj?.workNo
        vc.workSendId = self.dataModel?.returnObj?.workSendId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func toDispatchOrderListVC() {
        
        if(self.dataModel?.returnObj?.workNo == nil){return}
        
        let vc = DispatchRecordVC()
        vc.workNo = self.dataModel?.returnObj?.workNo as! NSString
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getdata() {
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "workNo":self.workNo
            ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workOrderDetailUrl, modelClass: "WorkOrderDetailModel", response: { (obj) in
                
                let model = obj as! WorkOrderDetailModel
                
                if(model.statusCode == 800){
                    
                    self.headView?.titleL.text = (model.returnObj?.workName)! + " | " + (model.returnObj?.typeName)!
                    self.headView?.longTimeL.text = (model.returnObj?.repairsTime)! + "分钟"
                    self.headView?.orderNoL.text = model.returnObj?.workNo
                    self.headView?.dateL.text = model.returnObj?.createDateStr
                    self.headView?.nameL.text = model.returnObj?.sendEmpName
                    self.headView?.connectPersonL.text = model.returnObj?.contactMan
                    self.headView?.telL.text = model.returnObj?.tel
                    self.headView?.addressL.text = model.returnObj?.address
                    
                    let addressH = self.textSize(text: (model.returnObj?.address)!, font: UIFont.systemFont(ofSize: 13), maxSize: CGSize(width: ScreenW - 105  ,height: 1000))
                    
                    self.headerHeight = Double(200 + addressH.height)
                    
                    self.tableView.tableHeaderView?.height = CGFloat(self.headerHeight)
                    
                    self.dataModel = model
                    
                    self.setupImagefooter(array: model.returnObj?.workDealImgs as! NSArray)
                    
                    self.tableView.reloadData()
                    
                    self.dispatchBtn.setTitle(model.returnObj?.workSendId == "0" ? "派　　单" : "改　　派", for: UIControlState.normal)
                    
                    
                }else{
                    
                    YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                }
                
               
                
            }) { (error) in
                
            }
            
        }
        
    }
    
    
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size
    }
    
    func setupImagefooter(array:NSArray) {
        
//        if array.count == 0 || array == nil {
//            return
//        }
//
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let A = NSMutableArray()
        A.addObjects(from: array as! [Any])

        
        let imgW = (ScreenW - 15 * 4) / 3
        
        for i in 0..<(A.count) {
            
            let model = A[i] as! WorkOrderDetailImgsModel
            
            let img = UIImageView.init()
            img.contentMode = UIViewContentMode.scaleAspectFill
            img.clipsToBounds = true
            
            img.tag = i
            img.isUserInteractionEnabled = true
            let singleTap =  UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
            img.addGestureRecognizer(singleTap)
            
            let urlStr = model.imgUrl
            
            img.sd_setImage(with: URL.init(string: urlStr != nil ? urlStr! : ""), placeholderImage: UIImage(named:"placeHolderImg"), options: SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(UInt8(SDWebImageOptions.retryFailed.rawValue) | UInt8(SDWebImageOptions.lowPriority.rawValue))) , completed:nil)

            
            view.addSubview(img)
            let l = i % 3
            let row = i / 3
            img.snp.makeConstraints({ (make) in
                
                make.left.equalTo(view).offset(15 + CGFloat(l) * (imgW + 15))
                make.top.equalTo(view).offset(15 + CGFloat(row) * (imgW + 15))
                make.size.equalTo(CGSize(width: imgW, height: imgW))
            })
            
        }
        
        let height = A.count > 0 ?  (15 + CGFloat((A.count - 1) / 3 + 1) * (imgW + 15)) : 0
        
        view.frame = CGRect(x: 0 , y : 0 , width: ScreenW , height: height )
        
        self.tableView.tableFooterView = view
        
        
        //底部按钮 位置设置
        let cellheight = Double((self.dataModel?.returnObj?.cellHeight)!)

        let bottomH = Double(ScreenH) - Double(NavHeight) - Double(headerHeight) - cellheight - Double(height)
        
        self.tableView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(-(bottomH < 120 ? 120 : bottomH))
            })
        if(bottomH < 120){
            
            self.tableView.isScrollEnabled = true
        }else{
            
            self.tableView.isScrollEnabled = false
        }
        
    }
    
    @objc private func handleSingleTap(tap:UITapGestureRecognizer) {
        print("单击")
        
        let tag = tap.view?.tag
        
        
        PhotoBroswerVC.show(self, type: PhotoBroswerVCTypeModal, index: UInt(tag!)) { () -> [Any]? in
            
            let modelsM = NSMutableArray()
            
            let num = self.dataModel?.returnObj?.workDealImgs!.count
            
            for  i in 0..<num! {
                
                let m =  self.dataModel?.returnObj?.workDealImgs![i];
                
                let pbModel : PhotoModel  = PhotoModel.init()
                
                
                pbModel.mid = UInt(NSInteger( i + 1))
//                pbModel.title = "";//[NSString stringWithFormat:@"这是标题%@",@(i+1)];
//                pbModel.desc = "";//[NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
                pbModel.image_HD_U = m?.imgUrl
                
                //源frame
                pbModel.sourceImageView = tap.view as! UIImageView;
                
                modelsM.add(pbModel)
              
            }
            
            
            return modelsM as! [Any];
            
            }
        
//        //避免循环引用
//        __weak typeof(self) weakSelf=self;
//
//        [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
//
//
//            NSArray *networkImages=@[
//            @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
//            @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
//
//            ];
//
//            NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
//            for (NSUInteger i = 0; i< networkImages.count; i++) {
//
//            PhotoModel *pbModel=[[PhotoModel alloc] init];
//            pbModel.mid = i + 1;
//            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
//            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
//            pbModel.image_HD_U = networkImages[i];
//
//            //源frame
//            UIImageView *imageV =(UIImageView *) weakSelf.contentView.subviews[i];
//            pbModel.sourceImageView = imageV;
//
//            [modelsM addObject:pbModel];
//            }
//
//            return modelsM;
//            }];
        
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
