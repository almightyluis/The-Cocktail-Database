//
//  PopupWindow.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//

import Foundation
import UIKit


// MARK: THIS SHOULD PRESENTED WITH CLEAR BACKGROUND
// MARK: DIMENTIONS SHOULD BE A BIT SMALLER

class PopupWindow: UIViewController {

    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    public var currentView = UIView();
    
    fileprivate var mainImage: UIImageView = {
        let imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.layer.cornerRadius = 10; // THIS MUST MATCH VIEW CORNER RADIUS
        imageView.contentMode = .scaleToFill;
        return imageView;
    }();
    
    fileprivate var drinkName: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .black;
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(18.0));
        return label;
    }();
    
    fileprivate var drinkAlcoholic: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .lightText;
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier", size: CGFloat(13.0));
        return label;
    }();
    
    fileprivate var drinkGlass: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .lightText;
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier", size: CGFloat(13.0));
        return label;
    }();
    
    
    fileprivate var drinkInstructions: UITextView = {
        let label = UITextView();
        label.textColor = .black;
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.isEditable = false;
        label.adjustsFontForContentSizeCategory = true;
        label.textAlignment = .left;
        label.backgroundColor = .clear;
        label.font = UIFont(name: "Courier", size: CGFloat(13.0));
        return label;
    }();
    
    fileprivate var drinkIngredients: UITextView = {
        let label = UITextView();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .black;
        label.backgroundColor = .clear;
        label.isEditable = false;
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier", size: CGFloat(13.0));
        return label;
    }();
    
    fileprivate var lowerView: UIView = {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }();
    
    fileprivate var closeButton: UIButton = {
        let button = UIButton();
        button.setImage(UIImage(named: "down.png"), for: .normal);
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = .clear;
        button.addTarget(self, action: #selector(closeScreen), for: .touchUpInside);
        return button;
    }();
    
    fileprivate var lowerControllStack: UIStackView = {
        let stack = UIStackView();
        stack.alignment = .center;
        stack.axis = .horizontal;
        stack.distribution = .equalCentering;
        stack.translatesAutoresizingMaskIntoConstraints = false;
        return stack;
    }();
    

    
    var id: Int = 0;
    var drink_name: String = "";
    var drink_imgpath: String = "";
    var drink_type: String = "";
    var object: Drink?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = .none;
        DispatchQueue.main.async {
            self.createViews();
        }

    }

 
    
    // MARK: Sets values for lables, images.
    public func setValues(img: UIImage, drinkName: String, alc: String, drinkInstuctions: String, drinkIngredients: String, drinkGlass: String)->Void {
        self.mainImage.image = img;
        self.drinkName.text = drinkName;
        self.drinkAlcoholic.text = alc;
        self.drinkInstructions.text = drinkInstuctions;
        self.drinkIngredients.text = drinkIngredients;
        self.drinkGlass.text = drinkGlass;
        self.drink_name = drinkName;
        self.drink_type = alc;
        
    }
    
    

    
    public func colors()->Void{
        self.drinkName.textColor = .black;
        self.drinkInstructions.textColor = .black;
        self.drinkIngredients.textColor = .black;
        self.drinkGlass.textColor = .lightGray;
        // BAckground color
        self.currentView.backgroundColor = .white;
        self.lowerView.backgroundColor = .white;
        //
        self.drinkAlcoholic.textColor = .lightGray;
    }
    
  
    
    public func showMessage(title: String, message: String)->Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alert.addAction(button);
        self.present(alert, animated: true, completion: nil);
    }
    
    
    // MARK: All textviews, images, are added to the original self.view.
    private func createViews()->Void {
        self.view.addSubview(currentView);
        currentView.translatesAutoresizingMaskIntoConstraints = false;
        currentView.layer.cornerRadius = 10;
        currentView.layer.masksToBounds = true;
        
        currentView.addSubview(mainImage);
        currentView.addSubview(lowerView);
        
        // MARK: LOWER VIEW LABELS
        lowerView.addSubview(drinkName);
        lowerView.addSubview(drinkAlcoholic);
        lowerView.addSubview(drinkInstructions);
        lowerView.addSubview(drinkIngredients);
        lowerView.addSubview(drinkGlass);
        lowerView.addSubview(closeButton);
        
        
        colors();
       
        // MARK: ANCHOR VIEW TO MAIN VIEW
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        print("Current screen height: ", screenWidth, screenHeight);
        
        if(screenHeight <= 700){
            currentView.anchorView(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 35, bottom: 40, right: 35));
        }else {
            currentView.anchorView(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 90, left: 35, bottom: 90, right: 35));
        }
        
        
        // MARK: IMAGE CENTER Y ANCHORING
        mainImage.anchorView(top: currentView.topAnchor, leading: currentView.leadingAnchor, bottom: currentView.centerYAnchor, trailing: currentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0));
        
        // MARK: LOWER VIEW ANCHORING
        lowerView.anchorView(top: currentView.centerYAnchor, leading: currentView.leadingAnchor, bottom: currentView.bottomAnchor, trailing: currentView.trailingAnchor,  padding: UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0));
        
        // MARK: LOWER VIEW LABELS ANCHORING
        drinkName.anchorView(top: lowerView.topAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5 ), size: CGSize(width: 0, height: 18));
        
        drinkAlcoholic.anchorView(top: drinkName.bottomAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5), size: CGSize(width: 0, height: 15));
        drinkGlass.anchorView(top: drinkAlcoholic.bottomAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5), size: CGSize(width: 0, height: 15));
    
        drinkInstructions.anchorView(top: drinkGlass.bottomAnchor, leading: lowerView.leadingAnchor, bottom: lowerView.centerYAnchor, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5 ));
        
        drinkIngredients.anchorView(top: lowerView.centerYAnchor, leading: lowerView.leadingAnchor, bottom: closeButton.topAnchor, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5 ));
        
        closeButton.anchorView(top: nil, leading: lowerView.leadingAnchor, bottom: lowerView.bottomAnchor, trailing: lowerView.trailingAnchor, size: CGSize(width: 50, height: 20));
        

    }
    
    @objc public func closeScreen()->Void {
        self.dismiss(animated: true, completion: nil);
    }
    
}
extension UIView {
    
    func anchorView(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
