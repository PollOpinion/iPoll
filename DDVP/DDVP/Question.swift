//
//  Question.swift
//  DDVP
//
//  Created by Pankaj Neve on 22/01/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation


enum Question: Int {
    case QueTitle = 0
    case QuestionStr = 1
    case VotingDuration = 2
    case Option1 = 3
    case Option2 = 4
    case Option3 = 5
    case Option4 = 6
    
    private func getLabelText() -> String {
        switch self {
        case .QueTitle:
            return "Title"
        case .QuestionStr:
            return "Question"
        case .VotingDuration:
            return "Expires in"
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
    
    func getPlaceholderString() -> String {
        switch self {
        case .QueTitle:
            return "Question Title"
        case .QuestionStr:
            return "Question Statement"
        case .VotingDuration:
            return "Duration in Seconds"
        case .Option1:
            return "Answer text"
        case .Option2:
            return "Answer text"
        case .Option3:
            return "Answer text"
        case .Option4:
            return "Answer text"
        }
    }
    
    func getDictKeyTitle() -> String {
        switch self {
        case .QueTitle:
            return "Title"
        case .QuestionStr:
            return "Question"
        case .VotingDuration:
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
        case .VotingDuration:
            return true
        }
    }
    
    static func getTotalTextLabels() -> Int {
        return Question.Option4.rawValue + 1
    }
    
    static func getTextLabelAtIndex(index: Int) -> String {
        if let textStr = Question(rawValue: index) {
            return textStr.getLabelText()
        }
        return ""
    }
    
    static func getPlaceholderTextAtIndex(index: Int) -> String {
        if let textStr = Question(rawValue: index) {
            return textStr.getPlaceholderString()
        }
        return ""
    }
    
    static func isInputNumberAtIndex(index: Int) -> Bool {
        if let txt = Question(rawValue: index) {
            return txt.isInputNumber()
        }
        return false
    }
}