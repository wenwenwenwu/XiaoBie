//
//  String.swift
//  MorningHeadline
//
//  Created by wuwenwen on 2017/11/27.
//  Copyright © 2017年 wenwenwenwu. All rights reserved.
//

import UIKit

extension String {

    func heightWithStringAttributes(attributes : [NSAttributedStringKey : Any], fixedWidth : CGFloat) -> CGFloat {
        guard self.count > 0 && fixedWidth > 0 else { return 0 }
        
        let size = CGSize.init(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size, options:[.usesLineFragmentOrigin], attributes: attributes, context:nil)        
        return rect.height
    }

}



