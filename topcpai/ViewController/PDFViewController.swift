//
//  PDFViewController.swift
//  topcpai
//
//  Created by Piyanant Srisirinant on 12/17/2559 BE.
//  Copyright © 2559 PTT ICT Solutions. All rights reserved.
//

import UIKit
import CryptoSwift

class PDFViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var pdfView: UIWebView!
    var url = String()
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkConnection()
    }
    
    func checkConnection(){
        if !APIManager.shareInstance.connectedToNetwork(){
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: self.checkConnection)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfView.delegate = self
        if self.url.range(of: "/") == nil {
            self.url = "\(GlobalVar.sharedInstance.appMode.getUrl())/Web/Report/TmpFileEnc/\(self.url)"
        }
 
        // Do any additional setup after loading the view.
        let progressHUD = ProgressHUD(text: "Loading File...")
        self.view.addSubview(progressHUD)
        APIManager.shareInstance.getPDFFileFromURL(url: url, callback: { (success, err, data) in
            progressHUD.removeFromSuperview()
            if success {
                do {
                    // write until all is written
                    func writeTo(stream: OutputStream, bytes: Array<UInt8>) {
                        var writtenCount = 0
                        while stream.hasSpaceAvailable && writtenCount < bytes.count {
                            writtenCount += stream.write(bytes, maxLength: bytes.count)
                        }
                    }
                    
                    let password: Array<UInt8> = ("CPAI2TOPSI20162".data(using: .utf8)?.bytes)!
                    let salt: Array<UInt8> = [0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76]
                    
                    let pdb = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 1000, keyLength: 48, variant: .sha1).calculate()
                    let key = Data(_: pdb[0...31]).bytes
                    let iv = Data(_: pdb[32...47]).bytes
                    let aes = try AES(key: key, iv: iv)
                    var decryptor = aes.makeDecryptor()
                    
                    // prepare streams
                    let inputStream = InputStream(data: data)
                    let outputStream = OutputStream(toMemory: ())
                    inputStream.open()
                    outputStream.open()
                    
                    var buffer = Array<UInt8>(repeating: 0, count: 2)
                    
                    // encrypt input stream data and write encrypted result to output stream
                    while (inputStream.hasBytesAvailable) {
                        let readCount = inputStream.read(&buffer, maxLength: buffer.count)
                        if (readCount > 0) {
                            try decryptor.update(withBytes: buffer[0..<readCount]) { (bytes) in
                                writeTo(stream: outputStream, bytes: bytes)
                            }
                        }
                    }
                    
                    // finalize encryption
                    try decryptor.finish { (bytes) in
                        writeTo(stream: outputStream, bytes: bytes)
                    }
                    
                    // print result
                    if let ciphertext = outputStream.property(forKey: Stream.PropertyKey(rawValue: Stream.PropertyKey.dataWrittenToMemoryStreamKey.rawValue)) as? Data {
                        //print("Decrypted stream: \(String(data: ciphertext, encoding: .utf8))")
                        let url = NSURL.init(string: "")?.absoluteURL
                        self.pdfView.load(ciphertext, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: url!)
                    }
                    
                } catch {
                    print(error)
                }
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.setContentOffset(CGPoint.init(x: 0, y: -60), animated: false)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Error = \(error.localizedDescription)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
