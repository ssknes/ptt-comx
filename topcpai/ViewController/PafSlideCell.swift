//
//  PafSlideCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 30/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class PafSlideCell: UITableViewCell {
    @IBOutlet weak var HeaderTableView: UITableView!
    @IBOutlet weak var DataCollectionView: UICollectionView!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var vwLabel: UIView!
    @IBOutlet weak var conViewLabel: NSLayoutConstraint!
    
    var Headers = [String]()
    var Datas = [[String]]()
    var CellHeight = [CGFloat]()
    
    
    @IBAction func onBtnLeft(_ sender: UIButton) {
        
    }
    @IBAction func onBtnRight(_ sender: UIButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        DataCollectionView.isPagingEnabled = true
        DataCollectionView.allowsSelection = false
        HeaderTableView.register(UINib.init(nibName: "SlideHeaderCell", bundle: nil), forCellReuseIdentifier: "cell")
        DataCollectionView.register(UINib.init(nibName: "SlideDataCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func setCell(Type: String, Headers: [String], Datas: [[String]], CellHeight: [CGFloat]) {
        conViewLabel.constant = 40
        vwLabel.isHidden = false
        self.Headers = Headers
        self.Datas = Datas
        self.CellHeight = CellHeight
        if Datas.count > 0 {
            lblCounter.text = "\(1) / \(Datas.count)"
        } else {
            lblCounter.text = "\(0) / \(Datas.count)"
        }
        HeaderTableView.reloadData()
        DataCollectionView.reloadData()
    }
}

extension PafSlideCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Headers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SlideHeaderCell
        cell.setText(header: Headers[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeight[indexPath.row]
    }
}

extension PafSlideCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Headers.count * Datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SlideDataCell
        let col = indexPath.item % Headers.count
        let row = (indexPath.item - col) / Headers.count
        
        cell.setText(Data: Datas[row][col])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = CellHeight[indexPath.item % CellHeight.count]
        return CGSize.init(width: collectionView.frame.size.width, height: h)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == DataCollectionView {
            let temp: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width) + 1
            lblCounter.text = "\(temp) / \(Datas.count)"
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == DataCollectionView {
            let temp: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width) + 1
            lblCounter.text = "\(temp) / \(Datas.count)"
        }
    }
}
