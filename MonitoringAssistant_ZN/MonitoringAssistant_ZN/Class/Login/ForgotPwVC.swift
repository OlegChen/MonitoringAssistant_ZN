//
//  ForgotPwVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

protocol ChangedPwDelegate: class {

    func ChangedPw(phoneNum:String)
}


class ForgotPwVC: BaseTableVC ,UITextFieldDelegate{
    
    weak var delegate: ChangedPwDelegate!
    
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var newPwTextField: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var vertifyBtn: PhoneCodeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "忘记密码"
        
        self.phoneNumTextField.keyboardType = UIKeyboardType.numberPad
        self.phoneNumTextField.tag = 1000
        self.newPwTextField.tag = 2000
        
        self.phoneNumTextField.delegate = self
        self.newPwTextField.delegate = self
        
        
//        self.view.sho
    }
    
    
    @IBAction func verifyBtnClick(_ sender: Any) {
        
        if (self.phoneNumTextField.text!.characters.count > 0 ) {
            
            let para = [
                "companyCode" : "0000",
                "mobile"   : self.phoneNumTextField.text ?? ""
                ] as [String : Any]
        
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: getVerifyUrl, modelClass: "BaseModel", response: { (obj) in
                    
                    let model = obj as! BaseModel

                    if(model.statusCode == 800){
                        
                        self.vertifyBtn.startUpTimer()
                        
                    }else{
                        
                        YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                }
                    
                }, failture: { (error) in
                    
                    
                    
                })
            
        }
        
    }
    
    @IBAction func sendBtnClick(_ sender: UIButton) {
        
        if (self.phoneNumTextField.text!.characters.count > 0 && self.messageTextField.text!.characters.count > 0 && self.newPwTextField.text!.characters.count > 0) {
            
            let para = [
                        "companyCode" : "0000",
                        "mobile"   : self.phoneNumTextField.text ?? "",
                        "verify"    : self.messageTextField.text ?? "",
                        "loginPwd":self.newPwTextField.text
                ] as [String : Any]
            
            NetworkService.networkPostrequest(parameters: para as! [String : String], requestApi: forgetPwdUrl, modelClass: "BaseModel", response: { (obj) in
                
                let model = obj as! BaseModel

                if(model.statusCode == 800){
                    
                    if self.delegate != nil{
                        
                        self.delegate.ChangedPw(phoneNum: self.phoneNumTextField.text!)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
                    
                YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                
                
            }, failture: { (error) in
                
                
                
                
            })
            
            
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else{
            return true
        }
        

        
        if textField.tag == 1000 {
            
            //新号码
            let textLength = text.characters.count + string.characters.count - range.length
            return textLength <= 11
            
        }else if textField.tag == 2000 {
            
            //密码
            
        }else{
            
            
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
        
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
