//
//  topcpaiTests.swift
//  topcpaiTests
//
//  Created by NB590194 on 12/1/16.
//  Copyright © 2016 PTT ICT Solutions. All rights reserved.
//

import XCTest
import Photos

class topcpaiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        MyUtilities.checkPhotoLibraryPermission()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEncryptDecrypt(){
        let plainText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
        let cipherText = Encryptor.encryptWithRSA(plain: plainText)
        print("Plain : "+plainText)
        print("Cipher : "+cipherText)
        XCTAssertNotEqual(plainText, cipherText)
        
        let decryptedText = Encryptor.decryptWithRSA(cipherText: cipherText)
        print("Decrypted : "+decryptedText)
        
        XCTAssertEqual(plainText, decryptedText)
    }
    
    func testThaiId(){
        let thaiId = "1459900349347"
        XCTAssertTrue(MyUtilities.validThaiId(thaiId: thaiId), "Error: incorrect Thai ID")
        let fakeThaiId = "1111111111001"
        XCTAssertFalse(MyUtilities.validThaiId(thaiId: fakeThaiId))
    }
    
    func testEmail(){
        let email = "ruttanachai.a@pttict.com"
        XCTAssertTrue(MyUtilities.validEmail(email: email), "Error: incorrect email")
        let fakeEmail = "ruttanachai.a"
        XCTAssertFalse(MyUtilities.validEmail(email: fakeEmail))
    }
    
    func testMobile(){
        let mobile = "0800000001"
        XCTAssertTrue(MyUtilities.validMobile(mobile: mobile), "Error: incorrect mobile phone number")
        let fakeMobile = "1667"
        XCTAssertFalse(MyUtilities.validMobile(mobile: fakeMobile))
    }
    
    func testName(){
        let name = "Ruttanachai"
        XCTAssertTrue(MyUtilities.validRealName(name: name, maxLength: 50), "Error: incorrect name")
        let fakeName = "00a55"
        XCTAssertFalse(MyUtilities.validRealName(name: fakeName, maxLength: 50))
    }
    
//    func testScreenshot(){
//        let smartCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
//        smartCollections.enumerateObjects({ object, index, stop in
//            let collection = object
//            print(collection.photosCount)
//        })
//        MyUtilities.saveScreenShot()
//    }
}
