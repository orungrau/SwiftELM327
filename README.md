# SwiftELM327



```swift
var elm = ELM327()
elm.delegate = self
elm.startSession(address: "ELM_ADDRESS", port: "ELM_PORT")
```
Send at command
```swift
elm.sendAT(command: .other("RV"))
```

Send to car
```swift
elm.sendCar(command: "1000")
```
