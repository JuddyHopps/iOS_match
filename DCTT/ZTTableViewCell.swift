//
//  ZTTableViewCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/8.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class ZTTableViewCell: UITableViewCell ,HomeCellFillDateAble , DisLikeButtonStyle{

    @IBOutlet weak var bg: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var user_avatar: UIImageView!
    
    @IBOutlet weak var contentImg: UIImageView!
    
    @IBOutlet weak var contentImg_w: NSLayoutConstraint!
    
    @IBOutlet weak var contentImg_h: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var dislikeBtn: UIButton!
    
    @IBOutlet weak var readCnt: UILabel!
    
    
    @IBOutlet weak var date: UILabel!
    
    ///点击不喜欢处理操作
    var dislikeBlock:(() -> Void)?

    @IBAction func dislikeAction(_ sender: Any) {
        Tools.showMsg("不喜欢该动态?", title: "隐藏") { [weak self] in
            guard let  ss = self else {return}
            if let b = ss.dislikeBlock {
                b()
            }
        }

    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bg.layer.borderColor = kTableviewBackgroundColor.cgColor
//        bg.layer.borderWidth = 1
//        bg.layer.cornerRadius = 5        
//        bg.layer.masksToBounds = true
        
        disLikeBtnSetStyle(dislikeBtn)
        
        contentImg_h.constant = 0
        contentImg.clipsToBounds = true;
    }

    func fill(_ d:[String:Any]) {
        
        fillData(msg: content, user: user, date: date, data: d)
        
        readCnt.text = "阅读\(String.isNullOrEmpty(d["readCnt"]))"
        date.text = "\(date.text!)"
        let cc = String.isNullOrEmpty(d["content"])
        
        if let d = objectFrom(cc) {
            title.text = String.isNullOrEmpty(d["title"])
        }
        
        ////含有图片的动态
        let images = String.isNullOrEmpty(d["images"])
        let arr = images.components(separatedBy: ",")

        if arr.count > 0  && ((arr.first?.lengthOfBytes(using: String.Encoding.utf8))! > 10) {
            contentImg_h.constant = kCurrentScreenWidth / 3.0;
            
            contentImg_w.constant = contentImg_h.constant;
            
            let url = URL.init(string: arr.first!)
            contentImg.kf.setImage(with: url, placeholder: UIImage (named: "default_image2"), options: nil, progressBlock: nil)
        }else{
            contentImg_h.constant = 0
        }
        

        
        
        /////////////msg
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byTruncatingTail //byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        
        let attri:[String:Any] = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 16) ,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
            //NSKernAttributeName:1
        ]
        
        let str = content.text 
        content.text = nil
        
        let attriStr = NSAttributedString.init(string: str!, attributes: convertToOptionalNSAttributedStringKeyDictionary(attri))
        content.attributedText = attriStr
        
        
        guard let dic = d["user"] as? [String:Any] else {return}
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            user_avatar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil)
        }
    }
    
    override func prepareForReuse() {
        title.text = nil
        content.text = nil
    }
    
}

extension ZTTableViewCell:CellParseJsonAble{}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
