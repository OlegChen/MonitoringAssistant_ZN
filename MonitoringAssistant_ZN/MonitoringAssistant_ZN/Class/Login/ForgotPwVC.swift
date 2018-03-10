//
//  ForgotPwVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class ForgotPwVC: BaseTableVC ,UITextFieldDelegate{
    
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var newPwTextField: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "忘记密码"
        
        self.phoneNumTextField.keyboardType = UIKeyboardType.numberPad
        self.phoneNumTextField.tag = 1000
        self.newPwTextField.tag = 2000
        
        self.phoneNumTextField.delegate = self
        self.newPwTextField.delegate = self
        
    }
    
    
    @IBAction func sendBtnClick(_ sender: UIButton) {
        
        
        
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
        
        let textLength = text.characters.count + string.characters.count - range.length
        
        return textLength <= 16
        
        if textField.tag == 1000 {
            
            //新号码
        }else if textField.tag == 2000 {
            
            //密码
            
        }else{
            
            
        }
        
        
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
