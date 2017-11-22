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
        
        // 选中区域
        let firstSelectObject = invocation.buffer.selections.firstObject as! XCSourceTextRange
        let lastSelectObject = invocation.buffer.selections.lastObject as!XCSourceTextRange
        
        // 位置
        let start = firstSelectObject.start.line
        let end = lastSelectObject.end.line
        
        switch identifier {
        case "DuplicateCurrentLine":
            let lines = invocation.buffer.lines.subarray(with: NSMakeRange(start, end-start+1))
            var index = end + 1;
            for line in lines {
                invocation.buffer.lines.insert(line, at: index)
                index += 1
            }
            
        case "DeleteCurrentLine":
            let deleteRange = IndexSet(integersIn: start...end)
            invocation.buffer.lines.removeObjects(at: deleteRange)
            
        case "InsertLineAbove":
            invocation.buffer.lines.insert("    ", at: start)
            let position = XCSourceTextPosition(line: start, column: 4)
            let selection = XCSourceTextRange(start: position, end: position)
            invocation.buffer.selections.removeAllObjects()
            invocation.buffer.selections.add(selection)
            
            
        case "InsertLineBelow":
            invocation.buffer.lines.insert("    ", at: end+1)
            
        default :
            print("Unknown identifier.")
        }
        
        completionHandler(nil)
    }
    
}
