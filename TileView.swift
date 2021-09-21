//
//  TileView.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//

import Foundation
import UIKit


class TileView: UIView {
    
    var mainTitle: UILabel = {
        let label = UILabel();
        label.font = UIFont(name: "Courier-Bold", size: 18);
        label.textAlignment = .center;
        label.numberOfLines = 2;
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }();
    
    var iconImage: UIImageView = {
        let imageView = UIImageView(frame: .zero);
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.contentMode = .scaleToFill;
        return imageView;
    }();
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setColor(background: UIColor, textColor: UIColor)->Void {
        self.mainTitle.textColor = textColor;
        self.backgroundColor = background;
    }
    
    public func setValues(title:String, img:UIImage){
        self.mainTitle.text = title;
        self.iconImage.image = img;
    }
    
    fileprivate func setView()->Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        style();
        self.addSubview(mainTitle);
        self.addSubview(iconImage);
        
        mainTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true;
        iconImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true;
        iconImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true;
        
        iconImage.heightAnchor.constraint(equalToConstant: 60).isActive = true;
        iconImage.widthAnchor.constraint(equalToConstant: 60).isActive = true;
        
        mainTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        mainTitle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        mainTitle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        mainTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true;

    }
    
    
    fileprivate func hexStringToUIColor (hex:String) -> UIColor {
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
    
    fileprivate func style()->Void {
        layer.cornerRadius = 10;
        layer.borderWidth = 0.1;
        layer.borderColor = UIColor.white.cgColor;
    }
}

