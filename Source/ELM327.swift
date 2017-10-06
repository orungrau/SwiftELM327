//
//  ELM327.swift
//  CrioDiagnost
//
//  Created by Anatoly Myaskov on 06.08.17.
//  Copyright © 2017 Anatoly Myaskov. All rights reserved.
//

import Foundation

public enum ELM327SessionState {
    case connect
    case connectionError
}

public protocol ELM327Delegate {
    func elm327(command: String, response: String)
    func elm327(state: ELM327SessionState)
}

public class ELM327 {
    public var delegate: ELM327Delegate?

    fileprivate var easySocket = EasySocket()
    fileprivate var responseTemp: String = ""

    public init(){}
}

extension ELM327 {
    fileprivate func responseData(data: String){
        var command = ""
        var response = ""

        if let commandRange = data.range(of: "\r") {
            command = data[data.startIndex..<commandRange.lowerBound]
        }

        if let responseRange = data.range(of: "\r\r>") {
            response = data[(command+"\r").endIndex..<responseRange.lowerBound]
        }
        responseTemp = ""
        self.delegate?.elm327(command: command, response: response)
    }
}

extension ELM327: EasySocketDelegate {
    public func socketResponse(_ socket: EasySocket, data: String) {
        if (data.range(of: ">") != nil) {
            responseTemp = responseTemp+data
            self.responseData(data: responseTemp)
        } else {
            responseTemp = responseTemp+data
        }
    }
    public func socketStatus(_ socket: EasySocket, status: EasySocketStatus) {
        if status == .connected {
            self.delegate?.elm327(state: .connect)
        }
        if status == .error {
            self.delegate?.elm327(state: .connectionError)
        }
    }
}

extension ELM327 {
    public func startSession(address: String, port: String){
        easySocket.delegate = self
        easySocket.connect(address: address as CFString, port: UInt32(port)!)
    }

    public func sendAT(command: ATCommand){
        easySocket.write(string: "AT "+command.description+"\r")
    }

    public func sendCar(command: String){
        easySocket.write(string: command+"\r")
    }
}




