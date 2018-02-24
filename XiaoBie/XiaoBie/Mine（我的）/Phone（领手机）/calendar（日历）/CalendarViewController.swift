//
//  CalendarViewController.swift
//  XiaoBie
//
//  Created by wuwenwen on 2018/2/24.
//  Copyright © 2018年 wenwenwenwu. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = white_FFFFFF
        view.addSubview(fromDateButton)
        view.addSubview(至label)
        view.addSubview(toDateButton)
        view.addSubview(datePickerView)
        setupNavigationBar()
        setupFrame()

    }
    
    deinit {
        print("🐱")
    }

    //MARK: - Setup
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = doneButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font : font14, NSAttributedStringKey.foregroundColor : blue_3296FA], for: .normal)
        navigationItem.title = "选择时间"
    }
    
    func setupFrame() {
        fromDateButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(至label.snp.left).offset(-18)
            make.height.equalTo(30)
            make.centerY.equalTo(至label)
        }
        
        至label.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        toDateButton.snp.makeConstraints { (make) in
            make.left.equalTo(至label.snp.right).offset(18)
            make.right.equalTo(-13)
            make.height.equalTo(30)
            make.centerY.equalTo(至label)
        }
    }
    
    //MARK: - Event Response
    @objc func cancelButtonAction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonAction() {
        print("完成")
    }
    
    @objc func dateChangedAction(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return yearArray.count
        case 1:
            return monthArray.count
        default:
            return dayArray.count
        }
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(yearArray[row])年"
        case 1:
            return "\(monthArray[row])月"
        default:
            return "\(dayArray[row])日"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            year = yearArray[row]
        case 1:
            month = monthArray[row]
        default:
            day = dayArray[row]
        }
        selectedItem = "\(year)-\(month)-\(day)"
        print(selectedItem)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 39
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickLabel = view as? UILabel
        if pickLabel == nil {
            pickLabel = UILabel()
            pickLabel!.textAlignment = .center
            pickLabel!.font = font16
            pickLabel!.textColor = gray_666666
        }
        pickLabel!.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickLabel!
    }
    
    //MARK: - Properties
    lazy var cancelButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelButtonAction))
        return buttonItem
    }()

    lazy var doneButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(doneButtonAction))
        return buttonItem
    }()
    
    lazy var 至label: UILabel = {
        let label = UILabel()
        label.text = "至"
        label.font = font14
        label.textColor = gray_666666
        return label
    }()
    
    lazy var fromDateButton = DateView.viewWith(isSelected: true, date: DateTool.str本月一号()) { [weak self] isSelected in
//        self?.toDateButton.isSelected = isSelected
    }
    lazy var toDateButton = DateView.viewWith(isSelected: false, date: DateTool.strToday()) {[weak self] isSelected in
        self?.fromDateButton.isSelected = false
        
    }
    
    lazy var dayArray: [String] = {
        var array: [String] = []
        for item in 1...31 {
            array.append(String(item))
        }
        return array
    }()
    
    lazy var monthArray: [String] = {
        var array: [String] = []
        for item in 1...12 {
            array.append(String(item))
        }
        return array
    }()
    
    lazy var yearArray: [String] = {
        var array: [String] = []
        for item in 1900...2200 {
            array.append(String(item))
        }
        return array
    }()
    
    lazy var datePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.frame = CGRect.init(x: 0, y: 130, width: screenWidth, height: 130)
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(yearArray.index(of: "2018")!, inComponent: 0, animated: false)
        pickerView.selectRow(monthArray.index(of: "2")!, inComponent: 1, animated: false)
        pickerView.selectRow(dayArray.index(of: "24")!, inComponent: 2, animated: false)

        return pickerView
    }()
    
    var selectedItem = ""
    var year = "", month = "", day = ""

}
