//
//  CustomCollectionCells.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//

import Foundation
import UIKit
class CustomCollectionCells: UICollectionViewCell {
    
    var title: UILabel = {
        let title = UILabel();
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.font = UIFont(name: "Courier-Bold", size: CGFloat(12));
        title.sizeToFit();
        title.textAlignment = .center;
        return title;
    }();
    
    var imgView: UIImageView = {
        let img = UIImageView();
        img.translatesAutoresizingMaskIntoConstraints = false;
        img.contentMode = .scaleAspectFit;
        return img;
    }();
    
    
    
    public var id: Int = 0;
    // False == OFF
    // True == ON
    public var buttonState: Bool = false;

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    public func determineState()->Bool {
        print(self.buttonState, "ORiginal state");
        self.buttonState = !self.buttonState;
        print(self.buttonState, "Changed State");
        return self.buttonState;
    }
    
    public func setColor(titleColor: UIColor, background: UIColor, borderColor: UIColor)->Void {
        self.title.textColor = titleColor;
        self.backgroundColor = self.hexStringToUIColor(hex: "0a0a0a");
        self.layer.borderColor = borderColor.cgColor;
    }
    
    public func addViews(){
        translatesAutoresizingMaskIntoConstraints = false;
        layer.cornerRadius = 10;
        layer.borderWidth = 0.2;
        layer.borderColor = UIColor.white.cgColor;
        
        addSubview(title);
        addSubview(imgView);
        imgView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true;
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true;
        imgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true;
        imgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true;
    
        title.topAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true;
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        title.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;
        
    }
    
    public func displayImage()->Void {
       // Display check mark with animation
    
        UIView.animate(withDuration: 0.25) {
            self.title.textColor = .black;
            //self.logoImage.alpha = 1.0;
            //self.shapeLayer.lineDashPattern = nil;
            self.layer.cornerRadius = 10;
            self.backgroundColor = self.hexStringToUIColor(hex: "#4398fc");
            self.layer.borderColor = UIColor.white.cgColor;
            self.layer.borderWidth = 1;
        }
    }
    public func removeImage()->Void {
        // Remove check mark with animation
        UIView.animate(withDuration: 0.25) {
            self.title.textColor = UIColor.white;
            //self.logoImage.image = nil;
            self.backgroundColor = self.hexStringToUIColor(hex: "0a0a0a");
            self.layer.cornerRadius = 10;
            self.layer.borderColor = UIColor.white.cgColor;
            self.layer.borderWidth = 0.2;
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
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


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
