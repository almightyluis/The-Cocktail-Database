//
//  CardContainer.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/18/21.
//

import Foundation
import UIKit



class CardContainer: UIView {
    
    var mainImage: UIImageView = {
        let image = UIImageView();
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleToFill;
        return image;
    }();
    
    var title: UILabel = {
        let title = UILabel();
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.textColor = .black;
        title.font = UIFont(name: "Courier-Bold", size: CGFloat(15));
        return title;
    }();
    
    var category: UILabel = {
        let title = UILabel();
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.textColor = .black;
        title.font = UIFont(name: "Courier", size: CGFloat(13));
        return title;
    }();
    
    var alcoholic: UILabel = {
        let title = UILabel();
        title.translatesAutoresizingMaskIntoConstraints = false;
        title.textColor = .black;
        title.font = UIFont(name: "Courier", size: CGFloat(13));
        return title;
    }();
    
    var line: UIView = {
        let line = UIView();
        line.backgroundColor = .black;
        line.translatesAutoresizingMaskIntoConstraints = false;
        return line;
    }();
    
    var optionalNumber: UILabel = {
        let label = UILabel();
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(12));
        label.textAlignment = .center;
        label.textColor = .black;
        return label;
    }();
    
    var rightArrow: UIImageView = {
        let image = UIImageView();
        image.image = UIImage(named: "cardRight.png");
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleToFill;
        return image;
    }();
    
    
    var block: UIView {
        let cool = UIView();
        cool.translatesAutoresizingMaskIntoConstraints = false;
        cool.backgroundColor = .systemBlue;
        cool.layer.masksToBounds = true;
        cool.layer.cornerRadius = 7;
        return cool;
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame); 
        configure();
    }
    
    required init?(coder: NSCoder) {
        fatalError("CODER MISSING");
    }
    
    public func setTextValues(image: UIImage, title: String, category: String, alcoholic: String)->Void {
        self.title.text = title;
        self.mainImage.image = image;
        self.category.text = category;
        self.alcoholic.text = alcoholic;
    }
    
    public func setOptionalNumber(value: Int32){
        self.optionalNumber.text = String(value);
    }
    
    fileprivate func configure()->Void {
        
        addSubview(mainImage);
        addSubview(title);
        addSubview(category);
        addSubview(alcoholic);
        addSubview(line);
        addSubview(optionalNumber);
        addSubview(rightArrow);


        addViewConstrains();
        imageStyle();
        cardStyle();
    }
    
    fileprivate func addViewConstrains()->Void {
        let screen = UIScreen.main.bounds;
        translatesAutoresizingMaskIntoConstraints = false;
        heightAnchor.constraint(equalToConstant: 70).isActive = true;
        widthAnchor.constraint(equalToConstant: (screen.width)/1.1 ).isActive = true;
        
        
        
        mainImage.frame = CGRect(x: 0, y: 0, width: 60, height: 60);
        mainImage.anchorView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0), size: CGSize(width: 60, height: 60));
        
        
        line.anchorView(top: topAnchor, leading: mainImage.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 25, left: 10, bottom: 25, right: 10), size: CGSize(width: 0.5, height: 0));
        
        optionalNumber.anchorView(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: mainImage.leadingAnchor);
        
        title.anchorView(top: topAnchor, leading: line.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 30));
        
        category.anchorView(top: title.bottomAnchor, leading: line.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 30));
        
        alcoholic.anchorView(top: category.bottomAnchor, leading: line.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 30));
        
       
        
        rightArrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true;
        rightArrow.heightAnchor.constraint(equalToConstant: 15).isActive = true;
        rightArrow.widthAnchor.constraint(equalToConstant: 15).isActive = true;
        rightArrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true;
        
    }
    
    
    fileprivate func cardStyle()->Void {
        backgroundColor = .white;
        layer.cornerRadius = 7;
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2.5
        
    }
    
    fileprivate func imageStyle()->Void {
        mainImage.layer.cornerRadius = (mainImage.frame.size.height / 2)
        mainImage.layer.masksToBounds = false;
        mainImage.clipsToBounds = true;
    }
}
