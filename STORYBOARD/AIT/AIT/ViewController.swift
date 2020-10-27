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

/*                <viewController id="7mN-Vb-fyC" customClass="llantasViewController" customModule="AIT" customModuleProvider="target" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="0zn-fI-Ef6">
                        <rect key="frame" x="0.0" y="0.0" width="414" height="842"/> */

//                                            <action selector="llantasView:" destination="Zeo-ne-ACY" eventType="touchUpInside" id="sCz-kt-hpS"/>
