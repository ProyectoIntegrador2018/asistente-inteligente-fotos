//
//  ViewController.swift
//  AIT
//
//  Created by Terneros.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func llantasView(_ sender: Any) {
        self.performSegue(withIdentifier: "llantasSegue", sender: self)
        
    }
    
    @IBAction func chatarraClick(_ sender: Any) {
        self.performSegue(withIdentifier: "chatarraSegue", sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cameraType: CameraTypes = (segue.identifier == "llantasSegue") ? .llanta : .chatarra
        print(cameraType)
        if let destination = segue.destination as? llantasViewController {
            destination.cameraType = cameraType
        }
    }
}
