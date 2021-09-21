//
//  UpdatedPopupView.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/15/21.
//


/// REGEX FOR 1/2 oz ml cl
/// (\d?/\d)\s[ocm][zll]

/// POTENTIAL REGEX FOR ALL:
// (\d|\d/\d)\s[ocm][zll]

/// REGEX FOR ALL
// This includes 1 1/2 oz also 0.5 ml

// (\d|\d/\d|\d\s\d/\d|\d.\d)\s[ocm][zll]



import Foundation
import UIKit
import CoreData

class UpdatedPopupView: UIViewController {
    
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    fileprivate var arrayObject: [Object] = [];
    
    fileprivate var mainImage: UIImageView = {
        let imageView = UIImageView();
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.layer.cornerRadius = 10; // THIS MUST MATCH VIEW CORNER RADIUS
        imageView.contentMode = .scaleToFill;
        imageView.isUserInteractionEnabled = true;
        return imageView;
    }();

    fileprivate var drinkName: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.textAlignment = .center;
        label.text = "Margarita";
        label.font = UIFont(name: "Courier", size: CGFloat(23.0));
        return label;
    }();
    
    fileprivate var holderAlcohol: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .systemBlue;
        label.text = "TYPE"
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(15.0));
        return label;
    }();
    
    fileprivate var drinkAlcoholic: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.text = "Alcoholic"
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier", size: CGFloat(14.0));
        return label;
    }();
    
    fileprivate var holderGlass: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .systemBlue;
        label.text = "GLASS"
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(15.0));
        return label;
    }();
    
    fileprivate var drinkGlass: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.textAlignment = .left;
        label.text = "Tall Glass"
        label.font = UIFont(name: "Courier", size: CGFloat(14.0));
        return label;
    }();
    
    fileprivate var holderInstructions: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .systemBlue;
        label.text = "INSTRUCTIONS"
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(15.0));
        return label;
    }();
    
    fileprivate var drinkInstructions: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.numberOfLines = 0;
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier", size: CGFloat(14.0));
        return label;
    }();
    
    fileprivate var holderIngredients: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .systemBlue;
        label.text = "INGREDIENTS"
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(15.0));
        return label;
    }();
    
    fileprivate var drinkIngredients: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.textAlignment = .left;
        label.numberOfLines = 0;
        label.font = UIFont(name: "Courier", size: CGFloat(14.0));
        return label;
    }();
    
    var closeScreen : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        button.setImage(UIImage(named: "remove.png"), for: .normal);
        button.backgroundColor = .lightGray;
        button.clipsToBounds = false ;
        button.isUserInteractionEnabled = true;
        button.layer.cornerRadius = button.frame.size.width / 2
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(closeCurrentScreen), for: .touchUpInside);
        return button;
    }();
    
    public var saveButton: UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitleColor(.white, for: .normal);
        //button.setImage(UIImage(named: "heart-white.png"), for: .normal);
        button.addTarget(self, action: #selector(onSaveButtonClick), for: .touchUpInside);
        return button;
    }();
    
    public var shareButton: UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setImage(UIImage(named: "share-white.png"), for: .normal);
        button.addTarget(self, action: #selector(onShareClick), for: .touchUpInside);
        button.setTitleColor(.white, for: .normal);
        return button;
    }();
    
    fileprivate var centerView: UIView = {
        let view = UIView();
        view.isUserInteractionEnabled = true;
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }();
    
    var scrollView: UIScrollView = {
        let scroll = UIScrollView();
        scroll.translatesAutoresizingMaskIntoConstraints = false;
        scroll.isScrollEnabled = true;
        scroll.backgroundColor = .black;
        return scroll;
    }();
    
    var language: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Spanish", "German", "French", "Italian", "English"]);
        seg.translatesAutoresizingMaskIntoConstraints = false;
        seg.backgroundColor = .systemBlue;
        let attr = NSDictionary(object: UIFont(name: "Courier", size: 13.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes((attr as! [NSAttributedString.Key : Any]), for: .normal);
        seg.tintColor = .gray;
        seg.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged);
        return seg;
    }();
    
    var units: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["oz", "cl", "ml"]);
        seg.translatesAutoresizingMaskIntoConstraints = false;
        seg.backgroundColor = .systemBlue;
        let attr = NSDictionary(object: UIFont(name: "Courier", size: 13.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes((attr as! [NSAttributedString.Key : Any]), for: .normal)
        seg.tintColor = .gray;
        seg.addTarget(self, action: #selector(segmentChangeUnits(_:)), for: .valueChanged);
        return seg;
    }();
    
    var line: UIView = {
        var line = UIView();
        line.backgroundColor = .white;
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true;
        line.translatesAutoresizingMaskIntoConstraints = false;
        line.widthAnchor.constraint(equalToConstant: 50).isActive = true;
        return line;
    }();
    
    fileprivate var objectReference: Drink?;
    fileprivate var object: Object?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = .black;
        DispatchQueue.main.async {
            self.createViews();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    public func setObjectForDatabase(object: Drink)->Void {
        self.objectReference = object;
        checkSavedStatus(drink: object);
    }

    
    @objc fileprivate func onShareClick()->Void {
        let image: UIImage = self.mainImage.image!;
        let name: String = self.drinkName.text!;
        let ingred: String = self.drinkIngredients.text!;
        let measure: String = self.drinkInstructions.text!;
        
        let allValues = [image, name ,ingred, measure] as [Any];
        let activityContoller = UIActivityViewController(activityItems: allValues, applicationActivities: nil);
        
        if let popOver = activityContoller.popoverPresentationController {
            popOver.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popOver.sourceView = self.view;
            popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0);
        }
        self.present(activityContoller, animated: true, completion: nil)
    }
    
    public func checkSavedStatus(drink: Drink)-> Void {
        print("Checking if saved", drink.getId())
        if( checkInDatabase(id: drink.getId()) ){
            self.saveButton.setImage(UIImage(named: "heart-white-filled.png"), for: .normal);
        }else {
            self.saveButton.setImage(UIImage(named: "heart-white.png"), for: .normal);
        }
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
    
    public func deleteCoreObject(id:Int)->Bool {
        do {
            let items = try self.context.fetch(Object.fetchRequest());
            for i in items as! [Object] {
                if(Int32(i.id) == Int32(id)){
                    self.context.delete(i);
                    do{
                        try self.context.save();
                        return true;
                    } catch {
                        print("Delete Error");
                        return false;
                    }
                }
            }
        }catch let error {
            print("Error",error)
            return false;
        }
        return false;
    }
    
    @objc fileprivate func onSaveButtonClick()->Void {
        self.saveButton.pulsate();
        // Check if in favorites.
        if( checkInDatabase(id: self.objectReference!.getId()) ) {
            // User wants to unfollow therefore remove from core data and unfill.
            let status = deleteCoreObject(id: self.objectReference!.getId());
            print("STATUS", status);
            if(status){
                DispatchQueue.main.async {
                    self.saveButton.setImage(UIImage(named: "heart-white.png"), for: .normal);
                }
                return;
            }else{
                self.showMessage(title: "Error", message: "Removing existing drink item from core data.")
                return;
            }
        }
        // I should pass a object to this class to be easy data copy
        let core = Object(context: self.context);
        core.id = Int32(self.objectReference!.getId());
        core.category = self.objectReference?.getCategory();
        core.imageLink = self.objectReference?.getImageUrl();
        if(self.drinkInstructions.text == "Not Available" || self.drinkIngredients.text == " "){
            core.instructions = self.drinkInstructions.text; // Because this can be converted
        }
        core.instructions = self.drinkInstructions.text; // Because this can be converted
        core.ingredients = self.drinkIngredients.text;
        
        core.name = self.objectReference?.getName();
        core.type = self.objectReference?.getType();

        do {
            try context.save();
            DispatchQueue.main.async {
                self.saveButton.setImage( UIImage(named: "heart-white-filled.png")!, for: .normal);
            }
        }catch let error {
            print("Error CORE", error);
        }
    }
    
    public func showMessage(title: String, message: String)->Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alert.addAction(button);
        self.present(alert, animated: true, completion: nil);
    }
    
    public func setObject(drink: Drink)->Void{
        self.mainImage.image = self.downloadImage(link: drink.getImageUrl());
        self.drinkName.text = drink.getName();
        self.drinkGlass.text = drink.getType();
        self.drinkAlcoholic.text = drink.getCategory();
        self.drinkIngredients.text = drink.getToStringIngredients();
        self.drinkInstructions.text = drink.getInstructions();
        self.objectReference = drink;
    }
    
    public func downloadImage(link: String)->UIImage {
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        return UIImage(data: data!) ?? UIImage(named: "default.png")!;
    }
    
    // "oz", "cl", "ml"
    @objc public func segmentChangeUnits(_ segmentedControl: UISegmentedControl)->Void {
        
        DispatchQueue.main.async {
            switch(segmentedControl.selectedSegmentIndex){
            case 0:
                self.drinkIngredients.text = self.objectReference?.getToStringOz()
                break;
            case 1:
                self.drinkIngredients.text = self.objectReference?.getToStringCl()
                break;
            case 2:
                self.drinkIngredients.text = self.objectReference?.getToStringMl()
                break;
            default:
                self.drinkIngredients.text = self.objectReference?.getToStringOz()
                break;
            }
        }
    }
    
    @objc public func segmentChange(_ segmentedControl: UISegmentedControl)->Void {
        
        DispatchQueue.main.async {
            switch(segmentedControl.selectedSegmentIndex){
            case 0:
                self.drinkInstructions.text = self.objectReference?.getES();
                break;
            case 1:
                self.drinkInstructions.text = self.objectReference?.getDE();
                break;
            case 2:
                self.drinkInstructions.text = self.objectReference?.getFR();
                break;
            case 3:
                self.drinkInstructions.text = self.objectReference?.getIT();
                break;
            case 4:
                self.drinkInstructions.text = self.objectReference?.getInstructions();
                break;
            default:
                self.drinkInstructions.text = self.objectReference?.getInstructions();
                break;
            }
        }
    }
    
    
    fileprivate func createViews()->Void {
        view.addSubview(mainImage);
        mainImage.addSubview(closeScreen);
        
        closeScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true;
        closeScreen.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true;
        closeScreen.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        closeScreen.widthAnchor.constraint(equalToConstant: 30).isActive = true;
        
        mainImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        mainImage.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true;
        
        view.addSubview(scrollView);
        scrollView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;

        scrollView.addSubview(centerView);
        centerView.heightAnchor.constraint(equalToConstant: 27).isActive = true;
        centerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        centerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        centerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true;
        
        centerView.addSubview(saveButton);
        saveButton.trailingAnchor.constraint(equalTo: centerView.trailingAnchor, constant: -10).isActive = true;
        saveButton.topAnchor.constraint(equalTo: centerView.topAnchor, constant: 0).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: centerView.bottomAnchor).isActive = true
        
        centerView.addSubview(shareButton);
        shareButton.leadingAnchor.constraint(equalTo: centerView.leadingAnchor, constant: 10).isActive = true;
        shareButton.topAnchor.constraint(equalTo: centerView.topAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: centerView.bottomAnchor).isActive = true
        
        scrollView.addSubview(drinkName);
        drinkName.topAnchor.constraint(equalTo: centerView.bottomAnchor, constant: 20).isActive = true;
        drinkName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true;
        drinkName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true;
        
        scrollView.addSubview(line);
        line.topAnchor.constraint(equalTo: drinkName.bottomAnchor, constant: 5).isActive = true;
        line.centerXAnchor.constraint(equalTo: drinkName.centerXAnchor).isActive = true;
        
        scrollView.addSubview(holderAlcohol);
        holderAlcohol.topAnchor.constraint(equalTo: drinkName.bottomAnchor, constant: 10).isActive = true;
        holderAlcohol.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true;
        holderAlcohol.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        
        scrollView.addSubview(drinkAlcoholic);
        drinkAlcoholic.topAnchor.constraint(equalTo: holderAlcohol.bottomAnchor, constant: 20).isActive = true;
        drinkAlcoholic.leadingAnchor.constraint(equalTo: holderAlcohol.leadingAnchor, constant: 10).isActive = true;
        drinkAlcoholic.trailingAnchor.constraint(equalTo: holderAlcohol.trailingAnchor).isActive = true;
        
        scrollView.addSubview(holderGlass);
        holderGlass.topAnchor.constraint(equalTo: drinkAlcoholic.bottomAnchor, constant: 20).isActive = true;
        holderGlass.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true;
        holderGlass.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        
        scrollView.addSubview(drinkGlass);
        drinkGlass.topAnchor.constraint(equalTo: holderGlass.bottomAnchor, constant: 20).isActive = true;
        drinkGlass.leadingAnchor.constraint(equalTo: holderAlcohol.leadingAnchor, constant: 10).isActive = true;
        drinkGlass.trailingAnchor.constraint(equalTo: holderAlcohol.trailingAnchor).isActive = true;
        
        scrollView.addSubview(holderInstructions);
        holderInstructions.topAnchor.constraint(equalTo: drinkGlass.bottomAnchor, constant: 20).isActive = true;
        holderInstructions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true;
        holderInstructions.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        
        scrollView.addSubview(drinkInstructions);
        drinkInstructions.topAnchor.constraint(equalTo: holderInstructions.bottomAnchor, constant: 20).isActive = true;
        drinkInstructions.leadingAnchor.constraint(equalTo: holderAlcohol.leadingAnchor, constant: 10).isActive = true;
        drinkInstructions.trailingAnchor.constraint(equalTo: holderAlcohol.trailingAnchor, constant: -10).isActive = true;
        
        scrollView.addSubview(holderIngredients);
        holderIngredients.topAnchor.constraint(equalTo: drinkInstructions.bottomAnchor, constant: 20).isActive = true;
        holderIngredients.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true;
        holderIngredients.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        
        scrollView.addSubview(drinkIngredients);
        drinkIngredients.topAnchor.constraint(equalTo: holderIngredients.bottomAnchor, constant: 20).isActive = true;
        drinkIngredients.leadingAnchor.constraint(equalTo: holderAlcohol.leadingAnchor, constant: 10).isActive = true;
        drinkIngredients.trailingAnchor.constraint(equalTo: holderAlcohol.trailingAnchor, constant: -10).isActive = true;
        
        scrollView.addSubview(language);
        language.topAnchor.constraint(equalTo: drinkIngredients.bottomAnchor, constant: 20).isActive = true;
        language.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true;
        language.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true;
        
        scrollView.addSubview(units);
        units.topAnchor.constraint(equalTo: language.bottomAnchor, constant: 20).isActive = true;
        units.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true;
        units.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true;
        
        self.dynamicScrollViewChange();
    }
    
    fileprivate func dynamicScrollViewChange()->Void {
        let screen = UIScreen.main.bounds;
        let screenWidth = screen.width;

        let maxLabelWidth: CGFloat = screenWidth - 20;
        var sum:CGFloat = 0.0;
        var spaceInBetween = 1;
        for i in scrollView.subviews{
            spaceInBetween += 1;
            sum += i.sizeThatFits( CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude)).height;
        }
        let finalSum = CGFloat(spaceInBetween * 20) + sum;
        self.scrollView.contentSize = CGSize(width: screenWidth, height: finalSum);
    }
    
    @objc func closeCurrentScreen()->Void {
        self.dismiss(animated: true, completion: nil);
    }
    
    
}
