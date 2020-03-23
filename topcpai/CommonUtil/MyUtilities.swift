//
//  MyUtilities.swift
//  PocketPay
//
import Photos
import XCGLogger

public class MyUtilities {
    
    // MARK: Validator
    static func validThaiId(thaiId: String) -> Bool {
        if thaiId.length != 13 {
            return false
        }
        var sum = 0
        for i in 0..<(thaiId.length - 1) {
            let value = Int(String(thaiId[thaiId.index(thaiId.startIndex, offsetBy: i)]))
            let digit = thaiId.length - i
            if value == nil {
                return false
            }
            sum += value! * digit
        }
        let checkDigit = (11 - (sum % 11)) % 10
        let lastChar = thaiId[thaiId.index(before: thaiId.endIndex)]
        return String(checkDigit) == String(lastChar)
    }
    
    static func validPassword(pass: String, confirmPass: String) -> MyError {
        if pass != confirmPass {
            return MyError(code: "-1", message: "Password not match")
        }
        
        let pattern = "(?=^.{8,20}$)(?=.*[0-9])(?=.*[\\\\(),.<>~/+=\\-!|`@#$%^&*]+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"
        let options: NSRegularExpression.Options = NSRegularExpression.Options.dotMatchesLineSeparators
        
        var regex = try? NSRegularExpression(pattern: pattern, options: options)
        
        var strongMatched = 0
        
        if let regex = regex {
            strongMatched = regex.numberOfMatches(in: pass, options: [], range:  NSRange(location: 0, length: pass.length))
        } else {
            return MyError(code: "-1", message: "Invalid condition")
        }
        
        if strongMatched>0 {
            // password is strong
            return MyError(code: "1", message: "Password is strong")
        } else {
            // let's check whether weak password or not
            let pattern = "(?=^.{8,20}$)(?=.*[0-9])(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"
            let options: NSRegularExpression.Options = NSRegularExpression.Options.dotMatchesLineSeparators
            
            regex = try? NSRegularExpression(pattern: pattern, options: options)
            
            var weakMatched = 0
            if let regex = regex {
                weakMatched = regex.numberOfMatches(in: pass, options: [], range: NSRange(location: 0, length: pass.length))
            }
            
            if weakMatched>0 {
                // password is weak, but also ok
                return MyError(code: "2", message: "Password is weak")
            } else {
                // this password cannot be used
                return MyError(code: "-1", message: "Password cannot be used")
            }
        }
    }
    
    static func validRealName(name: String, maxLength: Int) -> Bool {
        let patternStr  = "^[^'?!@?$%^&*_+\\\\/<>\\{\\}?:;|=.,0-9()\\[\\]]{1,"+String(maxLength)+"}$"
        
        let options: NSRegularExpression.Options = NSRegularExpression.Options.dotMatchesLineSeparators
        let regex = try? NSRegularExpression(pattern: patternStr, options: options)
        var matched = 0
        
        if let regex = regex {
            matched = regex.numberOfMatches(in: name, options: [], range: NSRange(location: 0, length: name.length))
        }
        return matched > 0
    }
    
    static func validMobile(mobile: String) -> Bool {
        if mobile.length != 10 {
            return false
        }
        let pattern = "0[0-9]{9}"
        let range = mobile.range(of: pattern, options: .regularExpression)
        return range != nil ? true : false
    }
    
    static func validEmail(email: String) -> Bool {
        let pattern = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let range = email.range(of: pattern, options: .regularExpression)
        return range != nil ? true : false
    }
    
    
    // MARK: Dialog
    static func showErrorAlert(message: String, viewController: UIViewController) {
        self.showErrorAlert(message: message, viewController: viewController, completion: nil)
    }
    
    static func showErrorAlert(message: String, viewController: UIViewController, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            if !message.isEmpty {
                let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                    (action) in
                    if let ok = completion {
                        ok()
                    }
                })
                alert.addAction(okAction)
                alert.modalPresentationStyle = .overFullScreen
                //alert.show()
                viewController.present(alert, animated: true, completion: nil)
            } else {
                if let ok = completion {
                    ok()
                }
            }
        }
    }
    
    public class func showAckAlert(title: String, message: String, viewController: UIViewController) {
        self.showAckAlert(title: title, message: message, viewController: viewController, completion: nil)
    }
    
    
    
    public class func showAckAlert(title: String, message: String, viewController: UIViewController, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action) in
                if let ok = completion {
                    ok()
                }
            })
            alert.addAction(okAction)
            alert.modalPresentationStyle = .overFullScreen
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showAckAlert(title: String, message: String, okText: String, okStyle: UIAlertAction.Style, viewController: UIViewController, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okText, style: okStyle, handler: {
                (action) in
                if let ok = completion {
                    ok()
                }
            })
            alert.addAction(okAction)
            alert.modalPresentationStyle = .overFullScreen
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showConfirm(title: String, message: String, viewController: UIViewController, okText: String, okStyle: UIAlertAction.Style, okAction: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okText, style: okStyle, handler: {
                (action) in
                if let ok = okAction {
                    ok()
                }
            })
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .overFullScreen
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showConfirm(title: String, message: String, viewController: UIViewController, okText: String, okStyle: UIAlertAction.Style, cancelText: String, cancelStyle: UIAlertAction.Style, okAction: (() -> Void)?, cancelAction: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okText, style: okStyle, handler: {
                (action) in
                if let aOkAction = okAction {
                    aOkAction()
                }
            })
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: cancelText, style: cancelStyle, handler: {
                (action) in
                if let aCancelAction = cancelAction {
                    aCancelAction()
                }
            })
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .overFullScreen
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showAckwithAction(title: String, message: String, viewController: UIViewController, okAction: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action) in
                if let ok = okAction {
                    ok()
                }
            })
            alert.addAction(okAction)
            alert.modalPresentationStyle = .overFullScreen
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showTextbox(title: String, message: String, viewController: UIViewController, okText: String, okStyle: UIAlertAction.Style, okAction: ((_ message: String) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            let okAction = UIAlertAction(title: okText, style: okStyle, handler: {
                (action) in
                if let ok = okAction {
                    ok((alert.textFields?[0].text)!)
                }
            })
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .overFullScreen
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showTextboxApprove(title: String, message: String, viewController: UIViewController, okText: String, okStyle: UIAlertAction.Style, okAction: ((_ message: String) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ///alert.addTextField(configurationHandler: nil)
            let okAction = UIAlertAction(title: okText, style: okStyle, handler: {
                (action) in
                if let ok = okAction {
                    ok((alert.textFields?[0].text)!)
                }
            })
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .overFullScreen
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: HUD
    static func showSuccessHUDwithMessage(msg: String, onView view: UIView) {
        DispatchQueue.main.async {
            /*let successHud = MBProgressHUD(view: view)
            view.addSubview(successHud)
            
            successHud.mode = .customView
            successHud.customView = UIImageView(image: UIImage(named: "correct"))
            successHud.label.text = msg
            successHud.show(animated: true)
            successHud.hide(animated: true, afterDelay: 1.0)*/
        }
    }
    
    static func showFailureHUDwithMessage(message: String, onView view: UIView) {
        DispatchQueue.main.async {
           /* let failureHud = MBProgressHUD(view: view)
            view.addSubview(failureHud)
            
            failureHud.label.text = message
            failureHud.mode = .customView
            failureHud.customView = UIImageView(image: UIImage(named: "wrong"))
            failureHud.show(animated: true)
            failureHud.hide(animated: true, afterDelay: 1.0)*/
        }
    }
    
    static func showFailureHUDwithTitle(title: String, message: String, onView view: UIView) {
        DispatchQueue.main.async {
            /*let failureHud = MBProgressHUD(view: view)
            view.addSubview(failureHud)
            
            failureHud.label.text = title
            failureHud.detailsLabel.text = message
            failureHud.mode = .customView
            failureHud.customView = UIImageView(image: UIImage(named: "wrong"))
            failureHud.show(animated: true)
            failureHud.hide(animated: true, afterDelay: 3.0)*/
        }
    }
    
    static func downloadImage(urlString: String) -> UIImage? {
        if let url = URL(string: urlString) {
            if let data = NSData(contentsOf: url) {
                return UIImage(data: data as Data)
            }
        }
        return nil
    }
    
    static func downloadImageAsync(urlString: String, callback: ((_ image: UIImage) -> Void)?) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            
            print("Loading \(url)")
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                guard let data = data, error == nil else { return }
                callback?(UIImage(data: data)!)
            }
            
            task.resume()
        }
    }
    
    // MARK: Colours functions
    class func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor { // tailor:disable
        let color: UIColor = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(alpha))
        return color
    }
    
    class func RGBColor(hexColor: NSString) -> UIColor { // tailor:disable
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        let hexColorCode = hexColor as String
        
        if hexColorCode.hasPrefix("#") {
            
            let index   = hexColorCode.index(hexColorCode.startIndex, offsetBy: 1)
            let hex     = String(hexColorCode[index...])   //hexColorCode.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexInt64(&hexValue) {
                if hex.length == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if hex.length == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid hex code string, length should be 7 or 9")
                }
            } else {
                print("scan hex error")
            }
        }
        
        let color: UIColor =  UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: alpha)
        return color
    }
    
    static func convertStringToDictionary(text: String) -> [String: AnyObject] {
        var result = [String: AnyObject]()
        if !text.isEmpty {
            if let data = text.data(using: String.Encoding.utf8) {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                        result = dict
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        return result
    }
    
    static func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    static func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("Photo library authorized")
        case .denied, .restricted:
            print("Photo library access denied")
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { (status) -> Void in
                switch status {
                case .authorized:
                    print("Photo library authorized")
                case .denied, .restricted:
                    print("Photo library access denied")
                case .notDetermined:
                    print("Photo library access not specify")
                @unknown default:
                    break
                }
            }
        @unknown default:
            break
        }
    }
    
    static func saveScreenShot() {
        MyUtilities.checkPhotoLibraryPermission()
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
    }
    /*
    static func createLocalNotification(title: String, body: String) {
        // create a corresponding local notification
        let notification = UILocalNotification()
        
        if #available(iOS 8.2, *) {
            notification.alertTitle = title
        }
        notification.alertBody = body
        notification.alertAction = "open"
        notification.fireDate = Date()
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }*/
    /*
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }*/
}
