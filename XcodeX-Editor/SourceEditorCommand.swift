//
//  SourceEditorCommand.swift
//  XcodeX-Editor
//
//  Created by Kuma on 2017/11/21.
//  Copyright © 2017年 KumaPower. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        //"com.kumapower.XcodeX.XcodeX"
        
        let identifier = invocation.commandIdentifier.split(separator: ".").last!
        
        switch identifier {
        case "DuplicateCurrentLine":
            let selectObject = invocation.buffer.selections.lastObject as!XCSourceTextRange
            let start = selectObject.start.line
            let end = selectObject.end.line
            let lines = invocation.buffer.lines.subarray(with: NSMakeRange(start, end-start+1))
            var index = end + 1;
            for line in lines {
                invocation.buffer.lines.insert(line, at: index)
                index += 1
            }
            
        case "DeleteCurrentLine":
            // 第一个选中区域
            let firstSelectObject = invocation.buffer.selections.firstObject as! XCSourceTextRange
            // 开始删除的位置
            let start = firstSelectObject.start.line
            // 要删除的行数
            let end = firstSelectObject.end.line
            // 设置删除的范围
            let deleteRange = IndexSet(integersIn: start...end)
            // 删除对应行的代码
            invocation.buffer.lines.removeObjects(at: deleteRange)
            
        default :
            print("Unknown identifier.")
        }
        
        completionHandler(nil)
    }
    
}
