//
//  AlibiView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import Kingfisher

class MyAlibiCell: UITableViewCell {
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> MyAlibiCell{
        let reuseIdentifier = "myAlibiCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = MyAlibiCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! MyAlibiCell
    }
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = gray_F5F5F5
        contentView.addSubview(imageView1)
        contentView.addSubview(imageView2)
        contentView.addSubview(imageView3)
        contentView.addSubview(dateLabel)
        contentView.addSubview(lineView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupFrame() {
        imageView1.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(15)
            make.width.height.equalTo(75)
        }
        
        imageView2.snp.makeConstraints { (make) in
            make.left.equalTo(imageView1.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(75)
        }
        
        imageView3.snp.makeConstraints { (make) in
            make.left.equalTo(imageView2.snp.right).offset(15)
            make.top.equalTo(15)
            make.width.height.equalTo(75)
        }
        
//        dateLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(13)
//            make.left.equalTo(imageView3.snp.bottom).offset(15)
//        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Properties
    lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = font14
        label.textColor = black_333333
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var model = MyAlibiModel() {
        didSet {
            imageView1.kf.setImage(with: URL.init(string: model.imageArray[0]))
            imageView2.kf.setImage(with: URL.init(string: model.imageArray[1]))
            imageView3.kf.setImage(with: URL.init(string: model.imageArray[2]))
            dateLabel.text = DateTool.strDateToStr月日时分(strDate: model.create_time)
        }
    }    
}

class PhotoButtonView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoView)
        setupFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Factory Method
    class func viewWith(ownVC: UIViewController, uploadCompleteClosure: @escaping ()->Void) -> PhotoButtonView {
        let view = PhotoButtonView()
        view.ownVC = ownVC
        view.uploadCompleteClosure = uploadCompleteClosure
        return view
    }
    
    //MARK: - Setup
    func setupFrame() {
        photoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Event Response
    @objc func tapAction() {
        self.photoPickerTool.openCamera()
    }
    
    //MARK: - Properties
    lazy var photoView: UIImageView = {
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "pic_upload"))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var photoPickerTool = PhotoPickerTool.photoPickerWith(uploadPara: "upload_daily_evidence", ownerViewController: ownVC) { (url, localURL) in
        self.url = url
        self.photoView.kf.setImage(with: URL.init(string: localURL))
        self.uploadCompleteClosure()
    }
    
    var uploadCompleteClosure: ()->Void = {}
    
    var url = ""
    var ownVC = UIViewController()
}
