//
//  ViewController.swift
//  Example
//
//  Created by Anatoly Myaskov on 06/08/2019.
//  Copyright © 2019 Anatoly Myaskov. All rights reserved.
//

import UIKit
import SwiftELM327

class ViewController: UIViewController {
    
    var elm = ELM327()
    var response: Array<Dictionary<String, Any>> = []
    
    @IBOutlet weak var sendCarButton: UIButton!
    @IBOutlet weak var sendAtButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var carTextField: UITextField!
    @IBOutlet weak var atTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
        sendAtButton.isHidden = true
        sendCarButton.isHidden = true
        connectButton.isHidden = false
        
        
        elm.state { (state) in
            switch state {
            case .connected:
                self.sendAtButton.isHidden = false
                self.sendCarButton.isHidden = false
                self.connectButton.isHidden = true
            case .disconnect:
                self.sendAtButton.isHidden = true
                self.sendCarButton.isHidden = true
                self.connectButton.isHidden = false
                
                let optionMenu = UIAlertController(title: nil, message: "Connection Error", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                optionMenu.addAction(cancelAction)
                self.present(optionMenu, animated: true, completion: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSendAT(_ sender: Any) {
        elm.send(command: Command.AT.other(atTextField.text!)) { (data) in
            self.response.insert(["command": data.command, "response": data.response], at: 0)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func didSendCar(_ sender: Any) {
        elm.send(command: Command.CAN.custom(carTextField.text!)) { (data) in
            self.response.insert(["command": data.command, "response": data.response], at: 0)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func didConnect(_ sender: Any) {
        elm.connect(host: addressTextField.text!, port: Int(portTextField.text!) ?? 25000)
    }
}

/*
extension ViewController: ELM327Delegate {
    func elm327(state: ELM327SessionState) {
        if state == ELM327SessionState.connect {
            print("Ok")
            sendAtButton.isHidden = false
            sendCarButton.isHidden = false
            connectButton.isHidden = true
        } else {
            let optionMenu = UIAlertController(title: nil, message: "Connection Error", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    func elm327(command: String, response: String) {
        self.response.insert(["command": command, "response": response], at: 0)
        self.tableView.reloadData()
    }
}
*/

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let element = response[indexPath.row] as NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        (cell?.viewWithTag(101) as! UILabel).text = element.object(forKey: "command") as? String
        (cell?.viewWithTag(102) as! UILabel).text = element.object(forKey: "response") as? String
        
        return cell!
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

