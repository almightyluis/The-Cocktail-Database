//
//  ViewController.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/25/21.
//

import UIKit
import GoogleMobileAds



// TO DO: JULY 28 2021
// RandomCallController -> last 2 buttons, API redesign based on buttons.
// MultiPickerController -> gets called based on RandomCallController last 2 buttons. Redesign so scrollview can fit dynamic views (new views)
// FilterView - > NEW buttons for drink type.



class MainViewController: UIViewController, UISearchBarDelegate {
    
    let screen = UIScreen.main.bounds;
    fileprivate var scrollView = UIScrollView();
    fileprivate var searchController:UISearchController?;
    fileprivate var loadingCircle = FadingCircleView();
    
    fileprivate var randomView: TileView?;
    fileprivate var filterView: TileView?;
    fileprivate var popularView: TileView?;
    fileprivate var latestView: TileView?;
    
    var load = LoadingAnimate();

    
    var mainTitle: UILabel = {
        let label = UILabel();
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50);
        label.font = UIFont(name: "Courier-Bold", size: CGFloat(25));
        label.textColor = .white;
        label.textAlignment = .left;
        label.numberOfLines = 2;
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "The Cocktail \nDatabase"
        return label;
    }();
    
    var centerContainer: UIView = {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }();
    
    var information: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = "An open, \ncrowd-sourced database of drinks and cocktails from around the world.";
        label.textColor = .white;
        label.numberOfLines = 3;
        label.sizeToFit();
        label.textAlignment = .left;
        label.font = UIFont(name: "Courier", size: CGFloat(12));
        return label;
    }();
    
    var sqlButton: UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Favorites", for: .normal);
        button.titleLabel?.font = UIFont(name: "Courier-Bold", size: CGFloat(15))
        button.layer.cornerRadius = 20;
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside);
        button.backgroundColor = .systemBlue;
        return button;
    }()
    /*
     
     */
    var creditButton: UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Credits", for: .normal);
        button.titleLabel?.font = UIFont(name: "Courier", size: CGFloat(13))
        let image = UIImage(named: "cardRight.png");
        button.setImage(image, for: .normal);
        button.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft;
        button.addTarget(self, action: #selector(onCreditClick), for: .touchUpInside);
        return button;
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationColor();
        setSearchBar();
        setScrollView();
        setCenterContainer();
        setCenterViews();
        setGestures();
        setLabel();
        setButton();
        style();
        
    }
    
   
    /*
        Shows Credit: AlertAction
     */
    @objc fileprivate func onCreditClick()->Void {
        let message: String = "Database provited by: The Cocktail Database \nLink: https://www.thecocktaildb.com \n\nIcons provited by: Icon8 & Flaticon \nLink: https://icons8.com \nLink: https://www.flaticon.com ";
        let alertController = UIAlertController(title: "Credits", message: message, preferredStyle: .actionSheet);
        
        let action = UIAlertAction(title: "Nice!", style: .default, handler: nil);
        alertController.addAction(action);
        
        self.present(alertController, animated: true , completion: nil);
        
        
    }
    /*
        Sets navigation colors
     */
    fileprivate func setNavigationColor()->Void {
        navigationController?.navigationBar.barStyle = .black;
        navigationController?.navigationBar.barTintColor = UIColor.black;
        navigationController?.navigationBar.tintColor = UIColor.white;
    }

    // Set Both SQL Button & Credit Button
    fileprivate func setButton()->Void {
        view.addSubview(sqlButton);
        sqlButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true;
        sqlButton.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        sqlButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true;
        sqlButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true;
        
        scrollView.addSubview(creditButton);
        creditButton.topAnchor.constraint(equalTo: centerContainer.bottomAnchor, constant: 10).isActive = true;
        creditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true;
        creditButton.heightAnchor.constraint(equalToConstant: 14).isActive = true;
    }
    
    fileprivate func setLabel()->Void {
        scrollView.addSubview(mainTitle);
        mainTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true;
        mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true;
        mainTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true;
        
      
    }
    
    /*
        Launch: FavoritesViewController
     */
    @objc public func onClick()->Void {
        sqlButton.pulsate();
        let nextView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "FavoriteesViewController") as? FavoriteesViewController;
        nextView?.modalPresentationStyle = .fullScreen;
        self.present(nextView!, animated: true, completion: nil);
    }
    
    fileprivate func style()->Void {
        view.backgroundColor = .black;
    }
    

    fileprivate func setGestures()->Void {
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.random))
        randomView!.addGestureRecognizer(gesture1);
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.filter))
        filterView!.addGestureRecognizer(gesture2);
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.popular))
        popularView!.addGestureRecognizer(gesture3);
        
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector(self.latest))
        latestView!.addGestureRecognizer(gesture4);
    }
    
    @objc fileprivate func latest()->Void {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController( withIdentifier: "LatestDrinksController") as? LatestDrinksController;
        vc?.modalPresentationStyle = .fullScreen;

        self.present(vc!, animated: true, completion: nil)
        print("Launching latest");
        return;
    }
    
    @objc fileprivate func popular()->Void {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController( withIdentifier: "PopularDrinksController") as? PopularDrinksController;
        vc?.modalPresentationStyle = .fullScreen;

        self.present(vc!, animated: true, completion: nil);
        print("Launching popular");
        return;
    }
    
    @objc fileprivate func filter(sender: UITapGestureRecognizer){
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController( withIdentifier: "FilterViewController") as? FilterViewController;
        vc?.modalPresentationStyle = .fullScreen;
        self.present(vc!, animated: true, completion: nil);
        print("Launching FilterViewController");
        return;
    }
    
    @objc fileprivate func random(sender : UITapGestureRecognizer){

        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController( withIdentifier: "RandomCallController") as? RandomCallController;
        vc?.modalPresentationStyle = .fullScreen;
        self.present(vc!, animated: true, completion: nil);
        print("Launching RandomCallController");
        return;
    }
    
    fileprivate func setCenterViews()->Void {
        randomView = TileView(frame: CGRect(x: 0, y: 0, width: 150, height: 150));
        randomView!.setValues(title: "Random", img: UIImage(named: "mainDice.png")!);
        randomView!.setColor(background: hexStringToUIColor(hex: "#141414"), textColor: .white);
        
        
        filterView = TileView(frame: CGRect(x: 0, y: 0, width: 150, height: 150));
        filterView!.setValues(title: "Filter", img: UIImage(named: "select.png")!);
        filterView!.setColor(background: hexStringToUIColor(hex: "#141414"), textColor: .white);
        
        
        popularView = TileView(frame: CGRect(x: 0, y: 0, width: 150, height: 150));
        popularView!.setValues(title: "Popular", img: UIImage(named: "trending.png")!);
        popularView!.setColor(background: hexStringToUIColor(hex: "#141414"), textColor: .white);
        
        latestView = TileView(frame: CGRect(x: 0, y: 0, width: 150, height: 150));
        latestView!.setValues(title: "Latest", img: UIImage(named: "latest.png")!);
        latestView!.setColor(background: hexStringToUIColor(hex: "#141414"), textColor: .white);
        
        centerContainer.addSubview(latestView!);
        centerContainer.addSubview(popularView!);
        centerContainer.addSubview(randomView!);
        centerContainer.addSubview(filterView!);
        
        randomView?.topAnchor.constraint(equalTo: centerContainer.topAnchor, constant: 10).isActive = true;
        randomView?.leadingAnchor.constraint(equalTo: centerContainer.leadingAnchor, constant: 10).isActive = true;
        randomView?.trailingAnchor.constraint(equalTo: centerContainer.centerXAnchor, constant: -10).isActive = true;
        randomView?.bottomAnchor.constraint(equalTo: centerContainer.centerYAnchor, constant: -10).isActive = true;
        

        
        filterView?.topAnchor.constraint(equalTo: centerContainer.topAnchor, constant: 10).isActive = true;
        filterView?.leadingAnchor.constraint(equalTo: centerContainer.centerXAnchor, constant: 10).isActive = true;
        filterView?.trailingAnchor.constraint(equalTo: centerContainer.trailingAnchor, constant: -10).isActive = true;
        filterView?.bottomAnchor.constraint(equalTo: centerContainer.centerYAnchor, constant: -10).isActive = true;
        
        
        
        popularView?.topAnchor.constraint(equalTo: centerContainer.centerYAnchor, constant: 10).isActive = true;
        popularView?.leadingAnchor.constraint(equalTo: centerContainer.leadingAnchor, constant: 10).isActive = true;
        popularView?.trailingAnchor.constraint(equalTo: centerContainer.centerXAnchor, constant: -10).isActive = true;
        popularView?.bottomAnchor.constraint(equalTo: centerContainer.bottomAnchor, constant: -10).isActive = true;
        
        
        latestView?.topAnchor.constraint(equalTo: centerContainer.centerYAnchor, constant: 10).isActive = true;
        latestView?.leadingAnchor.constraint(equalTo: centerContainer.centerXAnchor, constant: 10).isActive = true;
        latestView?.trailingAnchor.constraint(equalTo: centerContainer.trailingAnchor, constant: -10).isActive = true;
        latestView?.bottomAnchor.constraint(equalTo: centerContainer.bottomAnchor, constant: -10).isActive = true;

        
    }
    
    fileprivate func setCenterContainer()->Void {
        scrollView.addSubview(centerContainer);
        centerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        centerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        centerContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true;
        centerContainer.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -50).isActive = true;

        centerContainer.heightAnchor.constraint(equalToConstant: 450).isActive = true;
        
    }
    
    
    
    fileprivate func loading()->Void {
        view.addSubview(loadingCircle);
        loadingCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        loadingCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        loadingCircle.heightAnchor.constraint(equalToConstant: 90).isActive = true;
        loadingCircle.widthAnchor.constraint(equalToConstant: 200).isActive = true;
        loadingCircle.animate();
    }

    fileprivate func loadingAnimate()->Void {
        view.addSubview(load);
        load.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        load.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        load.heightAnchor.constraint(equalToConstant: 130).isActive = true;
        load.widthAnchor.constraint(equalToConstant: 130).isActive = true;
        self.load.animate();
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button click");

        let sometext = searchBar.searchTextField.text;
        if(sometext!.isEmpty ){
            DispatchQueue.main.async {
                self.showMessage(title: "Error", message: "Please make sure you are only using a-z characters");
            }
            return;
        }
        
        if let resultView = searchController?.searchResultsController as? SearchResultsController {
            resultView.setTableValues(str: sometext!);
            resultView.tableView.reloadData();
        }
      
    }
    
    public func showMessage(title: String, message: String)->Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alert.addAction(button);
        self.present(alert, animated: true, completion: nil);
    }
    
    /*
        Function input: String, String
        Return: String Array
     */
    public func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    /*
        Function input: String
        Return: String
        Purpose: Checking for white space
     */
    fileprivate func checkStringForSearch(str:String)->String {
        var editedString:String = "";
        if(str.rangeOfCharacter(from: .whitespaces) != nil){
            // Space is found
            let first = str.components(separatedBy: " ");
            let completedString = first[0] + "+" + first[1];
            editedString += completedString;
            return editedString;
        }else{
            // Space is not found;
            return str;
        }
    }
    
    /*
        Function input: String
        Return: UIColor
        Purpose: To use hex based colors
     */
    fileprivate func hexStringToUIColor (hex:String) -> UIColor {
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
    
    
 
    
    fileprivate func setSearchBar()->Void {
        let ser = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController( withIdentifier: "SearchResultsController") as? SearchResultsController;
        searchController?.searchBar.placeholder = "Search Drinks";
        
        searchController = UISearchController(searchResultsController: ser);
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.delegate = self;
        
        navigationItem.searchController = searchController;
        definesPresentationContext = true
    }
    
    func setScrollView()->Void {
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        self.view.addSubview(scrollView);
        self.scrollView.frame = CGRect(x: 0, y: 0, width: screen.width , height: screen.height);
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        self.scrollView.contentSize = CGSize(width: screen.width , height: screenHeight);
        self.scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        
        self.scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        

    }

}

