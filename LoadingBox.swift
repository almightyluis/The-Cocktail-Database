//
//  LoadingBox.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/21/21.
//

import Foundation
import UIKit


class LoadingBox: UIView {
    
    var loadingLabel: UILabel = {
        let label = UILabel();
        label.text = "Loading...";
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(14));
        label.textColor = .black;
        label.textAlignment = .center;
        return label;
    }()
    
    var loadingCircle : UIActivityIndicatorView = {
        let ss = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
        ss.color = .black;
        ss.style = .medium;
        ss.translatesAutoresizingMaskIntoConstraints = false;
        return ss;
    }();

    override init(frame: CGRect){
        super.init(frame: frame);
        configure();
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(title: String){
        self.loadingLabel.text = title;
    }
    
    fileprivate func configure(){
        
        addSubview(loadingCircle);
        addSubview(loadingLabel);
        loadingCircle.startAnimating();
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false;
        heightAnchor.constraint(equalToConstant: 100).isActive = true;
        widthAnchor.constraint(equalToConstant: 120).isActive = true;
        
        
        loadingCircle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
        loadingCircle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        loadingCircle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        loadingCircle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true;
        
        
        loadingLabel.topAnchor.constraint(equalTo: loadingCircle.bottomAnchor).isActive = true;
        loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true;
        loadingLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;
        layer.cornerRadius = 7;
        
        
        
    }
    
    public func stopAnimation() {
        //self.loadingCircle.stopAnimating();
        DispatchQueue.main.async {
            self.removeFromSuperview();
        }
    }
}
