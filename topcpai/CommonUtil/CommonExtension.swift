//
//  MyExtension.swift
//  SmartPay
//
//  Created by admin on 11/19/2558 BE.
//  Copyright © 2558 Ruttanachai Auitragool. All rights reserved.
//

import UIKit
import Photos
import MBProgressHUD

extension UILabel {
        // Returns an UIFont that fits the new label's height.
    func fontToFitHeight() -> UIFont {
        var minFontSize: CGFloat = 0 // CGFloat 18
        var maxFontSize: CGFloat = 100     // CGFloat 67
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        while minFontSize <= maxFontSize {
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            if let labelText: NSString = text as NSString? {
                let labelHeight = frame.size.height
                let testStringHeight = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: font.withSize(fontSizeAverage)]
                    ).height
                textAndLabelHeightDiff = labelHeight - testStringHeight
                if fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize {
                    if textAndLabelHeightDiff < 0 {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                if textAndLabelHeightDiff < 0 {
                    maxFontSize = fontSizeAverage - 1
                } else if textAndLabelHeightDiff > 0 {
                    minFontSize = fontSizeAverage + 1
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
    }

}

extension Bundle {
    var releaseVersionNumber: String {
        if let releaseVersion = self.infoDictionary?["CFBundleShortVersionString"] as? String {
            return releaseVersion
        } else {
            return "Cannot get version number"
        }
    }
    var buildVersionNumber: String {
        if let buildVersion = self.infoDictionary?["CFBundleVersion"] as? String {
            return buildVersion
        } else {
            return "Cannot get build number"
        }
    }
}

extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}

extension Double {
    var isInteger: Bool {return rint(self) == self}
}

extension Date {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        // Declare Variables
        var isGreater = false
        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        // Return Result
        return isGreater
    }
    func isLessThanDate(dateToCompare: Date) -> Bool {
        // Declare Variables
        var isLess = false
        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        // Return Result
        return isLess
    }

    func equalToDate(dateToCompare: Date) -> Bool {
        // Declare Variables
        var isEqualTo = false
        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        return isEqualTo
    }
    func addDays(daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        return dateWithDaysAdded
    }
    func addHours(hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        return dateWithHoursAdded
    }
    func addMinutes(minutesToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(minutesToAdd) * 60
        let dateWithMinutesAdded: Date = self.addingTimeInterval(secondsInHours)
        return dateWithMinutesAdded
    }
    func addSeconds(secondsToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(secondsToAdd)
        let dateWithSecondsAdded: Date = self.addingTimeInterval(secondsInHours)
        return dateWithSecondsAdded
    }
    func yesterDay() -> Date {
        let today: Date = self
        let daysToAdd: Int = -1
        // Set up date components
        var dateComponents: DateComponents = DateComponents()
        dateComponents.day = daysToAdd
        // Create a calendar
        let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let yesterDayDate: Date = gregorianCalendar.date(byAdding: dateComponents, to: today, options: NSCalendar.Options(rawValue: 0))!
        return yesterDayDate
    }
    func previousDay(daysToAdd: Int) -> Date {
        let today: Date = self
        // Set up date components
        var dateComponents: DateComponents = DateComponents()
        dateComponents.day = daysToAdd
        // Create a calendar
        let gregorianCalendar: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let yesterDayDate: Date = gregorianCalendar.date(byAdding: dateComponents, to: today, options: NSCalendar.Options(rawValue: 0))!
        return yesterDayDate
    }
}

extension PHAssetCollection {
    var photosCount: Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
        return result.count
    }
}

public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let pvc = vc?.presentedViewController {
            return UIWindow.getVisibleViewControllerFrom(pvc)
        } else if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            return vc
        }
    }
}
/*
public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}*/
/*
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}*/

extension MBProgressHUD {
}
