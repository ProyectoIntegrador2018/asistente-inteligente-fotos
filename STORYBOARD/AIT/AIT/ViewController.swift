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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           if segue.identifier == "segueToNext" {
//               if let destination = segue.destination as? Modo1ViewController {
//                   destination.nomb = nombres // you can pass value to destination view controller
//               }
//           }
    
    
}

