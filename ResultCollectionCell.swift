//
//  ResultCollectionCell.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/19/21.
//

import Foundation
import UIKit
import CoreData


class ResultcollectionCell: UICollectionViewCell {
    
    public var id: Int?;
    public var name: String?;
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    var mainImage: UIImageView = {
        let image = UIImageView();
        image.clipsToBounds = true;
        image.translatesAutoresizingMaskIntoConstraints = false;
        return image;
    }();
    
    var title: UILabel = {
        let title = UILabel();
        title.font = UIFont(name: "Courier", size: CGFloat(12));
        title.textColor = .white;
        title.sizeToFit();
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.textAlignment = .center;
        title.sizeToFit();
        return title;
    }();
    
    public var saveButton: UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.isUserInteractionEnabled = true;
        return button;
    }();
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        style();
    }
    
    // Interesting solution
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = saveButton.hitTest(saveButton.convert(point, from: self), with: event);
        if view == nil {
            view = super.hitTest(point, with: event)
        }
        return view;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainImage.roundCorners([.allCorners], radius: 7)
    }
    

    
    public func checkSavedStatus(drink: Drink)-> Void {
        print("Checking if saved", drink.getId())
        if( checkInDatabase(id: drink.getId()) ){
            self.saveButton.setImage(UIImage(named: "heart_red_small.png"), for: .normal);
        }else {
            self.saveButton.setImage(UIImage(named: "heart_small.png"), for: .normal);
        }
    }
    
    public func setId(id:Int)->Void {
        self.id = id;
    }
    public func getId()->Int {
        return self.id!;
    }
    
    public func setName(name:String)->Void {
        self.name = name;
    }
    public func getName()->String {
        return self.name!;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addViews()->Void {
        translatesAutoresizingMaskIntoConstraints = false;
        addSubview(mainImage);
        mainImage.addSubview(title);
        mainImage.addSubview(saveButton);
        title.backgroundColor = hexStringToUIColor(hex: "80fb8f14");
        
        mainImage.topAnchor.constraint(equalTo: topAnchor).isActive = true;
        mainImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0).isActive = true;
        mainImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        mainImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        
        title.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true;
        
        saveButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        saveButton.topAnchor.constraint(equalTo: topAnchor).isActive = true;
        
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        saveButton.widthAnchor.constraint(equalToConstant: 30).isActive = true;

        
    }
    
    public func checkInDatabase(id: Int)->Bool {
        do {
            let items = try self.context.fetch(Object.fetchRequest()) as [Object];
            for i in items {
                if(Int32(i.id) == Int32(id)){
                    return true;
                }else {
                    continue;
                }
            }
        }catch let error {
            print("Error Check in DB", error);
        }
        return false;
    }
    
    fileprivate func style()->Void {
        backgroundColor = .white;
        layer.cornerRadius = 7;
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3);
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
        
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
}

extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
