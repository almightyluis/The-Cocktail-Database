//
//  RandomCallController.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//

import Foundation
import UIKit
import GoogleMobileAds

class RandomCallController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
     
    fileprivate var upperLabel: UILabel = {
        let label = UILabel();
        label.text = "Find \nRandomized Drink";
        label.numberOfLines = 2;
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier", size: CGFloat(25));
        return label;
    }();
    
    fileprivate var randomizeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150));
        button.setImage(UIImage(named: "single.png"), for: .normal);
        button.backgroundColor = .lightText;
        button.clipsToBounds = true;
        button.layer.cornerRadius = button.frame.size.width / 2
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(randomizeClick), for: .touchUpInside);
        return button;
    }();
    
    fileprivate var multiPersonButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150));
        button.setImage(UIImage(named: "group.png"), for: .normal);
        button.backgroundColor = .lightText;
        button.clipsToBounds = true;
        button.layer.cornerRadius = button.frame.size.width / 2
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(randomMultiPersonClick), for: .touchUpInside);
        return button;
    }();
    
    fileprivate var randomList: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150));
        button.setImage(UIImage(named: "randomlist.png"), for: .normal);
        button.backgroundColor = .lightText;
        button.clipsToBounds = true;
        button.layer.cornerRadius = button.frame.size.width / 2
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(randomListClick), for: .touchUpInside);
        return button;
    }();
    
    
    var closeButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        button.setImage(UIImage(named: "remove.png"), for: .normal);
        button.backgroundColor = .lightGray;
        button.clipsToBounds = true;
        button.layer.cornerRadius = button.frame.size.width / 2
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside);
        return button;
    }();
    
    var list = [1,2,3,4,5,6,7,8,9,10];
    var segOptions = ["Mix","Alcoholic", "Non Alcoholic"];
    var currentListValue: Int?;
    var currentSegmentValue: Int?;
    public var loadingCircle = FadingCircleView();
    let scrollView = UIScrollView();
    public var load = LoadingBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100));

    public var bannerView: GADBannerView!;
    

    override func viewDidLoad() {
        super.viewDidLoad();
        setScrollView();
        setViews();
        showAdMob();
    }
    
    fileprivate func showAdMob()->Void {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true;
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        view.addSubview(bannerView)
        
        
        bannerView.adUnitID = "ca-app-pub-8134587941356156~5846662085"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }

  
    fileprivate func loading() {
        view.addSubview(load);
        load.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        load.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentListValue = list[row];
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count;
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(list[row]);
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1;
    }
    
    
    @objc public func randomMultiPersonClick()->Void {
        
        multiPersonButton.pulsate();
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300);
        
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let segmentControll = UISegmentedControl(items: self.segOptions);
        let attr = NSDictionary(object: UIFont(name: "Courier", size: 10.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes((attr as! [NSAttributedString.Key : Any]), for: .normal)
        segmentControll.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged);
        segmentControll.translatesAutoresizingMaskIntoConstraints = false;
        pickerView.translatesAutoresizingMaskIntoConstraints = false;
        
        vc.view.addSubview(segmentControll);
        vc.view.addSubview(pickerView);
        segmentControll.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true;
        segmentControll.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 0).isActive = true;
        
        segmentControll.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 0).isActive = true;
        segmentControll.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: 0).isActive = true;
        segmentControll.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: 0).isActive = true;
        segmentControll.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        
        
        pickerView.topAnchor.constraint(equalTo: segmentControll.bottomAnchor, constant: 0).isActive = true;
        pickerView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true;
        pickerView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true;
        pickerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: 0).isActive = true;
        
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor, constant: 0).isActive = true;
        
        let editRadiusAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "Courier", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black]

        
        let titleString = NSAttributedString(string: "Select the number of drinks to find.", attributes: titleAttributes)
        editRadiusAlert.setValue(titleString, forKey: "attributedTitle");


        editRadiusAlert.setValue(vc, forKey: "contentViewController");
        let action = UIAlertAction(title: "Go!", style: .default) { _ in
            self.multiPersonCall(count: self.currentListValue ?? 0, type: self.currentSegmentValue ?? 0);
        }
        editRadiusAlert.addAction(action);
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        self.present(editRadiusAlert, animated: true)
   
    }
    // Sets the segment value
    @objc public func segmentChange(_ segmentedControl: UISegmentedControl)->Void {
        self.currentSegmentValue = segmentedControl.selectedSegmentIndex;
    }
    
    public func multiPersonCall(count: Int, type: Int)-> Void {
        
        if(count == 0) {
            self.showMessage(title: "Error", message: "Try selection one of the options. \nOption 1: Will generate a single random drink. \nOption 2: Will generate a random number of drinks up to 10. \nOption 3: Will generate a list of 10 random drinks.")
            return print("Error: MULTIPERSON CALL 0");
        }
        print("Current MULTI NUMBER", self.currentListValue!, type);
        let nextView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MultiPickerController", creator: nil) as MultiPickerController;
        nextView.listNumber = self.currentListValue;
        nextView.type = type;
        nextView.modalPresentationStyle = .fullScreen;
        DispatchQueue.main.async {
            self.present(nextView, animated: true, completion: nil);
        }
    }
    
    
    @objc public func randomListClick()->Void {
        randomList.pulsate();
        let nextView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MultiPickerController", creator: nil) as MultiPickerController;
        nextView.listNumber = 10;
        nextView.type = 0;
        nextView.modalPresentationStyle = .fullScreen;
        DispatchQueue.main.async {
            self.present(nextView, animated: true, completion: nil);
        }
    }
    
    
    // "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11145"; // USE THIS TO FIND ERRORS VIA ID SEARCH
    @objc public func randomizeClick()->Void {
        loading()
        randomizeButton.pulsate(); //Performance issues???
        let apiObject = APICall();
        apiObject.randomSearch { drinkArray in
            if(drinkArray.isEmpty){
                print("Empty");
                self.showMessage(title: "Error", message: "Try again later, we are having issues.")
                return;
            }
            self.showValues(array: drinkArray);
        }
    }
    
    public func showMessage(title: String, message: String)->Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alert.addAction(button);
        self.present(alert, animated: true, completion: nil);
    }

    public func addFrontLabel(str:String, labelToUse: String)->String{
        return labelToUse + " : \n" + str;
    }
    
    public func showValues(array: [Drink]){
        if(array.count <= 0){
            self.load.stopAnimation();
            return;
        }else{
            DispatchQueue.main.async {
                // REFERENCE Drinks with first array object
                let nextView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "UpdatedPopupView", creator: nil) as UpdatedPopupView;
                
                nextView.setObject(drink: array[0]);
                nextView.setObjectForDatabase(object: array[0]);
                
                
                nextView.modalPresentationStyle = .fullScreen;
                self.present(nextView, animated: true, completion: {
                    self.load.stopAnimation();
                })
            }
        }
    }
    
    public func downloadImage(link: String)->UIImage {
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        return UIImage(data: data!) ?? UIImage(named: "default.png")!;
    }
    
    
    public func drinkIngredients(left: [String], right: [String])->String {
        var str = "";
        var it = 0;
        for i in left {
            if(i == " " || i.isEmpty){
                return str;
            }
            str += i + ": " + right[it] + "\n";
            it += 1;
        }
        return str;
    }
    
    
    @objc func closeButtonClick()->Void {
        print("CLi");
        self.dismiss(animated: true, completion: nil);
    }
    
    public func setScrollView()->Void {
        view.backgroundColor = .black;
        
        view.addSubview(closeButton);
        view.addSubview(scrollView);
        closeButton.heightAnchor.constraint(equalToConstant: 30 ).isActive = true;
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true;

        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true;
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true;
        closeButton.bottomAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true;
        
        let size = UIScreen.main.bounds;
        let width = size.width;
        let height = size.height;
        
        scrollView.contentSize = CGSize(width: width, height: height);
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true;
        
        //scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant:-10).isActive = true;
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true;

    }
    
    public func setViews()-> Void {
        // Views to add
        scrollView.backgroundColor = .black;
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        scrollView.addSubview(upperLabel);
        scrollView.addSubview(randomizeButton);
        scrollView.addSubview(multiPersonButton);
        scrollView.addSubview(randomList);
        
        
        //upperLabel.anchorView(top: scrollView.topAnchor, leading: view.leadingAnchor, bottom: randomizeButton.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 50, right: 20));
        
        upperLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true;
        upperLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true;
        upperLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true;
        
        
        randomizeButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true;
        randomizeButton.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 40).isActive = true;
        randomizeButton.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        randomizeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true;
        
        
        multiPersonButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true;
        multiPersonButton.topAnchor.constraint(equalTo: randomizeButton.bottomAnchor, constant: 50).isActive = true;
        multiPersonButton.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        multiPersonButton.widthAnchor.constraint(equalToConstant: 150).isActive = true;
        
        
        randomList.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true;
        randomList.topAnchor.constraint(equalTo: multiPersonButton.bottomAnchor, constant: 50).isActive = true;
        randomList.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        randomList.widthAnchor.constraint(equalToConstant: 150).isActive = true;
        
        
    }
}


//CREDIT: https://stackoverflow.com/questions/31320819/scale-uibutton-animation-swift/31321914

extension UIButton {

        func pulsate() {

            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.2
            pulse.fromValue = 0.95
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = 2
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
            layer.add(pulse, forKey: "pulse")
        }

        func flash() {

            let flash = CABasicAnimation(keyPath: "opacity")
            flash.duration = 0.2
            flash.fromValue = 1
            flash.toValue = 0.1
            flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            flash.autoreverses = true
            flash.repeatCount = 3

            layer.add(flash, forKey: nil)
        }


        func shake() {

            let shake = CABasicAnimation(keyPath: "position")
            shake.duration = 0.05
            shake.repeatCount = 2
            shake.autoreverses = true

            let fromPoint = CGPoint(x: center.x - 5, y: center.y)
            let fromValue = NSValue(cgPoint: fromPoint)

            let toPoint = CGPoint(x: center.x + 5, y: center.y)
            let toValue = NSValue(cgPoint: toPoint)

            shake.fromValue = fromValue
            shake.toValue = toValue

            layer.add(shake, forKey: "position")
        }
    }

 



