//
//  ErrorWindow.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/31/21.

import Foundation
import UIKit


class ErrorWindow: UIViewController {
    
    fileprivate var mainTitle: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center;
        label.textColor = .white;
        label.font = UIFont(name: "Courier", size: CGFloat(14));
        label.numberOfLines = 2;
        return label;
    }()
    
    fileprivate var mainImage : UIImageView = {
        let img = UIImageView();
        img.translatesAutoresizingMaskIntoConstraints = false;
        img.contentMode = .scaleAspectFit;
        img.layer.cornerRadius = 10;
        return img;
    }();
    
    fileprivate var centerView = UIView();
    
    public func setValues(title: String, img: UIImage){
        self.mainTitle.text = title;
        self.mainImage.image = img;
        
    }
    
    fileprivate func setViews()->Void {
        
        self.view.backgroundColor = .clear; // transparent
        self.view.addSubview(centerView);
        self.view.backgroundColor = .clear //220000
        
        centerView.layer.cornerRadius = 10;
        
        centerView.backgroundColor = hexStringToUIColor(hex: "220000");
        
        
        centerView.anchorView(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 200, left: 40, bottom: 200, right: 40));
        
        centerView.addSubview(mainTitle);
        centerView.addSubview(mainImage);
        
        
        mainImage.anchorView(top: nil , leading: centerView.leadingAnchor, bottom: centerView.centerYAnchor, trailing: centerView.trailingAnchor, size: CGSize(width: 100, height: 100));
        mainTitle.anchorView(top: mainImage.bottomAnchor, leading: centerView.leadingAnchor, bottom: nil , trailing: centerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0));

    }
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        DispatchQueue.main.async {
            self.setViews();
        }
    }

}
