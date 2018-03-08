//
//  AlibiView.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/27.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit
import Kingfisher

class DAlibiCell: UITableViewCell {
    
    //MARK: - FactoryMethod
    class func cellWith(tableView : UITableView) -> DAlibiCell{
        let reuseIdentifier = "alibiCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = DAlibiCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! DAlibiCell
    }
    
    //MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = white_FFFFFF
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
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(imageView3.snp.bottom).offset(10)
        }
        
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
        label.font = font11
        label.textColor = gray_808080
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = gray_F0F0F0
        return view
    }()
    
    var model = DAlibiModel() {
        didSet {
            imageView1.kf.setImage(with: URL.init(string: model.imageArray[0]), placeholder: placeHolderImg, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            imageView2.kf.setImage(with: URL.init(string: model.imageArray[1]), placeholder: placeHolderImg, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            imageView3.kf.setImage(with: URL.init(string: model.imageArray[2]), placeholder: placeHolderImg, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
            dateLabel.text = DateTool.strDateToStr年月日(strDate: model.create_time)
        }
    }    
}

class DPhotoButtonView: UIView {
    
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
    class func viewWith(uploadPara: String, uploadType: String = "", uploadOrderId: String = "", ownVC: UIViewController, uploadCompleteClosure: @escaping ()->Void) -> DPhotoButtonView {
        let view = DPhotoButtonView()
        view.uploadPara = uploadPara
        view.uploadType = uploadType
        view.uploadOrderId = uploadOrderId
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
    
    lazy var photoPickerTool = PhotoPickerTool.toolWith(uploadPara: uploadPara, uploadType: uploadType, uploadOrderId: uploadOrderId, ownerViewController: ownVC) { (imageName, localURL) in
        self.imageName = imageName
        self.photoView.kf.setImage(with: URL.init(string: localURL))
        self.uploadCompleteClosure()
    }
    
    var uploadPara = ""
    var uploadType = ""
    var uploadOrderId = ""
    var ownVC = UIViewController()
    
    var uploadCompleteClosure: ()->Void = {}    
    var imageName = ""
}
