//
//  LatestDrinksController.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/28/21.
//

import Foundation
import UIKit
import GoogleMobileAds


class LatestDrinksController: UIViewController {
    
    fileprivate var loadingCircle = FadingCircleView();
    
    var topContainer: UIView = {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = .black;
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
        return view;
    }();
    
    var upperLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.font = UIFont(name: "Courier", size: CGFloat(22));
        label.sizeToFit();
        label.textAlignment = .left;
        return label;
    }();
    
    var lowerLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.numberOfLines = 2;
        label.text = "Tap for more information.";
        label.font = UIFont(name: "Courier", size: CGFloat(12));
        label.textAlignment = .left;
        return label;
    }();
    
    var closeScreen : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        button.setImage(UIImage(named: "remove.png"), for: .normal);
        button.backgroundColor = .lightGray;
        button.clipsToBounds = true;
        button.layer.cornerRadius = button.frame.size.width / 2
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(closeCurrentScreen), for: .touchUpInside);
        return button;
    }();
    
    var stack: UIStackView = {
        let stack = UIStackView();
        stack.alignment = .center;
        stack.translatesAutoresizingMaskIntoConstraints = false;
        stack.axis = .vertical;
        stack.isUserInteractionEnabled = true;
        stack.distribution = .fillEqually;
        stack.spacing = 20.0;
        return stack;
    }();
    
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50));
        label.backgroundColor = .green;
        label.font = UIFont(name: "Courier", size: CGFloat(15));
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center;
        return label;
    }();
    
    fileprivate var latestLink = "https://www.thecocktaildb.com/api/json/v2/9973533/latest.php";
    public var scrollView = UIScrollView();
    public var gestureRecognizer = UITapGestureRecognizer();
    public var listCount:Int = 7;
    public var load = LoadingBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
    fileprivate var bannerView: GADBannerView!;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        loading();
        createApiCall();
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        setNavigationColor();
        setTopContainer();
        setScrollView();
        setStackView();
        showAdMob();
    }
    fileprivate func showAdMob()->Void {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true;
        bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        view.addSubview(bannerView)
        
        
        bannerView.adUnitID = "ca-app-pub-8134587941356156/7982156242"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
    
    fileprivate func loading() {
        view.addSubview(load);
        load.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        load.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
    }

    fileprivate func setNavigationColor()->Void {
        navigationController?.navigationBar.barStyle = .black;
        navigationController?.navigationBar.barTintColor = UIColor.black;
        navigationController?.navigationBar.tintColor = UIColor.white;
    }
    
    
    fileprivate func createApiCall()->Void {
        
        if(self.stack.arrangedSubviews.count > 0){
            self.load.stopAnimation();
            return;
        }
        var counter:Int32 = 1;
        let api = APICall();
        api.generalSearch(link: latestLink) { drinkArray in
            if(drinkArray.isEmpty || drinkArray.count <= 0 ){
                self.load.stopAnimation();
                print("Error: Empty. Show error message");
                return;
            }
            DispatchQueue.main.async {
                for i in drinkArray {
                
                    let container = CardContainer(frame: .zero);
                    container.setTextValues(image: self.downloadImage(link: i.getImageUrl()), title: i.getName(), category: i.getCategory(), alcoholic: i.getType());
                    //container.setColors(background: .systemBlue, titleColor: .black, categoryColor: .black , alcoholicColor: .black);
                    self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClick(sender: ) ));
                    
                    container.isUserInteractionEnabled = true;
                    container.tag = Int(i.getId()); // Assign tag to be id of current drink
                    
                    self.gestureRecognizer.numberOfTapsRequired = 1;
                    container.addGestureRecognizer(self.gestureRecognizer); // Every iteration add a gesture

                    container.setOptionalNumber(value: counter);
                    counter += 1;
                    self.stack.addArrangedSubview(container);
                }
            self.stack.setNeedsLayout();
            self.load.stopAnimation();
            }
            
        }
    }
    
    @objc public func onClick(sender: UITapGestureRecognizer)->Void {
        let id = String(sender.view?.tag ?? 0);
        if(id == "0"){
            print("Error id = 0");
        }
        let api = APICall();
        api.searchCallId(id: Int(id)!) { drinkArray in
            self.showValues(array: drinkArray);
            self.load.stopAnimation();
        }
    }
    
    public func showValues(array: [Drink]){
        if(array.count <= 0){
            // Deal with error here
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
    
    public func addFrontLabel(str:String, labelToUse: String)->String{
        return labelToUse + " : \n" + str;
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

    public func downloadImage(link: String)->UIImage {
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        return UIImage(data: data!) ?? UIImage(named: "default.png")!;
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Updateds the scrollView to match the stackview frame height
        scrollView.contentSize = CGSize(width: stack.frame.width, height: stack.frame.height)
    }
    
    
    fileprivate func setStackView()->Void {

        scrollView.addSubview(stack);
        
        //stack.addArrangedSubview(label);
        // Spacing
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true;
        stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true;
        stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true;
        stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true;
        stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true;
    
        
    }
    
    
    fileprivate func setScrollView()->Void {
        let screen = UIScreen.main.bounds;
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(scrollView);
        scrollView.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true;
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        
        print("SCREEN SIZE:" , screen.width, screen.height);
    }
    
    public func filterView()->UIView {
        let view = UIView();
        let filter = UIButton();
        filter.translatesAutoresizingMaskIntoConstraints = false;
        filter.setTitle("Filter", for: .normal);
        view.backgroundColor = .systemBlue;
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(filter);
        filter.anchorView(top: view.topAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor);
        
        return view;
    }
    
    fileprivate func setTopContainer()->Void {
        view.addSubview(topContainer);
        topContainer.addSubview(upperLabel);
        topContainer.addSubview(lowerLabel);
        topContainer.addSubview(closeScreen);
        
        topContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        topContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true;
        
        upperLabel.text = "List of latest cocktails.";
        upperLabel.anchorView(top: topContainer.centerYAnchor, leading: topContainer.leadingAnchor, bottom: nil, trailing: topContainer.trailingAnchor , padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20))
        
        lowerLabel.anchorView(top: upperLabel.bottomAnchor, leading: topContainer.leadingAnchor, bottom: topContainer.bottomAnchor, trailing: topContainer.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20));
        
        closeScreen.anchorView(top: nil, leading: nil, bottom: topContainer.bottomAnchor, trailing: lowerLabel.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 2), size: CGSize(width: 30, height: 30));
    }
    

    
    @objc func closeCurrentScreen()->Void {
        self.dismiss(animated: true, completion: nil);
    }
}
