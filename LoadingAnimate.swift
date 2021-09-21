//
//  LoadingAnimate.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/6/21.
//

import Foundation
import UIKit
import CoreGraphics


class LoadingAnimate: UIView {
    
    let circle1 = UIView();

    var imageView: UIImageView = {
        let image = UIImageView();
        image.contentMode = .scaleAspectFit;
        image.image = UIImage(named: "martini.png");
        return image;
    }();
    
    var loadingLabel: UILabel = {
        let label = UILabel();
        label.text = "Loading...";
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(14));
        label.textColor = .white;
        label.textAlignment = .center;
        return label;
    }()
        
    override init(frame: CGRect){
        super.init(frame: frame);
        configure();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure()->Void {
        backgroundColor = .lightGray;
        translatesAutoresizingMaskIntoConstraints = false;
        layer.cornerRadius = 10;
        alpha = 0.0;
        
        addSubview(imageView);
        addSubview(loadingLabel);
    
        imageView.frame = CGRect(x: 40, y: 35, width: 50, height: 50);
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;

            
        loadingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true;
        loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        loadingLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;

    }
    
    public func setTitle(title:String)->Void {
        self.loadingLabel.text = title;
    }
    
    public func animate() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.duration = 1.5;
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
        imageView.layer.add(rotateAnimation, forKey: nil);
        
        
        UIView.animate(withDuration: 1.5) {
            self.alpha = 1.0
            self.frame.origin.y += 10;
        }
    }
    
    public func stopAnimation(){
        UIView.animate(withDuration: 1.1) {
            self.imageView.layer.removeAllAnimations();
            self.frame.origin.y += 10;
            self.alpha = 0.0
        }completion: { _ in
            self.removeFromSuperview();
        }
    }
    
    
    
    
}


