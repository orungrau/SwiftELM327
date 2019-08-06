//
//  CANCommand.swift
//  SwiftELM327
//
//  Created by Anatoly Myaskov on 06/08/2019.
//  Copyright © 2019 Anatoly Myaskov. All rights reserved.
//

import Foundation

extension Command {
    public enum CAN: CommandProtocol {
        case custom(String)
        
        public func raw() -> String {
            switch self {
            case .custom(let data):
                return data
            }
        }
    }

}
