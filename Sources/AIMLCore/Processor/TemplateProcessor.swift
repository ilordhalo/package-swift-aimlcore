//
//  TemplateProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/9.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    用户可以自定类遵循该协议，实现该协议的方法
    完成后，将元素名：类名加入到AIMLProcessor类中，即可在处理aiml元素的时候用到自定的类
    类需继承自NSObject
*/
public protocol TemplateProcessor: XMLParserDelegate {
    func process(str: String, core: Core, attribute: [String: String]) -> String
}
