//
//  ChangePwVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class ChangePwVC: BaseTableVC ,UITextFieldDelegate, UIAlertViewDelegate{
    
    @IBOutlet weak var oldPw: UITextField!
    
    @IBOutlet weak var newPw: UITextField!
    
    @IBOutlet weak var makeSurePw: UITextField!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改密码"

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.newPw.delegate = self
        self.oldPw.delegate = self
        self.makeSurePw.delegate = self

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
            view.backgroundColor = .clear
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 12
    }

    
    @IBAction func sureBtnClick(_ sender: UIButton) {
        
        let old = oldPw.text!
        let new = newPw.text!
        let makesure = makeSurePw.text!
        
        if (old.characters.count > 0 && new.characters.count > 0 && makesure.characters.count > 0) {
            
            
            if(new != makesure){
                
                ZNCustomAlertView.handleTip("新密码与确认密码不一致", isShowCancelBtn: false, completion: { (sisure) in
                    
                })
                
                return
                
            }
            
            
            weak var weakSelf = self // ADD THIS LINE AS WELL
            
            UserCenter.shared.userInfo { (islogin, userInfo) in
                
                let para = ["companyCode":userInfo.companyCode ,
                            "orgCode":userInfo.orgCode ,
                            "empNo":userInfo.empNo ,
                            "empName":userInfo.empName,
                            "oldPwd":old,
                            "newPwd" : new
                ]
                
                NetworkService.networkPostrequest(parameters: para as! [String : String], requestApi: modifyPwdUrl, modelClass: "BaseModel", response: { (obj) in
                    
                    let model = obj as! BaseModel
                    if(model.statusCode == 800){
                        
                        UserCenter.shared.rememberPw(Pw: "", isRemember: false)
                        let vc = LoginVC.getLoginVC()
                        UIApplication.shared.keyWindow?.rootViewController = vc
                        
                    }else{
                        
                        ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                        
                    }
                    
                    
                }, failture: { (error) in
                    
                    
                })
                
            }
            
            
        }else{
            
            
            
            if (!(old.characters.count > 0)){
                
                ZNCustomAlertView.handleTip("请输入旧密码", isShowCancelBtn: false, completion: { (issure) in
                    
                })
                
            }else if(!(new.characters.count > 0 )){
                
                ZNCustomAlertView.handleTip("请输入新密码", isShowCancelBtn: false, completion: { (issure) in
                    
                })
                
            }else if(!(makesure.characters.count > 0)){
                
                ZNCustomAlertView.handleTip("请输入确认密码", isShowCancelBtn: false, completion: { (issure) in
                    
                })
            }
            
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        guard let text = textField.text else{
//            return true
//        }
//
//        let textLength = text.characters.count + string.characters.count - range.length
//
//        return textLength <= 16
        
        if(string == ""){return true}
        
        let regex = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: string)
        print("------" + string)
        
        return isValid
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}



