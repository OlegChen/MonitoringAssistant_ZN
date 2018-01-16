//
//  LoginVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class LoginVC: UITableViewController {

    @IBOutlet weak var tableviewHeaderView: UIView!
    
    @IBOutlet weak var rememberPWBtn: UIButton!
    
    @IBOutlet weak var showPwBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    class func getLoginVC() ->  LoginVC {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginClick(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "rootNav") as! UINavigationController
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = initViewController
        
        
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
