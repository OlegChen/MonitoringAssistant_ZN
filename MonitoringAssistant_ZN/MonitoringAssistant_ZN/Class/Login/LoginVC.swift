//
//  LoginVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class LoginVC: BaseTableVC ,ChangedPwDelegate ,UITextFieldDelegate{
    
    let kNavBarBottom = WRNavigationBar.navBarBottom()


    @IBOutlet weak var tableviewHeaderView: UIView!
    
    @IBOutlet weak var rememberPWBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var mobileTextfield: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    
    class func getLoginVC() ->  NavigationController {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginNav") as! NavigationController
    
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "登录"
        navBarBackgroundAlpha = 0
        
        self.mobileTextfield.delegate = self
        
        self.rememberPWBtn.imageView?.contentMode = UIViewContentMode.center
        self.rememberPWBtn.adjustsImageWhenHighlighted = false //使触摸模式下按钮也不会变暗
        self.rememberPWBtn.isSelected = true
        
        var image = UIImage(named: "login_button_touch")
        var imageHigh = UIImage(named: "login_button_touchch")
        let leftCapWidth: Int = Int(image!.size.width / 2) // 取图片Width的中心点
        let topCapHeight: Int = Int(image!.size.height / 2) // 取图片Height的中心点
        image = image?.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        imageHigh = imageHigh?.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)

        self.loginBtn.setBackgroundImage(image, for: UIControlState.normal)
        self.loginBtn.setBackgroundImage(imageHigh, for: UIControlState.highlighted)
        
        self.tableView.frame = CGRect(x: 0, y: CGFloat(kNavBarBottom), width: ScreenW, height: ScreenH)
        let img = UIImageView(frame:self.tableView.bounds)
        img.image = UIImage.init(named: "登录")
        img.contentMode = UIViewContentMode.scaleAspectFill
        self.tableView.backgroundView = img
        
        
        self.mobileTextfield.keyboardType = UIKeyboardType.numberPad
        
        UserCenter.shared.loginMobile { (mobile) in
            if(mobile.count > 0){
                self.mobileTextfield.text = mobile
            }
        }
        UserCenter.shared.loginPw { (pw) in
            if(pw.count > 0){
                self.pwTextField.text = pw
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginClick(_ sender: Any) {
        
        
        if(self.mobileTextfield.text!.characters.count > 0 && self.pwTextField.text!.characters.count > 0){
            
            let para = ["userName"   : self.mobileTextfield.text! ,
                        "userPwd"    : self.pwTextField.text! ,
                        "companyCode" : "0000"] as [String : Any]
            
            NetworkService.networkPostrequest(parameters: para as! [String : String], requestApi: LoginUrl, modelClass: String(describing: LoginModel.self), response: { (obj) in
                
                let model : LoginModel = obj as! LoginModel
                
                print( model.statusCode as Any )
                
                if(model.statusCode == 800){
                    
                    print( model.returnObj?.empName as Any  )
                    
                    UserCenter.shared.logIn(userModel: model)
                    UserCenter.shared.rememberLoginMobile(mobile: self.mobileTextfield.text!)
                    if(self.rememberPWBtn.isSelected){
                        
                        UserCenter.shared.rememberPw(Pw: self.pwTextField.text!)
                    }
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initViewController: NavigationController = storyBoard.instantiateViewController(withIdentifier: "rootNav") as! NavigationController
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.window?.rootViewController = initViewController
                    
                }else{
                    
                    YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                    
                }
                
            }) { (error) in
                
                
                
            }
            
        }else{
            
            UIAlertView.init(title: "提示", message: "用户名、密码需填写完整", delegate: nil, cancelButtonTitle: "确定").show()
            
        }
        
      
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
        
    }
    
    @IBOutlet weak var forgotPw: UIButton!
    
    @IBAction func forgotPwBtnClick(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ForgotPwVC") as! ForgotPwVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func ChangedPw(phoneNum: String) {
        
        self.mobileTextfield.text = phoneNum
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else{
            return true
        }

        //新号码
        let textLength = text.characters.count + string.characters.count - range.length
        return textLength <= 11
        
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
