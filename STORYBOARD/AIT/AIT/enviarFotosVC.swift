//
//  enviarFotosVC.swift
//  AIT
//
//  Created by Kevin Radtke on 08/10/20.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class enviarFotosVC: UIViewController {
    let googleDriveService = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**** Configure Google Sign In *****/
              
        GIDSignIn.sharedInstance()?.delegate = self
        
        // GIDSignIn.sharedInstance()?.signIn() will throw an exception if not set.
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeDrive]
      
        // Attempt to renew a previously authenticated session without forcing the
        // user to go through the OAuth authentication flow.
        // Will notify GIDSignInDelegate of results via sign(_:didSignInFor:withError:)
        GIDSignIn.sharedInstance()?.signInSilently()
        
    }
    
    @IBAction func sendToDrive(_ sender: Any) {
        // Start Google's OAuth authentication flow
        GIDSignIn.sharedInstance()?.signIn()
        print(googleUser?.profile.name ?? "No user", "is logged in.")
        if ((googleUser) != nil) {
            uploadMyFile()
        }
    }
    
    @IBAction func sendToFirestore(_ sender: Any) {
        print("Sent to Firestore.")
    }
    
    func uploadMyFile() {
        if let fileURL = Bundle.main.url(
            forResource: "my-image", withExtension: ".png") {
            uploadFile(
                name: "my-image.png",
                fileURL: fileURL,
                mimeType: "image/png",
                service: googleDriveService)
            let ac = UIAlertController(title: "Exito!", message: "Tu imagen ha sido enviada a Drive.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        else {
            print("No file found.")
        }
    }
    
}

extension enviarFotosVC: GIDSignInDelegate, GIDSignInUIDelegate {
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            // Include authorization headers/values with each Drive API request.
            self.googleDriveService.authorizer = user.authentication.fetcherAuthorizer()
            self.googleUser = user
        } else {
            self.googleDriveService.authorizer = nil
            self.googleUser = nil
        }
    }
}

func uploadFile(
    name: String,
    fileURL: URL,
    mimeType: String,
    service: GTLRDriveService) {
    
    let file = GTLRDrive_File()
    file.name = name
    
    // Optionally, GTLRUploadParameters can also be created with a Data object.
    let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
    
    let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
    
    service.executeQuery(query) { (_, result, error) in
        guard error == nil else {
            fatalError(error!.localizedDescription)
        }
        print("Successfully sent \(name) to Drive.")
    }
}
