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
    
    func indent(with line: String) -> (String, Int) {
        var count = 0
        var string = ""
        for character in line {
            if character == " " {
                count += 1
                string += " "
            } else {
                break
            }
        }
        return (string, count)
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        //"com.kumapower.XcodeX.XcodeX"
        
        // 选中区域
        let firstSelectObject = invocation.buffer.selections.firstObject as! XCSourceTextRange
        let lastSelectObject = invocation.buffer.selections.lastObject as! XCSourceTextRange
        
        // 位置
        let start = firstSelectObject.start.line
        let end = lastSelectObject.end.line
        
        // 光标位置
        var position = (invocation.buffer.selections.lastObject as! XCSourceTextRange).end;
        
        let identifier = invocation.commandIdentifier.split(separator: ".").last!
        switch identifier {
        case "DuplicateCurrentLine"://复制选中的行
            let lines = invocation.buffer.lines.subarray(with: NSMakeRange(start, end+1-start))
            var index = end + 1;
            for line in lines {
                invocation.buffer.lines.insert(line, at: index)
                index += 1
            }
            
            index -= 1
            let line = invocation.buffer.lines[index] as! String;
            position = XCSourceTextPosition(line: index, column: line.count)
            
        case "DeleteCurrentLine"://删除选中的行
            let deleteRange = IndexSet(integersIn: start...end)
            invocation.buffer.lines.removeObjects(at: deleteRange)
            var index = start - 1;
            if index < 0 {
                index = 0
            }
            let line = invocation.buffer.lines[index] as! String;
            position = XCSourceTextPosition(line: index, column: line.count)

        case "InsertLineAbove"://在当前行上方插入一行
            let (line, column) = indent(with: invocation.buffer.lines[start] as! String)
            invocation.buffer.lines.insert(line, at: start)
            position = XCSourceTextPosition(line: start, column: column)
            
            
        case "InsertLineBelow"://在当前行下方插入一行
            let index = end + 1;
            let (line, column) = indent(with: invocation.buffer.lines[index] as! String)
            invocation.buffer.lines.insert(line, at: index)
            position = XCSourceTextPosition(line: index, column: column)
            
        default :
            print("Unknown identifier.")
        }
        
        let selection = XCSourceTextRange(start: position, end: position)
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(selection)
        
        completionHandler(nil)
    }
    
}
