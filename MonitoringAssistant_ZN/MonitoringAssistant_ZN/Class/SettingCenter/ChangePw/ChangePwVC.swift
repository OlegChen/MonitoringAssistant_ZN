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
                
                 UIAlertView.init(title: "提示", message: "新密码与确认密码不一致", delegate: nil, cancelButtonTitle: "确定").show()
                
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
                        
                        UIAlertView.init(title: "提示", message: "密码修改成功", delegate: self, cancelButtonTitle: "确定").show()
                        
                    }else{
                        
                        UIAlertView.init(title: "提示", message: model.msg, delegate: nil, cancelButtonTitle: "确定").show()
                        
                    }
                    
                    
                }, failture: { (error) in
                    
                    
                })
                
            }
            
            
        }else{
            
             UIAlertView.init(title: "提示", message: "请将内容填写完整", delegate: nil, cancelButtonTitle: "确定").show()
            
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.characters.count + string.characters.count - range.length
        
        return textLength <= 16
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}



