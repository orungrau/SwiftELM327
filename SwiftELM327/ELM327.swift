
import Foundation

public enum ELM327State {
    case connected
    case disconnect
}

public typealias ELM327StateHandler = (ELM327State) -> ()

public class ELM327: NSObject {
    fileprivate var socket = Socket()
    fileprivate let queue = DispatchQueue(label: "com.myaskov.SwiftELM327.RequestQueue")
    
    fileprivate var tempResponse = ""
    fileprivate var response = ""
    
    fileprivate var state: ELM327State = .disconnect
    
    fileprivate var stateHandler: ELM327StateHandler?
}

extension ELM327 {
    public func connect(host: String = "192.168.0.10", port: Int = 35000) {
        socket.delegate = self
        socket.connect(address: host, port: UInt32(port))
    }
    
    public func disconnect() {
        socket.delegate = nil
        socket.disconnect()
    }
    
    public func send(command: CommandProtocol, handler: @escaping (Response) -> ()) {
        queue.async {
            while (self.response.count == 0) {}
            handler(Response(command: command.raw(), response: self.response))
            self.response = ""
            return
        }
    }
    
    public func state(handler:@escaping ELM327StateHandler) {
        self.stateHandler = handler
    }
}

extension ELM327: SocketDelegate {
    func response(_ socket: Socket, response: String) {
        if (response.range(of: ">") != nil) {
            tempResponse = tempResponse+response
            self.response = tempResponse
        } else {
            tempResponse = tempResponse+response
        }
    }
    
    func state(_ socket: Socket, state: SocketState) {
        switch state {
        case .connected:
            self.state = .connected
        case .error:
            self.state = .disconnect
            self.disconnect()
        }
        
        self.stateHandler?(self.state)
    }
}
