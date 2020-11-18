//
//  llantasViewController.swift
//  AIT
//
//  Created by Terneros.
//

import UIKit
import AVFoundation
import Metal
import MetalPerformanceShaders
import MetalKit

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

class llantasViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var chatarraDirection: UIButton!
    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var layout: UIImageView!
    @IBOutlet weak var menu: UIView!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
               stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    // Variable que mostrará u ocultará el layout
    var cameraType: CameraTypes!
    var showGrid: Bool = false
    var direction: ChatarraDirection = .toRight
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        photoView.transform = photoView.transform.rotated(by: .pi * 1.5)
        let flag = (cameraType == CameraTypes.chatarra) ? true : false
        availabilityOfDirection(flag)
        setUIConstraints(UIDevice.current.orientation)
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
/*
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation = UIDevice.current.orientation
        setCameraOrientation(orientation)
    }
 */
            
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    /*
    private func setCameraOrientation(_ orientation: UIDeviceOrientation) {
        switch (orientation) {
        case .portrait:
            videoPreviewLayer.connection!.videoOrientation = .portrait            
            break

        case .landscapeLeft:
            videoPreviewLayer.connection!.videoOrientation = .landscapeLeft
            break

        case .landscapeRight:
            videoPreviewLayer.connection!.videoOrientation = .landscapeRight
            break

        default:
            videoPreviewLayer.connection!.videoOrientation = .portrait
            break
        }
        
        DispatchQueue.main.async {
            self.setUIConstraints(.portrait)
        }
    }
     */
    
    private func setUIConstraints(_ orientation: UIDeviceOrientation) {
        let screenWidth = CGFloat(UIScreen.main.bounds.width)
        let screenHeigth = CGFloat(UIScreen.main.bounds.height)
        
        previewView.translatesAutoresizingMaskIntoConstraints = false
        layout.translatesAutoresizingMaskIntoConstraints = false

        if cameraType == CameraTypes.chatarra {
            NSLayoutConstraint.activate([
                previewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                previewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                previewView.widthAnchor.constraint(equalToConstant: screenWidth),
                
                layout.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                layout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                layout.widthAnchor.constraint(equalToConstant: screenWidth),
            ])
        }
        else {
            NSLayoutConstraint.activate([
                previewView.trailingAnchor.constraint(equalTo: menu.leadingAnchor),
                previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                previewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                previewView.widthAnchor.constraint(equalToConstant: screenHeigth),
                
                layout.trailingAnchor.constraint(equalTo: menu.leadingAnchor),
                layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                layout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                layout.widthAnchor.constraint(equalToConstant: screenHeigth),
            ])
        }
        
        /*
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            if cameraType == CameraTypes.chatarra {
                NSLayoutConstraint.activate([
                    previewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    previewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    previewView.widthAnchor.constraint(equalToConstant: screenWidth),
                    
                    layout.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    layout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    layout.widthAnchor.constraint(equalToConstant: screenWidth),
                ])
            }
            else {
                NSLayoutConstraint.activate([
                    previewView.trailingAnchor.constraint(equalTo: menu.leadingAnchor),
                    previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    previewView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    previewView.widthAnchor.constraint(equalToConstant: screenHeigth),
                    
                    layout.trailingAnchor.constraint(equalTo: menu.leadingAnchor),
                    layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    layout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    layout.widthAnchor.constraint(equalToConstant: screenHeigth),
                ])
            }
        }
        else {
            if cameraType == CameraTypes.chatarra {
                NSLayoutConstraint.activate([
                    previewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    previewView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    previewView.heightAnchor.constraint(equalToConstant: screenHeigth),
                    
                    layout.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    layout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    layout.heightAnchor.constraint(equalToConstant: screenHeigth),
                ])
            }
            else {
                NSLayoutConstraint.activate([
                    previewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    previewView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    previewView.heightAnchor.constraint(equalToConstant: screenWidth),
                    
                    layout.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    layout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    layout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    layout.heightAnchor.constraint(equalToConstant: screenWidth),
                ])
            }
        }
         */
    }
        
    private func availabilityOfDirection(_ enabled: Bool) {
        chatarraDirection.isEnabled = enabled
        chatarraDirection.isHidden = !enabled
        
        if enabled {
            chatarraDirection.setImage(Images.toRight, for: .normal)
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
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        if cameraType == CameraTypes.llanta {
            captureSession.sessionPreset = .photo
        }
        
        //setCameraOrientation(UIDevice.current.orientation)
        videoPreviewLayer.connection?.videoOrientation = .landscapeRight
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
        
        let newImage = UIImage(data: imageData)
        let image = newImage!.rotate(radians: .pi * 1.5)
//        let newImage = image.rotate(radians: .pi/2)
//        image = image.rotate(radians: .pi/2)
        let sharpness = calcSharpness(img: image!)
        print(sharpness)
        if (sharpness > 1) {
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            photoView.image = image

        }
        else {
            let ac = UIAlertController(title: "Error", message: "La imagen esta borrosa. Por favor vuelva a intentarlo.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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
    
    @IBAction func tappedOnGrid(_ sender: Any) {
        print("tap on grid")
        if !showGrid {
            print("about to show grid")
            if cameraType == CameraTypes.llanta {
                layout.image = Images.llantasLayout
            }
            else if direction == .toRight {
                layout.image = Images.izqChatarraLayout
            }
            else {
                layout.image = Images.derChatarraLayout
            }
            
            gridButton.setImage(Images.hideGrid, for: .normal)
        }
        else {
            print("about to dismiss grid")
            layout.image = nil
            gridButton.setImage(Images.showGrid, for: .normal)
        }
        
        showGrid = !showGrid
    }
    
    @IBAction func tappedDirection(_ sender: Any) {
        print("tapped on direction")
        if direction == .toRight {
            chatarraDirection.setImage(Images.toLeft, for: .normal)
            direction = .toLeft
            
            if showGrid { layout.image = Images.derChatarraLayout }
        }
        else {
            chatarraDirection.setImage(Images.toRight, for: .normal)
            direction = .toRight
            
            if showGrid { layout.image = Images.izqChatarraLayout }
        }
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

func calcSharpness(img: UIImage) -> Int8 {
    let mtlDevice = MTLCreateSystemDefaultDevice()
    let mtlCommandQueue = mtlDevice?.makeCommandQueue()
    
    // Create a command buffer for the transformation pipeline
    let commandBuffer = mtlCommandQueue!.makeCommandBuffer()!
    // These are the two built-in shaders we will use
    let laplacian = MPSImageLaplacian(device: mtlDevice!)
    let meanAndVariance = MPSImageStatisticsMeanAndVariance(device: mtlDevice!)
    
    // Load the captured pixel buffer as a texture
    let textureLoader = MTKTextureLoader(device: mtlDevice!)
    let sourceTexture = try! textureLoader.newTexture(cgImage: img.cgImage!, options: nil)
    
    // Create the destination texture for the laplacian transformation
    let lapDesc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: sourceTexture.pixelFormat, width: sourceTexture.width, height: sourceTexture.height, mipmapped: false)
    lapDesc.usage = [.shaderWrite, .shaderRead]
    let lapTex = mtlDevice!.makeTexture(descriptor: lapDesc)!
    
    // Encode this as the first transformation to perform
    laplacian.encode(commandBuffer: commandBuffer, sourceTexture: sourceTexture, destinationTexture: lapTex)
    
    // Create the destination texture for storing the variance.
    let varianceTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: sourceTexture.pixelFormat, width: 2, height: 1, mipmapped: false)
    varianceTextureDescriptor.usage = [.shaderWrite, .shaderRead]
    let varianceTexture = mtlDevice!.makeTexture(descriptor: varianceTextureDescriptor)!
    
    // Encode this as the second transformation
    meanAndVariance.encode(commandBuffer: commandBuffer, sourceTexture: lapTex, destinationTexture: varianceTexture)
    
    // Run the command buffer on the GPU and wait for the results
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
    
    // The output will be just 2 pixels, one with the mean, the other the variance.
    var result = [Int8](repeatElement(0, count: 2))
    let region = MTLRegionMake2D(0, 0, 2, 1)
    varianceTexture.getBytes(&result, bytesPerRow: 1 * 2 * 4, from: region, mipmapLevel: 0)
    
    let variance = result.last!
    return variance
}
