//
//  UIImageViewExtension.swift
//  SmartPay
//
//  Created by admin on 10/22/2558 BE.
//  Copyright © 2558 Ruttanachai Auitragool. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView: URLSessionDelegate {

    func downloadedFrom(link: String) {
        contentMode = UIView.ContentMode.scaleAspectFit
        if let url = URL(string: link) {
            var request = URLRequest(url: url)

            log.debug("Loading \(url)")
            request.httpMethod = "GET"

            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { () -> Void in self.image = UIImage(data: data)}

            }
            task.resume()
        }
    }

    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode) {
        contentMode = mode
        if let url = URL(string: link) {
            var request = URLRequest(url: url)

            log.debug("Loading \(url)")
            request.httpMethod = "GET"

            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { () -> Void in self.image = UIImage(data: data)}

            }
            task.resume()
        }
    }


    func downloadedFrom(link: String, callback: ((_ image: UIImage) -> Void)?) {
        contentMode = UIView.ContentMode.scaleAspectFit
        if let url = URL(string: link) {
            var request = URLRequest(url: url)

            log.debug("Loading \(url)")
            request.httpMethod = "GET"

            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { () -> Void in self.image = UIImage(data: data)}

                callback?(UIImage(data: data)!)
            }

            task.resume()
        }
    }

    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode, callback: ((_ image: UIImage) -> Void)?) {
        contentMode = mode
        if let url = URL(string: link) {
            var request = URLRequest(url: url)

            log.debug("Loading \(url)")
            request.httpMethod = "GET"

            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                guard let data = data, error == nil else { return }
               DispatchQueue.main.async { () -> Void in self.image = UIImage(data: data)}

                callback?(UIImage(data: data)!)
            }

            task.resume()
        }
    }
}
