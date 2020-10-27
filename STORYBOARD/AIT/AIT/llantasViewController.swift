//
//  llantasViewController.swift
//  AIT
//
//  Created by Terneros.
//

import UIKit
import AVFoundation


class llantasViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
               stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    


    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    let orientation = UIDevice.current.orientation

    switch (orientation) {
    case .portrait:
        videoPreviewLayer.connection!.videoOrientation = .portrait
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.previewView.bounds
        }

    case .landscapeLeft:
        
        videoPreviewLayer.connection!.videoOrientation = .landscapeRight
    DispatchQueue.main.async {
        self.videoPreviewLayer.frame = self.previewView.bounds
    }

    case .landscapeRight:
        videoPreviewLayer.connection!.videoOrientation = .landscapeLeft
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.previewView.bounds
        }

    default:
        videoPreviewLayer.connection!.videoOrientation = .portrait
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.previewView.bounds
        }
        
    }
}
    

    func askPermission() {
        let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

        switch cameraPermissionStatus {
        case .authorized:
            print("Already Authorized")
        case .denied:
            print("denied")
            let alert = UIAlertController(title: "Disculpa" , message: "No se puede continuar sin darle acceso a la camera en ajustes.",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel,  handler: {_ in
                                        self.performSegue(withIdentifier: "main", sender: nil)})
            alert.addAction(action)
            present(alert, animated: true, completion:nil)
            
        case .restricted:
            print("restricted")
        default:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                (granted :Bool) -> Void in

                if granted == true {
                    // User granted
                    print("User granted")
     DispatchQueue.main.async(){
                //Do smth that you need in main thread
                }
                }
            });
        }
    }
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        photoView.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("No se pudo acceder a la camara trasera.")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
                
            }
        }
        catch let error  {
            askPermission()
            print("Error al iniciar la Camara:  \(error.localizedDescription)")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error)
            let alert = UIAlertController(title: "Disculpa" , message: "No se puede continuar sin darle acceso a la librería de fotos en ajustes.",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel,  handler: {_ in
                                        self.performSegue(withIdentifier: "main", sender: nil)})
            alert.addAction(action)
            present(alert, animated: true, completion:nil)
        }else {
            let ac = UIAlertController(title: "¡Listo!", message: "Tu imagen ha sido guardada en tu carrete", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}


