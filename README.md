# SwiftELM327



```swift
var elm = ELM327()
elm.delegate = self
elm.startSession(address: "192.168.0.10", port: "35000")
```
Send at command
```swift
elm.sendAT(command: "RV")
```

Send to car
```swift
elm.sendCar(command: "1000")
```
