//
//  FilterViewController.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//

import Foundation
import UIKit
class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    public var linkToApi = "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?i=";
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView();
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.backgroundColor = .black;
        return scrollView;
    }();
    
    var upperLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.text = "Choose \nyour filters.";
        label.font = UIFont(name: "Courier", size: CGFloat(24));
        label.textAlignment = .left;
        label.numberOfLines = 2;
        return label;
    }();
    
    var lowerLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.numberOfLines = 0;
        label.text = "Choose your type of alcohol \nWe will find all drinks with your chosen ingredient.";
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
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screen = UIScreen.main.bounds;
        layout.minimumLineSpacing = 5.0;
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10);
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: (screen.width), height: 400), collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        return cv
    }();
    
    var topContainer: UIView = {
        let someView = UIView();
        someView.translatesAutoresizingMaskIntoConstraints = false;
        someView.backgroundColor = .systemBlue;
        return someView;
    }();
    
    var information: UITextView = {
        let textView = UITextView();
        textView.textAlignment = .center;
        textView.translatesAutoresizingMaskIntoConstraints = false;
        textView.isEditable = false;
        textView.layer.cornerRadius = 10;
        textView.isSelectable = false;
        return textView;
    }();
    
    fileprivate var makeSearch: UIButton = {
        let button = UIButton();
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside);
        button.setTitle("Search", for: .normal);
        button.titleLabel?.font = UIFont(name: "Courier-Bold", size: CGFloat(15))
        button.layer.cornerRadius = 20;
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.contentHorizontalAlignment = .center;
        button.backgroundColor = .systemBlue;
        return button;
    }();
    
    public var gin = DrinkTypesObject(name: "Gin", imagePath: UIImage(named: "gin-tonic")!, searchTerm: "Gin");
    public var vodka = DrinkTypesObject(name: "Vodka", imagePath: UIImage(named: "vodka")!, searchTerm: "Vodka");
    public var teq = DrinkTypesObject(name: "Tequila", imagePath: UIImage(named: "tequila")!, searchTerm: "Tequila");
    public var wisk = DrinkTypesObject(name: "Whiskey", imagePath: UIImage(named: "whiskey")!, searchTerm: "Whiskey");
    public var blended_wisk = DrinkTypesObject(name: "Blended Whiskey", imagePath: UIImage(named: "whiskey")!, searchTerm: "Blended_Whiskey");
    
    public var whisk = DrinkTypesObject(name: "Whisky", imagePath: UIImage(named: "whiskey")!, searchTerm: "Whisky");
    public var verm = DrinkTypesObject(name: "Vermouth", imagePath: UIImage(named: "vermouth")!, searchTerm: "Vermouth");
    public var dry_verm = DrinkTypesObject(name: "Dry Vermouth", imagePath: UIImage(named: "dry_vermouth")!, searchTerm: "Dry_Vermouth");
    public var sweet_verm = DrinkTypesObject(name: "Sweet Vermouth", imagePath: UIImage(named: "vermouth")!, searchTerm: "Sweet_Vermouth");
    public var cog = DrinkTypesObject(name: "Cognac", imagePath: UIImage(named: "brandy")!, searchTerm: "Cognac");
    public var rum = DrinkTypesObject(name: "Rum", imagePath: UIImage(named: "rum")!, searchTerm: "Rum");
    public var darkRum = DrinkTypesObject(name: "Dark Rum", imagePath: UIImage(named: "darkRum")!, searchTerm: "Dark_Rum");
    public var lightRum = DrinkTypesObject(name: "Light Rum", imagePath: UIImage(named: "light_rum")!, searchTerm: "Light_Rum");
    public var scotch = DrinkTypesObject(name: "Scotch", imagePath: UIImage(named: "vodka")!, searchTerm: "Scotch");
    public var malibu = DrinkTypesObject(name: "Malibu Rum", imagePath: UIImage(named: "rum")!, searchTerm: "Malibu_Rum")
    
    public var apple = DrinkTypesObject(name: "Apple", imagePath: UIImage(named: "apple")!, searchTerm: "Apple");
    public var cherry = DrinkTypesObject(name: "Cherry", imagePath: UIImage(named: "cherry")!, searchTerm: "Cherry");
    public var strawberry = DrinkTypesObject(name: "Strawberry", imagePath: UIImage(named: "strawberry")!, searchTerm: "Strawberry");
    public var lemon = DrinkTypesObject(name: "Lemon", imagePath: UIImage(named: "lemon")!, searchTerm: "Lemon");
    public var lime = DrinkTypesObject(name: "Lime", imagePath: UIImage(named: "lime")!, searchTerm: "Lime");
    public var orange = DrinkTypesObject(name: "Orange", imagePath: UIImage(named: "orange")!, searchTerm: "Orange");
    public var pinapple = DrinkTypesObject(name: "Pineapple", imagePath: UIImage(named: "pineapple")!, searchTerm: "Pineapple");
    public var brandy = DrinkTypesObject(name: "Brandy", imagePath: UIImage(named: "gin-tonic")!, searchTerm: "Brandy");
    public var amaretto = DrinkTypesObject(name: "Amaretto", imagePath: UIImage(named: "amaretto")!, searchTerm: "Amaretto");
    

    public var load = LoadingBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
    public var array: [DrinkTypesObject]?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = .black;
        setUpperView();
        setArrayValues();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        setScrollView();
        setupCollectionConstraints();
        setButton();
    }
    
    public func setArrayValues()->Void {
        array = [gin, vodka, lightRum , dry_verm, teq, wisk, verm, cog, rum, darkRum, brandy, sweet_verm, blended_wisk, scotch, whisk, malibu, amaretto ,apple, cherry, strawberry, lemon, lime, orange, pinapple];
    }
    
    fileprivate func loading() {
        view.addSubview(load);
        load.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        load.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
    }
    
    public func setButton()->Void {
        self.view.addSubview(makeSearch);
        makeSearch.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        makeSearch.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true;
        makeSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true;
        makeSearch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true;
    }
    
    fileprivate func loadingAnimate()->Void {
        view.addSubview(load);
        load.setTitle(title: "Searching ...");
        load.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        load.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [],  animations: {
        //use if you want to darken the background
          //go back to original form
          self.load.transform = .identity
        })
    }
    
    
    @objc fileprivate func onClick()->Void {
        makeSearch.pulsate();
        self.loadingAnimate()
        let queryBuild = buildString(array: self.array!);
        let completeLink = self.linkToApi + queryBuild;
        let apiCall = APICall();
        print("LINK: ", completeLink);
        apiCall.returnFirstCall(link: completeLink) { tempArray in
            if(tempArray.isEmpty || tempArray.count <= 0 ){
                DispatchQueue.main.async {
                    self.showMessage(title: "Error", message: "No result found for " + queryBuild);
                    self.load.stopAnimation();
                }
                return;
            }else {
                DispatchQueue.main.async {
                    let nextView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "FilterResultController", creator: nil) as FilterResultController;
                    nextView.drinkResult = tempArray;
                    nextView.querySearchValues = queryBuild;
                    nextView.modalPresentationStyle = .fullScreen;
                    self.present(nextView, animated: true, completion: {
                        self.load.stopAnimation();
                    })
                }
            }
        }
    }
    
    public func showMessage(title: String, message: String)->Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alert.addAction(button);
        self.present(alert, animated: true, completion: nil);
    }
    
    
    fileprivate func buildString(array: [DrinkTypesObject])->String {
        var str = "";
        var isFirstValue = true;
        for i in array {
            if(i.getState() == true){
                if(isFirstValue){
                    str += i.getSearchTerm();
                    isFirstValue = false;
                    continue;
                }
                str += ",";
                str += i.getSearchTerm();
            }
        }
        return str;
    }
    
    public func addFrontLabel(str:String, labelToUse: String)->String{
        return labelToUse + " : \n" + str;
    }
    
    
    public func showValues(array: Drink){
        DispatchQueue.main.async {
            // REFERENCE Drinks with first array object
            let nextView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "UpdatedPopupView", creator: nil) as UpdatedPopupView;
            nextView.setObject(drink: array);
            nextView.setObjectForDatabase(object: array);
            nextView.modalPresentationStyle = .fullScreen;
            self.present(nextView, animated: true, completion: {
                self.load.stopAnimation();
            })
        }
    }
    
    public func getDrinkIngredients(object: Drinks)->String{
        var str = "";
        var iter = 0;
        for i in object.ingredArray {
            if(object.ingredArray[iter] == " "){
                return str;
            }
            str += i + ": " + object.measureArray[iter] + "\n";
            iter += 1;
        }
        return str;
    }
    
    public func downloadImage(link: String)->UIImage {
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        return UIImage(data: data!) ?? UIImage(named: "default.png")!;
    }

    
    public func setInformation()->Void {
        
        scrollView.addSubview(information);
        information.heightAnchor.constraint(equalToConstant: 300).isActive = true;
        information.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        information.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        information.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true;
        
        information.backgroundColor = .clear;
        information.font = UIFont(name: "Courier", size: CGFloat(14))
        information.textColor = .white;
        information.text = "Gin: Opihr, Plymouth, Malfy, Beefeater... \n\nVodka: Grey Goose, Hangar, Pinnacle, Ciroc... \n\nTequila: El Jimador, Don Julio, Patrón, Corralejo... \n\nWhiskey: Buchana's, Jack Daniel’s, Crown Royal, Maker's Mark... \n\nVermouth: Carpano Antica, Noilly Prat, Martini & Rossi Riserva, Cinzano Rosso... \n\nCognac: Hennessy, Rémy Martin, Martell, Courvoisier... \n\nRum: Captain Morgan, Bacardi, Appleton Estate, Castillo...";
        
    }
    
    @objc func closeCurrentScreen()->Void {
        self.dismiss(animated: true, completion: nil);
    }
    
    public func setUpperView()->Void {
        self.view.addSubview(topContainer);
        topContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        topContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        topContainer.addSubview(upperLabel);
        topContainer.addSubview(lowerLabel);
        topContainer.addSubview(closeScreen);
        upperLabel.anchorView(top: topContainer.topAnchor, leading: topContainer.leadingAnchor, bottom: nil, trailing: topContainer.trailingAnchor , padding: UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20))
        lowerLabel.anchorView(top: upperLabel.bottomAnchor, leading: topContainer.leadingAnchor, bottom: topContainer.bottomAnchor, trailing: closeScreen.leadingAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 5));
        closeScreen.anchorView(top: nil, leading: nil, bottom: topContainer.bottomAnchor, trailing: topContainer.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5), size: CGSize(width: 30, height: 30));

    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (array?.count)!;
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item at \(indexPath.section)/\(indexPath.item) tapped");

        let indexPath = IndexPath(item: indexPath.item, section: indexPath.section)
        let cell = self.collectionView.cellForItem(at: indexPath) as! CustomCollectionCells;
        // Check the boolen value to determine on/off.
        let state = cell.determineState();
        // Match the current state from Object to Cell
        array?[indexPath.item].setState(bool: state);

        if(state == true){
            cell.displayImage();
        }else if(state == false){
            cell.removeImage();
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionCells;
        cell?.imgView.image = array![indexPath.row].getImagePath();
        cell?.title.text = array![indexPath.row].getName();
        cell?.id = array![indexPath.row].getId();
        
        cell?.setColor(titleColor: .white, background: hexStringToUIColor(hex: "0a0a0a"), borderColor: hexStringToUIColor(hex: "696464"));
        return cell!;
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    public func setupCollectionConstraints() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionCells.self,forCellWithReuseIdentifier: "cell");
        scrollView.addSubview(collectionView)
        let screen = UIScreen.main.bounds;
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: screen.width).isActive = true;
        
        self.scrollView.contentSize = CGSize(width: screen.width, height: height + 100);
 
    }
    
    
    public func setScrollView()->Void {
        self.view.addSubview(scrollView);
        self.scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true;
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.topContainer.bottomAnchor, constant: 0).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true;
    }
    
    public func hexStringToUIColor (hex:String) -> UIColor {
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
