//
//  CrudeOSlideCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/7/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CrudeOSlideCell: UITableViewCell {
    @IBOutlet weak var DataCollectionView: UICollectionView!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var vwLabel: UIView!
    @IBOutlet weak var conViewLabel: NSLayoutConstraint!
    
    var Headers = [String]()
    var Datas = [[String]]()
    var CellHeight = [CGFloat]()
    var allHeight: CGFloat = 0
    
    @IBAction func onBtnLeft(_ sender: UIButton) {
        
    }
    @IBAction func onBtnRight(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        DataCollectionView.isPagingEnabled = true
        DataCollectionView.allowsSelection = false
        DataCollectionView.register(UINib.init(nibName: "CrudeOSlideItem", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func setCell(Headers: [String], Datas: [[String]], CellHeight: [CGFloat]) {
        if Datas.count == 0 {
            vwLabel.isHidden = true
            conViewLabel.constant = 0
        } else {
            conViewLabel.constant = 40
            vwLabel.isHidden = false
        }
        self.Headers = Headers
        self.Datas = Datas
        self.CellHeight = CellHeight
        self.allHeight = 0
        for item in CellHeight {
            allHeight += item
        }
        if Datas.count > 0 {
            lblCounter.text = "\(1) / \(Datas.count)"
        } else {
            lblCounter.text = "\(0) / \(Datas.count)"
        }
        DataCollectionView.reloadData()
    }
}

extension CrudeOSlideCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return Headers.count * Datas.count
        return Datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CrudeOSlideItem
        cell.setCell(Headers: Headers, Datas: Datas[indexPath.item], CellHeight: CellHeight)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: self.allHeight)
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
