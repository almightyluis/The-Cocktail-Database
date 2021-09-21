//
//  TableViewCell.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/18/21.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    // Variables needed
    var title: String?;
    var image: UIImage?;
    var drinkType: String?;
    var alcoholic: String?;
    
    var mainImage: UIImageView = {
        let image = UIImageView();
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleAspectFit;
        image.layer.masksToBounds = true;
        image.layer.cornerRadius = 7;
        return image;
    }();
    
    var mainTitle : UILabel = {
        let textView = UILabel();
        textView.font = UIFont(name: "Courier-Bold", size: 15);
        textView.textColor = .white;
        textView.translatesAutoresizingMaskIntoConstraints = false;
        return textView;
    }()
    
    var rightArrow : UIImageView = {
        let image = UIImageView();
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.contentMode = .scaleAspectFit;
        image.image = UIImage(named: "doubleRight")!;
        return image;
    }()

    var drinkTypeTitle: UILabel = {
        let description = UILabel();
        description.font = UIFont(name: "Courier", size: 11);
        description.textColor = .white;
        description.translatesAutoresizingMaskIntoConstraints = false;
        return description;
    }()
    
    var alcoholicTitle: UILabel = {
        let description = UILabel();
        description.font = UIFont(name: "Courier", size: 11);
        description.textColor = .white;
        description.translatesAutoresizingMaskIntoConstraints = false;
        return description;
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        // Add subviews here
        addSubview(mainImage);
        addSubview(mainTitle);
        addSubview(rightArrow);
        addSubview(drinkTypeTitle);
        addSubview(alcoholicTitle);
        
        backgroundColor = .black;
        //Constraints go here
        
        mainImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true;
        mainImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true;
        mainImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true;
        mainImage.widthAnchor.constraint(equalToConstant: 60).isActive = true;
        
        rightArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true;
        rightArrow.heightAnchor.constraint(equalToConstant: 15).isActive = true;
        rightArrow.widthAnchor.constraint(equalToConstant: 15).isActive = true;
        rightArrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true;
        
        mainTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true;
        mainTitle.leftAnchor.constraint(equalTo: self.mainImage.rightAnchor, constant: 10).isActive = true;
        
        drinkTypeTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 3).isActive = true;
        drinkTypeTitle.leftAnchor.constraint(equalTo: mainImage.rightAnchor, constant: 10).isActive = true;

        alcoholicTitle.topAnchor.constraint(equalTo: drinkTypeTitle.bottomAnchor, constant: 3).isActive = true;
        alcoholicTitle.leftAnchor.constraint(equalTo: mainImage.rightAnchor, constant: 10).isActive = true;
   
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews();
        if let message = title {
            mainTitle.text = message;
        }
        if let image = image {
            mainImage.image = image;
        }
        if let drinkType = drinkType {
            drinkTypeTitle.text = drinkType;
        }
        if let alc = alcoholic {
            alcoholicTitle.text = alc;
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
