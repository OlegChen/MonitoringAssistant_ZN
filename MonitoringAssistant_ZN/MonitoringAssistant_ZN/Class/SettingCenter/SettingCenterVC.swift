//
//  SettingCenterVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class SettingCenterVC: BaseTableVC ,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var TelL: UILabel!
    
    @IBOutlet weak var loginOutBtn: UIButton!
    
    ///相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "配置中心"
        
        self.view.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        loginOutBtn.layer.cornerRadius = 4
        headImg.cornerRadius = 23
        headImg.clipsToBounds = true

        self.getData()
        
        self.headImg.isUserInteractionEnabled = true
        let singleTap =  UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap(tap:)))
        self.headImg.addGestureRecognizer(singleTap)
        
    }
    
    @objc private func handleSingleTap(tap:UITapGestureRecognizer) {
        print("单击")
        
        let actionSheet=UIActionSheet()
        
        actionSheet.addButton(withTitle:"取消" )//addButtonWithTitle("取消")
        actionSheet.addButton(withTitle:"拍照" )//addButtonWithTitle("动作1")
        actionSheet.addButton(withTitle:"从相册选择" )//addButtonWithTitle("动作2")
        actionSheet.cancelButtonIndex=0
        actionSheet.delegate=self
        actionSheet.show(in: self.view)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        return indexPath.section == 0 ? false : true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            
            if indexPath.row == 0{
             
            }
            
        }else if indexPath.section == 1 {

            if(indexPath.row == 0){
                                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ChangePwVC") as! ChangePwVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                
                self.navigationController?.pushViewController(AboutUsVC(), animated: true)

            }
            
            
        }
        
        
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        
        
        print("点击了："+actionSheet.buttonTitle(at: buttonIndex)!)
        var sourceType: UIImagePickerControllerSourceType = .photoLibrary
        if (buttonIndex == 0) {
            
            return
        }else if (buttonIndex == 1) {

            //拍照
            sourceType = .camera
            
        }else if (buttonIndex == 2) {

            //相册
            sourceType = .photoLibrary
            
        }
        
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        pickerVC.sourceType = sourceType
        present(pickerVC, animated: true, completion: nil)
    
        
    }

    

    func getData() {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName
            ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: getUserUrl, modelClass: "LoginModel" , response: { (obj) in
                
                let model = obj as! LoginModel
                
                if (model.statusCode == 800){
                    
                    self.headImg.sd_setImage(with: URL.init(string: (model.returnObj?.headUrl)!), placeholderImage: UIImage(named:"head_portrait"), options: SDWebImageOptions(rawValue: SDWebImageOptions.RawValue(UInt8(SDWebImageOptions.retryFailed.rawValue) | UInt8(SDWebImageOptions.lowPriority.rawValue))) , completed:nil)

                    self.nameL.text = model.returnObj?.empName
                    self.TelL.text = model.returnObj?.mobile
                }
                
                
                
            }) { (error) in
                
            }
            
        }
        
    }


    
    @IBAction func loginOutClick(_ sender: UIButton) {
        
        UserCenter.shared.logOut()
        
        let vc = LoginVC.getLoginVC()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        //获得照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.headImg.image = image
        
        let data = UIImageJPEGRepresentation(image,0.4);
        let imageBase64String = data?.base64EncodedString()

        self.sendImg(imgStr: imageBase64String!)
        

    }

    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func sendImg(imgStr:String) {
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        YJProgressHUD.showProgress("图片上传..", in: UIApplication.shared.keyWindow)
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "headUrlStr":imgStr
            ]
            
            NetworkService.networkPostrequest(parameters: para as! [String : String], requestApi: modifyHeadUrlUrl, modelClass: "SendImgModel", response: { (obj) in
                
                let model = obj as! SendImgModel
                
                if model.statusCode == 800{
                    
                    let urlStr = model.returnObj
                    self.headImg.kf.setImage(with: URL.init(string:urlStr!))
                    
                    YJProgressHUD.showSuccess("头像修改成功", inview: UIApplication.shared.keyWindow)
                    
                }else{
                    
                    YJProgressHUD.showSuccess(model.msg, inview: UIApplication.shared.keyWindow)
                }
                
                
            }, failture: { (error) in
                
                
            })
            
        }
        
    }
    

}



