//
// Created by Anatoly Myaskov on 13.08.17.
// Copyright (c) 2017 Anatoly Myaskov. All rights reserved.
//

import Foundation

public enum ATCommand {
    case reset
    case header(Bool)
    case echo(Bool)
    case voltage
    case `protocol`
    case protocolNumber
    case versionId
    case deviceDescription
    case readDeviceIdentifier
    case setDeviceIdentifier(String)
    case other(String)

    var description: String {
        switch self {
            case .reset:
                return "WS"
            case let .header(bool):
                if bool == true {
                    return "H1"
                } else {
                    return "H0"
                }
            case let .echo(bool):
                if bool == true {
                    return "E1"
                } else {
                    return "E0"
                }
            case .voltage:
                return "RV"
            case .`protocol`:
                return "DP"
            case .protocolNumber:
                return "DPN"
            case .versionId:
                return "I"
            case .deviceDescription:
                return "@1"
            case .readDeviceIdentifier:
                return "@2"
            case .setDeviceIdentifier(let identifier):
                return "@2 " + identifier
            case .other(let command):
                return command
        }
    }
}

