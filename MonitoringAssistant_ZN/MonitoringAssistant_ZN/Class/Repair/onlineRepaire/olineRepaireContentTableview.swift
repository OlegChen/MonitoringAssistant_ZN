//
//  olineRepaireContentTableview.swift
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class olineRepaireContentTableview: UITableViewController ,MKDropdownMenuDataSource, MKDropdownMenuDelegate
,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let typeTitles : NSArray = ["Circle", "Triangle", "Rectangle", "Pentagon", "Hexagon"]
    
    
    @IBOutlet weak var dropDownMenu: MKDropdownMenu!
    
    @IBOutlet weak var footerVeiw: PersonDataAddPicCell!
    
    
    @IBOutlet weak var contentTextView: UIPlaceHolderTextView!
    
    ///相机，相册
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    
    var imageArr : NSMutableArray = NSMutableArray()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //--请选择报修类型--
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "现场报修"
        
        //        self.tableView.delegate = self
        //        self.tableView.dataSource = self
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        self.dropDownMenu.backgroundColor = UIColor.white
        self.dropDownMenu.useFullScreenWidth = true
        self.dropDownMenu.delegate = self
        self.dropDownMenu.dataSource = self
        self.dropDownMenu.componentTextAlignment = NSTextAlignment.left
        self.dropDownMenu.dropdownShowsTopRowSeparator = false
        
        self.contentTextView.placeholder = "请输入您的内容"
        self.contentTextView.placeholderColor = RGBCOLOR(r: 208, 208, 208)
        
        let view:UIView = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.frame = CGRect(x:0 , y : 0 , width: ScreenW , height:10)
        let shadow:UIView = UIView()
        shadow.backgroundColor = UIColor.white
        shadow.frame = CGRect(x:0 , y : 7 , width: ScreenW , height:3)
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOpacity = 0.3
        shadow.layer.shadowRadius = 3
        shadow.layer.shadowOffset = CGSize(width:0 ,height:0)
        view.addSubview(shadow)
        self.dropDownMenu.spacerView = view;
        
        self.dropDownMenu.backgroundDimmingOpacity = 0.00;
        self.dropDownMenu.tintColor = UIColor.clear
        //        self.perform(#selector(qwer), with: self, afterDelay: 3)
        
        footerVeiw.addPicturesBlock = {
            
            
            let actionSheet=UIActionSheet()
            
            actionSheet.addButton(withTitle:"取消" )//addButtonWithTitle("取消")
            actionSheet.addButton(withTitle:"拍照" )//addButtonWithTitle("动作1")
            actionSheet.addButton(withTitle:"从相册选择" )//addButtonWithTitle("动作2")
            actionSheet.cancelButtonIndex=0
            actionSheet.delegate=self
            actionSheet.show(in: self.view)
            
        }
        
        footerVeiw.deleteTweetImageBlock = {
            index in
            
            
            
        }
        
        
        self.footerVeiw.height = PersonDataAddPicCell.cellHeight(withObj: self.imageArr.count)
        self.tableView.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dropDownMenu.closeAllComponents(animated: false)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        //获得照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let data = UIImageJPEGRepresentation(image,0.4);
        let imageBase64String = data?.base64EncodedString()
        
        self.imageArr.add(image)
        
        self.footerVeiw.setDataArray(self.imageArr as! [Any], isLoading: false)
        
        self.footerVeiw.height = PersonDataAddPicCell.cellHeight(withObj: self.imageArr.count)
        self.tableView.reloadData()
        
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 2
        }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return section == 0 ? 4 : 1
        }
    
        override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
            return 10
        }
    
        override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
            let view : UIView = UIView()
            view.backgroundColor  = UIColor.clear
            return view
        }
    
//        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        }
    
    
    // MKDropdownMenuDataSource
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        
        return 1
    }
    
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, attributedTitleForComponent component: Int) -> NSAttributedString? {
        
        let att = NSAttributedString.init(string: "--请选择报修类型--", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14) , NSAttributedStringKey.foregroundColor : RGBCOLOR(r: 51, 51, 51)])
        
        return att
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        
        return self.typeTitles.count
    }
    
    //MKDropdownMenuDelegate
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, rowHeightForComponent component: Int) -> CGFloat {
        
        return 0
    }
    
//    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, widthForComponent component: Int) -> CGFloat {
//
//        return ScreenW //180
//    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, shouldUseFullRowWidthForComponent component: Int) -> Bool {
        return true
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view : UIView = UIView()
        
        let label : UILabel = UILabel()
        label.text = self.typeTitles[row] as? String
        label.font = UIFont.systemFont(ofSize:13 )
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
//            make.left.equalTo(view).offset(10)
        }
        
        
        return view
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        
        
        print(row)
        
        dropdownMenu.closeAllComponents(animated: true)
        
    }
    
}
