//
//  StringKitExtension.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/9.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public extension StringKit {
    public static func isChineseCharacter(_ c: Character) -> Bool {
        if ("\u{4E00}" <= c  && c <= "\u{9FA5}") {
            return true
        }
        return false
    }
    
    public static func containChinese(_ sentence: String) -> Bool {
        for c in sentence {
            if StringKit.isChineseCharacter(c) {
                return true
            }
        }
        return false
    }
    
    public static func fixChineseSentence(_ sentence: String) -> String {
        var tmp = ""
        var response = ""
        for c in sentence {
            if StringKit.isChineseCharacter(c) {
                tmp += " " + String(c) + " "
            }
            else {
                tmp += String(c)
            }
        }
        var lastC: Character = "a"
        for c in tmp {
            if lastC == " " && c == " " {
            }
            else {
                response += String(c)
            }
            lastC = c
        }
        return response
    }
    
    public static func fixRespnoseChinese(_ sentence: String) -> String {
        var response = ""
        for c in sentence {
            if StringKit.isChineseCharacter(c) {
                response = response.trimmingCharacters(in: .whitespaces)
            }
            response += String(c)
        }
        return response
    }
}
