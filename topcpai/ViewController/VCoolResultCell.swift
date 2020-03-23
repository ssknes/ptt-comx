//
//  VCoolResultCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 27/5/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class VCoolResultCell: UITableViewCell {
    @IBOutlet weak var vwText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setView(Text: String) {
        var str = Text
        if str == "-" {
            str = ""
        }
        let htmlString = (str.fromBase64())!
        do {
            let atbString = try NSAttributedString.init(data: (htmlString.data(using: .unicode))!,
                                                        options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                                                        documentAttributes: nil)
            vwText.attributedText = atbString
        } catch {
            vwText.text = htmlString
        }
    }
}
