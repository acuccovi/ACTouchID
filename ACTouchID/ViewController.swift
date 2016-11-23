//
//  ViewController.swift
//  ACTouchID
//
//  Created by Alessio Cuccovillo on 20/11/16.
//  Copyright © 2016 Alessio Cuccovillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ACTouchIDDelegate {

    let acTouchID = ACTouchID("ACTouchID Test APP")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        acTouchID.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ sender: UIButton, forEvent event: UIEvent) {
        acTouchID.requireTouchIDAtuth()
    }

    // MARK: - ACTouchIDDelegate

    func ACTouchIDAuthDone(withResult success: Bool, andError error: (code: Int, description: String)?) {
        var messsage = "Success"
        if let error = error {
            messsage = "Error (\(error.code)): \(error.description)"
        }
        let alert = UIAlertController(title: "ACTouchID Result", message: messsage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

