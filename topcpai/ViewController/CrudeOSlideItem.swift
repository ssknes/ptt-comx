//
//  CrudeOSlideItem.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/7/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CrudeOSlideItem: UICollectionViewCell {
    
    var Headers = [String]()
    var Datas = [String]()
    var CellHeight = [CGFloat]()
    
    @IBOutlet weak var mainTableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataHeaderCell", bundle: nil), forCellReuseIdentifier: "cellhead")
    }
    func setCell(Headers: [String], Datas: [String], CellHeight: [CGFloat]) {
        self.Headers = Headers
        self.Datas = Datas
        self.CellHeight = CellHeight
        mainTableView.reloadData()
    }
}

extension CrudeOSlideItem: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Headers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellhead") as! ListDataHeaderCell
            cell.setupView(header: Datas[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
        cell.setupView(header: Headers[indexPath.row], value: Datas[indexPath.row], bold: false)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight[indexPath.row]
    }
}
