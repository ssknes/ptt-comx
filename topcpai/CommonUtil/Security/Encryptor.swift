//
//  Encryptor.swift
//  ICTPocketPay
//
import UIKit
import AEXML

class Encryptor {
    
    static let maxDataLength = 53
    static let PLAINTEXT_BLOCK = 17
    static let CIPHERTEXT_BLOCK = 88
    
    static func encryptWithRSA(plain: String) -> String {
        do {
            let berBase64 = GlobalVar.sharedInstance.appMode.getPublicKey()
            var encryptedDataText = ""
            
            let in_len = plain.length;
            let n_block = in_len / PLAINTEXT_BLOCK;
            let n_block2 = in_len % PLAINTEXT_BLOCK;
            var icount = 0;
            for _ in 0..<n_block {
                let start = plain.index(plain.startIndex, offsetBy: icount)
                let end = plain.index(plain.startIndex, offsetBy: icount + PLAINTEXT_BLOCK)
                let pl = String(plain[start..<end])
                let encryptedData = try RSAUtils.encryptWithRSAPublicKey(data: pl.data(using: String.Encoding.utf8)!, pubkeyBase64: berBase64)!
                encryptedDataText += encryptedData.base64EncodedString(options: NSData.Base64EncodingOptions())
                icount += PLAINTEXT_BLOCK;
            }
            if (n_block2 > 0)
            {
                let start = plain.index(plain.startIndex, offsetBy: icount)
                let end = plain.index(plain.startIndex, offsetBy: icount + n_block2)
                let pl = String(plain[start..<end])
                let encryptedData = try RSAUtils.encryptWithRSAPublicKey(data: pl.data(using: String.Encoding.utf8)!, pubkeyBase64: berBase64)!
                encryptedDataText += encryptedData.base64EncodedString(options: NSData.Base64EncodingOptions())
            }
            return encryptedDataText
        } catch let error as NSError {
            print(error)
            return ""
        }

    }
    
    static func stripKeyHeader(key: String) -> String {
        let rawLines = key.components(separatedBy: "\n")
        var lines = [String]()
        
        for line in rawLines {
            if line == "-----BEGIN RSA PRIVATE KEY-----" ||
                line == "-----END RSA PRIVATE KEY-----"   ||
                line == "-----BEGIN PUBLIC KEY-----" ||
                line == "-----END PUBLIC KEY-----"   ||
                line == "" {
                continue
            }
            lines.append(line)
        }
        
        if lines.count == 0 {
            print("Couldn't get data from PEM key: no data available after stripping headers")
            return ""
        }
        
        let base64EncodedKey = lines.joined(separator: "")
        return base64EncodedKey
    }
    
    static func decryptWithRSA(cipherText: String) -> String {
        do {
            let berBase64 = GlobalVar.sharedInstance.appMode.getPrivateKey()
            let in_len = cipherText.length
            let n_block = in_len / CIPHERTEXT_BLOCK
            var icount = 0
            var decryptedString = ""
            for _ in 0..<n_block {
                let start = cipherText.index(cipherText.startIndex, offsetBy: icount)
                let end = cipherText.index(cipherText.startIndex, offsetBy: icount + CIPHERTEXT_BLOCK)
                let pl = String(cipherText[start..<end])
                let encryptedData = Data(base64Encoded: pl, options: NSData.Base64DecodingOptions())
                let decryptedData = try RSAUtils.decryptWithRSAPrivateKey(encryptedData: encryptedData!, privkeyBase64: berBase64)
                decryptedString += String(data: decryptedData!, encoding: String.Encoding.utf8)!
                icount += CIPHERTEXT_BLOCK
            }
            return decryptedString
        } catch let error as NSError {
            print(error)
            return ""
        }
    }
}
