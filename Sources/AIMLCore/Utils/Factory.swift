//
//  Factory.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public class Factory {
    /**
        根据给定的类名及域，生成该类的实例
    */
    public static func instance(classDomain: String, className: String) -> Any? {
        let classType: AnyClass? = NSClassFromString(classDomain + className)
        return (classType as? NSObject.Type)?.init()
    }
    
    /**
        根据给定的类全名，生成该类的实例
    */
    public static func instance(_ str: String) -> Any? {
        let classType: AnyClass? = NSClassFromString(str)
        return (classType as? NSObject.Type)?.init()
    }
}
