//
//  ExtensionMethods.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit
import SafariServices

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        } set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        } set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        } set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        } set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension NSDictionary {
    @objc func dictionaryByReplacingNullsWithBlanks() -> NSDictionary {
        let replaced:NSMutableDictionary = self.mutableCopy() as! NSMutableDictionary
        let blank = ""
        
        for strKey in self.keyEnumerator() {
            let object:AnyObject = self.object(forKey: strKey) as AnyObject
            if object is NSNull {
                replaced.setObject(blank, forKey: strKey as! NSCopying)
            } else if object is NSDictionary {
                replaced.setObject(object.dictionaryByReplacingNullsWithBlanks(), forKey: strKey as! NSCopying)
            } else if object is NSArray {
                replaced.setObject((object as! NSArray).arrayByReplacingNullsWithBlanks(), forKey: strKey as! NSCopying)
            }
        }
        
        return replaced.copy() as! NSDictionary
    }
}

extension NSArray {
    func arrayByReplacingNullsWithBlanks() -> NSArray {
        let replaced: NSMutableArray = self.mutableCopy() as! NSMutableArray
        let blank = ""
        
        for idx in 0..<replaced.count {
            let object = replaced.object(at: idx)
            if object is NSNull {
                replaced.replaceObject(at: idx, with: blank)
            } else if object is NSDictionary {
                replaced.replaceObject(at: idx, with: (object as! NSDictionary).dictionaryByReplacingNullsWithBlanks())
            } else if object is NSArray {
                replaced.replaceObject(at: idx, with: (object as! NSArray).arrayByReplacingNullsWithBlanks())
            }
        }
        
        return replaced.copy() as! NSArray
    }
}

extension String {
    func removeStartEndSpaces() -> String {
        return self.trimmingCharacters(in: charSet)
    }
    
    func removeMultipleCharacters() -> String {
        var finalString = self
        finalString = finalString.replacingOccurrences(of: "(", with: "")
        finalString = finalString.replacingOccurrences(of: ")", with: "")
        finalString = finalString.replacingOccurrences(of: "-", with: "")
        finalString = finalString.replacingOccurrences(of: " ", with: "")
        return finalString
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UIImageView {
    @IBInspectable
    var imageTintColor: UIColor? {
        get {
            return self.tintColor
        }
        set {
            let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = templateImage
            self.tintColor = newValue
        }
    }
}

extension UIImage {
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UINavigationController {
    func setupNavigation(isHidden: Bool = false, isTranslucent: Bool = false, backgroundColor: UIColor? = nil, titleColor: UIColor? = nil) {
        navigationBar.isHidden = isHidden
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            if isTranslucent {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithOpaqueBackground()
            }
            
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            appearance.backgroundColor = backgroundColor == nil ? .clear : backgroundColor
            appearance.titleTextAttributes = titleColor == nil ? [.foregroundColor: UIColor.white] : [.foregroundColor: titleColor!]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            let appearance = UINavigationBar.appearance()
            appearance.backgroundColor = backgroundColor == nil ? .clear : backgroundColor
            appearance.barTintColor = backgroundColor == nil ? .clear : backgroundColor
            appearance.tintColor = titleColor == nil ? .white : titleColor
            
            navigationBar.isTranslucent = isTranslucent
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
        
        navigationBar.layoutIfNeeded()
    }
}

extension UIViewController {
    func setupNavigationBar(isHidden: Bool = false, isTranslucent: Bool = false, backgroundColor: UIColor? = nil, titleColor: UIColor? = nil) {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.isHidden = isHidden
            
            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                if isTranslucent {
                    appearance.configureWithTransparentBackground()
                } else {
                    appearance.configureWithOpaqueBackground()
                }
                
                appearance.backgroundImage = UIImage()
                appearance.shadowImage = UIImage()
                appearance.backgroundColor = backgroundColor == nil ? .clear : backgroundColor
                appearance.titleTextAttributes = titleColor == nil ? [.foregroundColor: UIColor.white] : [.foregroundColor: titleColor!]
                navigationBar.tintColor = titleColor == nil ? .white : titleColor
                navigationBar.standardAppearance = appearance
                navigationBar.scrollEdgeAppearance = appearance
            } else {
                navigationBar.backgroundColor = backgroundColor == nil ? .clear : backgroundColor
                navigationBar.barTintColor = backgroundColor == nil ? .clear : backgroundColor
                navigationBar.tintColor = titleColor == nil ? .white : titleColor
                navigationBar.isTranslucent = isTranslucent
                navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                navigationBar.shadowImage = UIImage()
            }
            
            navigationBar.layoutIfNeeded()
        }
    }
    
    func showAlert(_ message: String, _ clickAction: Selector?) {
        DispatchQueue.main.async {
            AppDel.window?.endEditing(true)
            let normalAlert = UIAlertController(title: kAppName, message: message, preferredStyle: .alert)
            if clickAction == nil {
                normalAlert.addAction(UIAlertAction(title: kOk, style: .default, handler: nil))
            } else {
                normalAlert.addAction(UIAlertAction(title: kOk, style: .default, handler: { action in
                    self.perform(clickAction)
                }))
            }
            
            self.navigationController?.present(normalAlert, animated: true, completion: nil)
        }
    }
    
    func openWebURL(_ path: String) {
        self.view.endEditing(true)
        if let url = URL(string: path) {
            if UIApplication.shared.canOpenURL(url) {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        }
    }
}

extension UINavigationItem {
    func addLeftButtonWithImage(_ target: Any, action: Selector, buttonImage: UIImage?) {
        let leftButton = UIBarButtonItem(image: buttonImage, style: .plain, target: target, action: action)
        self.leftBarButtonItem = leftButton
    }
    
    func addLeftButtonWithTitle(_ target: Any, action: Selector, buttonTitle: String) {
        let leftButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: target, action: action)
        self.leftBarButtonItem = leftButton
    }
    
    func addRightButtonWithImage(_ target: Any, action: Selector, buttonImage: UIImage?) {
        let rightButton = UIBarButtonItem(image: buttonImage, style: .plain, target: target, action: action)
        self.rightBarButtonItem = rightButton
    }
    
    func addRightButtonWithTitle(_ target: Any, action: Selector, buttonTitle: String) {
        let rightButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: target, action: action)
        self.rightBarButtonItem = rightButton
    }
    
    func addCustomViewToLeft(view: UIView) {
        self.leftBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    func addCustomViewToRight(view: UIView) {
        self.rightBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    func addMutipleItemsToRight(items: [UIBarButtonItem]) {
        self.rightBarButtonItems = items
    }
}

extension UITextField {
    func setLeftIcon(_ icon: UIImage) {
        let padding = 10
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size))
        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconView.image = icon
        iconView.isUserInteractionEnabled = false
        iconView.contentMode = .scaleAspectFit
        outerView.addSubview(iconView)
        outerView.isUserInteractionEnabled = false
        
        leftView = outerView
        leftViewMode = .always
    }
    
    func setRightIcon(_ icon: UIImage) {
        let padding = 10
        let size = 12
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size))
        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconView.image = icon
        iconView.isUserInteractionEnabled = false
        iconView.contentMode = .scaleAspectFit
        outerView.addSubview(iconView)
        outerView.isUserInteractionEnabled = false
        
        rightView = outerView
        rightViewMode = .always
    }
    
    func setRightButton(normalImage: UIImage, selectedImage: UIImage, _ target: Any, action: Selector?) {
        
        let padding = 10
        let outerViewSize = 20
        let buttonSize = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: outerViewSize + padding, height: outerViewSize))
        let rightButton = UIButton.init(frame: CGRect.init(x: Int(outerView.frame.size.width - CGFloat(buttonSize)) - padding, y: 0, width: buttonSize, height: buttonSize))
        rightButton.setImage(normalImage, for: UIControl.State.normal)
        rightButton.setImage(selectedImage, for: UIControl.State.selected)
        rightButton.isSelected = false
        rightButton.contentMode = UIView.ContentMode.center
        
        if action != nil {
            rightButton.addTarget(target, action: action!, for: UIControl.Event.touchUpInside)
        }
        
        outerView.addSubview(rightButton)
        rightView = outerView
        rightViewMode = .always
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                   length: self.upperBound.encodedOffset -
                    self.lowerBound.encodedOffset)
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); color: \(self.textColor.toHexString()); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: charSet)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

extension UITableView {
    func showNoDataMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 13.0)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}

class KeyboardAccessoryToolbar: UIToolbar {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        self.barStyle = .default
        self.isTranslucent = true
        self.tintColor = UIColor.darkGray

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.items = [spaceButton, doneButton]

        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }

    @objc func done() {
        // Tell the current first responder (the current text input) to resign.
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

func formatNumber(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {
    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)B"

    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)M"

    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.reduceScale(to: 1)
        return "\(sign)\(formatted)K"

    case 0...:
        return "\(n)"

    default:
        return "\(sign)\(n)"
    }
}
