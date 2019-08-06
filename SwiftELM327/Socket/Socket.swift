//
//  Socket.swift
//  SwiftELM327
//
//  Created by Anatoly Myaskov on 06/08/2019.
//  Copyright © 2019 Anatoly Myaskov. All rights reserved.
//

import Foundation

public enum SocketState {
    case connected
    case error
}

protocol SocketDelegate {
    func response(_ socket: Socket, response: String)
    func state(_ socket: Socket, state: SocketState)
}

class Socket: NSObject {
    var delegate: SocketDelegate?
    
    fileprivate var inputStream: InputStream!
    fileprivate var outputStream: OutputStream!
}

extension Socket {
    func connect(address: String, port:UInt32) {
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, address as CFString, port, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        self.outputStream.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        
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
}


extension Socket: StreamDelegate {
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (eventCode){
        case Stream.Event.errorOccurred:
            self.delegate?.state(self, state: .error)
        case Stream.Event.endEncountered:
            self.delegate?.state(self, state: .error)
        case Stream.Event.hasBytesAvailable:
            var buffer = [UInt8](repeating: 0, count: 4096)
            while (inputStream.hasBytesAvailable){
                let len = inputStream.read(&buffer, maxLength: buffer.count)
                if(len > 0){
                    let output = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                    self.delegate?.response(self, response: output! as String)
                }
            }
        case Stream.Event.openCompleted:
            self.delegate?.state(self, state: .connected)
        default: break
        }
    }
}
