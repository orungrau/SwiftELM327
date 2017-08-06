//
//  EasySocket.swift
//  CrioDiagnost
//
//  Created by Anatoly Myaskov on 05.08.17.
//  Copyright © 2017 Anatoly Myaskov. All rights reserved.
//

import UIKit

public enum SocketStatus {
    case connected
    case connectionError
}

public protocol EasySocketDelegate {
    func socketResponce(_ socket: EasySocket, data: String)
    func socketStatus(_ socket: EasySocket, status: SocketStatus)
}

public class EasySocket: NSObject, StreamDelegate {
    var delegate: EasySocketDelegate?

    private var inputStream: InputStream!
    private var outputStream: OutputStream!

    func connect(address: CFString, port:UInt32) {
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocketToHost(nil, address as CFString, port, &readStream, &writeStream)

        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()

        self.inputStream.delegate = self
        self.outputStream.delegate = self

        self.inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)

        self.inputStream.open()
        self.outputStream.open()

    }

    func write(string: String){
        let data : NSData = string.data(using: String.Encoding.utf8, allowLossyConversion: false)! as NSData
        var buffer = [UInt8](repeating:0, count:data.length)
        data.getBytes(&buffer)
        self.outputStream.write(data.bytes.assumingMemoryBound(to: UInt8.self), maxLength: data.length)
    }

    func disconnect() {
        self.inputStream.close()
        self.outputStream.close()
    }

    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (eventCode){

        case Stream.Event.errorOccurred:
            self.delegate?.socketStatus(self, status: .connectionError)

        case Stream.Event.endEncountered:
            self.delegate?.socketStatus(self, status: .connectionError)

        case Stream.Event.hasBytesAvailable:
            var buffer = [UInt8](repeating: 0, count: 4096)
            while (inputStream.hasBytesAvailable){
                let len = inputStream.read(&buffer, maxLength: buffer.count)
                if(len > 0){
                    let output = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                    self.delegate?.socketResponce(self, data: output! as String)
                }
            }

        case Stream.Event.openCompleted:
                    print("[Socket] Open")
            self.delegate?.socketStatus(self, status: .connected)
            
        default: break
        }
    }
}
