//
//  CacheTool.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/12/11.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

class CacheTool {
    
    //iPhone的cachesDirectory（Kingfisher的图片也默认缓存在此）
    static let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

    //统计缓存大小
    class func fileSizeOfCache()-> Int {
        //取出文件夹下所有文件数组
        let fileArray = FileManager.default.subpaths(atPath: cachePath)
        //计算文件大小
        var size = 0
        for file in fileArray! {
            // 把文件名拼接到路径中
            let path = "\(cachePath)/\(file)"
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).integerValue
                }
            }
        }
        let fileSizeOfCache = size / 1024 / 1024
        return fileSizeOfCache
    }
    
    //清空缓存
    class func clearCache() {
        //取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath)
        //删除
        for file in fileArr! {
            let path = "\(cachePath)/\(file)"
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }
    }
}

//MARK: - 图片缓存
extension CacheTool {
    //MARK: - 图片缓存
    class func imageUrl(image: UIImage) -> URL {
        //文件名
        let filePath = "\(cachePath)/\(CacheTool.uniqueFileName()).jpg"
        //缩图
        image.draw(in: CGRect.init(x: 0, y: 0, width: 50, height: 50*4/3))//iPhone标准照片照片比例
        //压图
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        //保存
        FileManager.default.createFile(atPath: filePath, contents: imageData, attributes: nil)
        //获得url
        let localURL = URL(fileURLWithPath:filePath)
        return localURL
    }
    
    private class func uniqueFileName() -> String {
        var fileName = ""
        let nowDate = NSDate()
        let dateStr = String(nowDate.timeIntervalSince1970)
        let numStr = String(arc4random()%10000)
        
        fileName = "xiaobie\(dateStr)\(numStr)"
        return fileName
    }
}
