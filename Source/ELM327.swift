//
//  ELM327.swift
//  CrioDiagnost
//
//  Created by Anatoly Myaskov on 06.08.17.
//  Copyright © 2017 Anatoly Myaskov. All rights reserved.
//

import UIKit

public enum ELM327Error{
    case NODATA
    case STOPED
}

public enum SessionState{
    case Connected
    case Error
}

public protocol ELM327Delegate {
    func elm327(_ elm: ELM327, command: String, responce: String)
    func elm327(_ elm: ELM327, command: String, error: ELM327Error)
    func elm327(_ elm: ELM327, sessionState: SessionState)
}

public class ELM327: NSObject, EasySocketDelegate {
    var delegate: ELM327Delegate?

    var easySocket = EasySocket()
    var responceTemp = String()

    public func startSession(address: String, port: String){
        easySocket.delegate = self
        easySocket.connect(address: address as CFString, port: UInt32(port)!)
    }

    public func sendAT(command: String){
        easySocket.write(string: "AT"+command+"\r")
    }

    public func sendCar(command: String){
        easySocket.write(string: command+"\r")
    }

    public func socketResponce(_ socket: EasySocket, data: String) {
       // print(data)
        if (data.range(of: ">") != nil) {
            responceTemp = responceTemp+data
            self.responceData(data: responceTemp)
        } else {
            responceTemp = responceTemp+data
        }
    }

    private func responceData(data: String){
        var command = ""
        var responce = ""

        if let commandRange = data.range(of: "\r") {
            command = data[data.startIndex..<commandRange.lowerBound]
            //print("Command \(command)")
        }

        if let responceRange = data.range(of: "\r\r>") {
            responce = data[command.endIndex..<responceRange.lowerBound]
           // print("Command \(command)")
        }
        responceTemp = ""
        self.delegate?.elm327(self, command: command, responce: responce)
    }

    public func socketStatus(_ socket: EasySocket, status: SocketStatus) {
        switch status {
        case .connected:
            self.delegate?.elm327(self, sessionState: .Connected)
        case .connectionError:
            self.delegate?.elm327(self, sessionState: .Error)
        default:
            break
        }
    }
}
