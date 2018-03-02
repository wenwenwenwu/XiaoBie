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
        view.addSubview(startTimeView)
        view.addSubview(至label)
        view.addSubview(endTimeView)
        view.addSubview(datePickerView)
        setupNavigationBar()
        setupDateView()
        setupPickerView(strDate: startDate)
        setupFrame()

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
        startTimeView.snp.makeConstraints { (make) in
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
        
        endTimeView.snp.makeConstraints { (make) in
            make.left.equalTo(至label.snp.right).offset(18)
            make.right.equalTo(-13)
            make.height.equalTo(30)
            make.centerY.equalTo(至label)
        }
    }
    
    func setupDateView() {
        //dateView的闭包之间循环引用，无法在lazy var中初始化
        startTimeView.dateButtonSelectedClosure = { [weak self] in
            self?.endTimeView.isSelected = false
            self?.setupPickerView(strDate: (self?.startTimeView.date)!)
        }
        endTimeView.dateButtonSelectedClosure = { [weak self] in
            self?.startTimeView.isSelected = false
            self?.setupPickerView(strDate: (self?.endTimeView.date)!)
        }
    }
    
    func setupPickerView(strDate: String) {
        let dateArray = strDate.components(separatedBy: "-")
        //带0数字转化成正常数字方便pickerView显示
         year = handle(text: dateArray[0])
         month = handle(text: dateArray[1])
         day = handle(text: dateArray[2])
    
        datePickerView.selectRow(yearArray.index(of: year)!, inComponent: 0, animated: true)
        datePickerView.selectRow(monthArray.index(of: month)!, inComponent: 1, animated: true)
        datePickerView.selectRow(dayArray.index(of: day)!, inComponent: 2, animated: true)
    }
    
    //MARK: - Event Response
    @objc func cancelButtonAction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonAction() {
        guard endDate >= startDate else {
            HudTool.showInfo(string: "结束时间要晚于起始时间")
            return
        }
        
        doneClosure(startDate, endDate)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChangedAction(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    //MARK: - Private Method
    func handle(text: String) -> String {
        if text[text.startIndex] == "0" {
            let newStartIndex = text.index(after: text.startIndex)
            return String(text[newStartIndex...])
        }
        return text
        
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            year = yearArray[row]
        case 1:
            month = monthArray[row]
        default:
            day = dayArray[row]
        }
        //正常数字转换为带0的数字方便输出
        let selectedItem = "\(DateTool.processTime(time: Int(year)!))-\(DateTool.processTime(time: Int(month)!))-\(DateTool.processTime(time: Int(day)!))"
        
        if startTimeView.isSelected {
            startTimeView.date = selectedItem
            startDate = selectedItem
        }
        
        if endTimeView.isSelected {
            endTimeView.date = selectedItem
            endDate = selectedItem
        }
    }
    
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
    
    lazy var startTimeView = DateView.viewWith(isSelected: true, date: startDate )
    lazy var endTimeView = DateView.viewWith(isSelected: false, date: endDate)
    
    lazy var datePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.frame = CGRect.init(x: 0, y: 130, width: screenWidth, height: 150)
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    var dayArray: [String] = {
        var array: [String] = []
        for item in 1...31 {
            array.append(String(item))
        }
        return array
    }()
    
    var monthArray: [String] = {
        var array: [String] = []
        for item in 1...12 {
            array.append(String(item))
        }
        return array
    }()
    
    var yearArray: [String] = {
        var array: [String] = []
        for item in 1900...2200 {
            array.append(String(item))
        }
        return array
    }()
    
    var year = ""
    var month = ""
    var day = ""
    
    var startDate = ""
    var endDate = ""
    
    var doneClosure: (String, String)->Void = {_,_  in }
    
}
