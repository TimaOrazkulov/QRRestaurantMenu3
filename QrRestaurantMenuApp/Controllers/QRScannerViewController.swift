//
//  QRScannerViewController.swift
//  
//
//  Created by IOS-Developer on 31.05.2021.
//

import UIKit
import AVFoundation
import SnapKit

class QRScannerViewController: UIViewController {
    
    var video = AVCaptureVideoPreviewLayer()
    var session = AVCaptureSession()
    
    let qrImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8282918334, green: 0.798361063, blue: 0.7977046371, alpha: 1)
        setupConstraints()
        navigationController?.navigationBar.isHidden = true
        setupQR()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "QR"
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    private func setupQR() {
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch {
            print("Error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        view.bringSubviewToFront(qrImageView)
        session.startRunning()
    }
    
    private func transitionToMenu(){
        let menuVC = MenuViewController()
        menuVC.session = session
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    private func setupConstraints() {
        view.addSubview(qrImageView)
        
        NSLayoutConstraint.activate([
            qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 200),
            qrImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    session.stopRunning()
                    transitionToMenu()
                }
            }
        }
    }
}
