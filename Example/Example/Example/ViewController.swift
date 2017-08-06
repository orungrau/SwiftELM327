//
//  ViewController.swift
//  Example
//
//  Created by Anatoly Myaskov on 06.08.17.
//  Copyright © 2017 Anatoly Myaskov. All rights reserved.
//

import UIKit
import SwiftELM327

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ELM327Delegate {

    var elm = ELM327()
    var responce = Array<NSDictionary>()

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
        self.elm.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        sendAtButton.isHidden = true
        sendCarButton.isHidden = true
        connectButton.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didSendAT(_ sender: Any) {
        elm.sendAT(command: atTextField.text!)
    }

    @IBAction func didSendCar(_ sender: Any) {
        elm.sendCar(command: carTextField.text!)
    }

    @IBAction func didConnect(_ sender: Any) {
        self.elm.startSession(address: addressTextField.text!, port: portTextField.text!)
    }

    func elm327(_ elm: ELM327, sessionState: SessionState) {
        if sessionState == .Connected {
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

    func elm327(_ elm: ELM327, command: String, responce: String) {
        self.responce.insert(["command": command, "responce": responce], at: 0)
        self.tableView.reloadData()
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let element = responce[indexPath.row] as NSDictionary


        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        (cell?.viewWithTag(101) as! UILabel).text = element.object(forKey: "command") as! String
        (cell?.viewWithTag(102) as! UILabel).text = element.object(forKey: "responce") as! String

        // Returning the cell
        return cell!
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responce.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

