//
//  Command.swift
//  SwiftELM327
//
//  Created by Anatoly Myaskov on 06/08/2019.
//  Copyright © 2019 Anatoly Myaskov. All rights reserved.
//

import Foundation

public protocol CommandProtocol {
    func raw() -> String
}

public struct Command {
    init() {}
}
