//
//  PresenterQue.swift
//  DDVP
//
//  Created by Pankaj Neve on 22/01/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import Foundation


enum PresenterQue: Int {
    case QueTitle = 0
    case QuestionStr = 2
    case VottingDuration = 3
    case Option1 = 4
    case Option2 = 5
    case Option3 = 6
    case Option4 = 7
    
    private func getLabelText() -> String {
        switch self {
        case .QueTitle:
            return "Title"
        case .QuestionStr:
            return "Question"
        case .VottingDuration:
            return "Duration (in secs)"
        case .Option1:
            return "Option 1"
        case .Option2:
            return "Option 2"
        case .Option3:
            return "Option 3"
        case .Option4:
            return "Option 4"
        }
    }
    
    func getDictKeyTitle() -> String {
        switch self {
        case .QueTitle:
            return "Title"
        case .QuestionStr:
            return "Question"
        case .VottingDuration:
            return "Duration"
        case .Option1:
            return "Option 1"
        case .Option2:
            return "Option 2"
        case .Option3:
            return "Option 3"
        case .Option4:
            return "Option 4"
        }
    }
    
    private func isInputNumber() -> Bool {
        switch self {
        case .QueTitle, .QuestionStr, .Option1, .Option2, .Option3, .Option4:
            return false
        case .VottingDuration:
            return true
        }
    }
    
    static func getTotalTextLabels() -> Int {
        return PresenterQue.Option4.rawValue + 1
    }
    
    static func getTextLabelAtIndex(index: Int) -> String {
        if let textStr = PresenterQue(rawValue: index) {
            return textStr.getLabelText()
        }
        return ""
    }
    
    static func isInputNumberAtIndex(index: Int) -> Bool {
        if let txt = PresenterQue(rawValue: index) {
            return txt.isInputNumber()
        }
        return false
    }
}
