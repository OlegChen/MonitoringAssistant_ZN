//
//  onlineRepaire.swift
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class onlineRepaire: BaseVC  {

    var container : olineRepaireContentTableview!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "现场报修"
        
     
    }
    
    
    @IBAction func sureBtnClick(_ sender: UIButton) {
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "containerView"  {

            self.container = segue.destination as! olineRepaireContentTableview

        }

    }
}
