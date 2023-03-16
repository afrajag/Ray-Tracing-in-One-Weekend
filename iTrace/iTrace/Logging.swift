//
//  Logging.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 31/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

/// Log the current filename and function, with an optional extra message. Call this with no arguments to simply print the current file and function. Log messages will include an Emoji selected from a list in the function, based on the hash of the filename, to make it easier to see which file a message comes from.
/// - Parameter message: Optional message to include
///   - file: Don't use; Swift will fill in the file name
///   - function: Don't use, Swift will fill in the function name
///   - line: Don't use, Swift will fill in the line number
func log(_ message: String? = nil, file: String = #file, function: String = #function, line: Int = #line) -> Void {
    //#if DEBUG
    // Feel free to change the list of Emojis, but don't make it shorter, because a longer list is better.
    let logEmojis = ["😀","😎","😱","😈","👺","👽","👾","🤖","🎃","👍","👁","🧠","🎒","🧤","🐶","🐱","🐭","🐹","🦊","🐻","🐨","🐵","🦄","🦋","🌈","🔥","💥","⭐️","🍉","🥝","🌽","🍔","🍿","🎹","🎁","❤️","🧡","💛","💚","💙","💜","🔔"]
    let logEmoji = logEmojis[abs(file.hashValue % logEmojis.count)]
    if let message = message {
        print("Milestone: \(logEmoji) \((file as NSString).lastPathComponent):\(line) \(function): \(message)")
    } else {
        print("Milestone: \(logEmoji) \((file as NSString).lastPathComponent):\(line) \(function)")
    }
    //#endif
}

/// Convenience to log an error using `log`-style logging with file location and an Emoji
/// - Parameters:
///   - error: Any `Error`
///   - file: Don't use; Swift will fill in the file name
///   - function: Don't use, Swift will fill in the function name
///   - line: Don't use, Swift will fill in the line number
func log(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) -> Void {
    log(error.localizedDescription, file: file, function: function, line: line)
}
