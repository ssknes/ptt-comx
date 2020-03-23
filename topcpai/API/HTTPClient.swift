//
//  ICTHTTPClient.swift
//  ICTPocketPay
//

import Foundation

class HTTPClient: NSObject, URLSessionDelegate {
    var domain: String

    init(domain domainString: String) {

        domain = domainString
        super.init()

        URLSession.shared.configuration.timeoutIntervalForRequest = MyConfigs.serviceTimeout
    }

    //    func get(path: String, body: NSData, callback: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
    //        let request = NSMutableURLRequest(URL: NSURL( string: domain + path )!)
    //        let session = NSURLSession.sharedSession()
    //        let task = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
    //
    //            callback?(data, response, error)
    //
    //        }
    //
    //        task.resume() //send request
    //    }
    //
    //    func post(path: String, body: NSData, callback: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
    //        let request = NSMutableURLRequest( URL: NSURL(string: domain + path)!)
    //        let session = NSURLSession.sharedSession()
    //
    //        request.HTTPMethod = "POST"
    //        request.HTTPBody = body
    //        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
    //        request.addValue("application/xml", forHTTPHeaderField: "Accept")
    //
    //
    //        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
    //
    //            //parse XML
    //            //decode URL Encode and re-encode with UTF8
    //            if let theData = data{
    //                let string = NSString(data: theData, encoding: NSUTF8StringEncoding)?.stringByRemovingPercentEncoding!
    //                let decodedData = string?.dataUsingEncoding(NSUTF8StringEncoding)
    //                if decodedData == nil {
    //                    log.error("Failed to decode data")
    //                    return
    //                }
    //            }
    //            callback?(data, response, error)
    //
    //        }
    //        task.resume()
    //    }

    func postAndDecodeData(path: String, body: NSData, callback: ((NSData?, URLResponse?, NSError?) -> Void)?) {
        var request = URLRequest(url: URL(string: domain + path)!)
        request.httpMethod = "POST"
        request.httpBody = body as Data
        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        //request.addValue("application/xml", forHTTPHeaderField: "Accept")
        request.timeoutInterval = MyConfigs.serviceTimeout

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            // Decode URL Encode and re-encode with UTF8
            if let theData = data {
                let string = NSString(data: theData, encoding: String.Encoding.utf8.rawValue)
//                let attributedOptions : [String: AnyObject] = [
//                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
//                    NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as AnyObject
//                ]
//                let decodedString = string?.decodeEntity(options: attributedOptions)
                var decodedData = NSData()
                if let string = string {
                    decodedData = string.data(using: String.Encoding.utf8.rawValue) as NSData? ?? NSData()
                }
                callback?(decodedData, response, error as NSError?)
            } else {
                callback?(NSData(), response, error as NSError?)
            }
        }
        task.resume()
    }
    
    func getFileFromURL(url: String, type: String, callback: ((Data?, URLResponse?, NSError?) -> Void)?) {
        let urlr = url.replacingOccurrences(of: " ", with: "%20")
        var request = URLRequest(url: URL(string: urlr)!)
        request.httpMethod = "GET"
        request.timeoutInterval = MyConfigs.serviceTimeout
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            // Decode URL Encode and re-encode with UTF8
            if let theData = data {
                if type != "" {
                    if let httpResponse = response as? HTTPURLResponse {
                        if let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
                            if contentType != type {
                                callback?(Data(), response, error as NSError?)
                            }
                        }
                    }
                }
                
                let decodedData = theData as Data
                callback?(decodedData, response, error as NSError?)
            } else {
                callback?(Data(), response, error as NSError?)
            }

        }
        task.resume()
    }

    /*    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
    var trusted = false;

    var localTrust: SecTrust?
    let serverTrust = challenge.protectionSpace.serverTrust!
    let serverPublicKey = SecTrustCopyPublicKey(serverTrust)
    let certificateData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource(GlobalVar.sharedInstance.certificateName, ofType: "cer")!)
    let localCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, certificateData!)
    let policy = SecPolicyCreateBasicX509()

    if SecTrustCreateWithCertificates(localCertificate!, policy, &localTrust) == errSecSuccess {
    let localTrustRef = localTrust!
    let localPublicKey = SecTrustCopyPublicKey(localTrustRef)!
    if (localPublicKey as AnyObject).isEqual(serverPublicKey as? AnyObject) {
    log.debug("trusted server")
    trusted = true;
    }
    }

    if (trusted){
    completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    else{
    log.debug("not trusted server")
    completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge,nil)
    }


    completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))

    }
    } */
}
