//
//  Extension.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/3.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit




extension String {
    
    //將原始的url編碼為合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //將編碼後的url轉換回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

extension UIImage {
    
    static func compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage {
       
        var compression: CGFloat = 1
        
        guard var data = UIImageJPEGRepresentation(image, compression),
            data.count > maxLength else { return image }
    
        var max: CGFloat = 1
        var min: CGFloat = 0
        
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(image, compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        return UIImage(data: data)!
    }
    
}

//No use now .
//extension DetailsInfoViewController {
//    func sizeHeaderToFit() {
//        if let headerView = detailsInfoTableView.tableHeaderView {
//
//            headerView.setNeedsLayout()
//            headerView.layoutIfNeeded()
//
//            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
//            var frame = headerView.frame
//            frame.size.height = height
//            headerView.frame = frame
//
//            detailsInfoTableView.tableHeaderView = headerView
//        }
//    }
//
//    func sizeFooterToFit() {
//        if let footerView = detailsInfoTableView.tableFooterView {
//            footerView.setNeedsLayout()
//            footerView.layoutIfNeeded()
//
//            let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
//            var frame = footerView.frame
//            frame.size.height = height
//            footerView.frame = frame
//
//            detailsInfoTableView.tableFooterView = footerView
//        }
//    }
//}
extension UITabBarController {
    func hideTabBarAnimated(hide:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
                self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            } else {
                self.tabBar.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        })
    }
}
