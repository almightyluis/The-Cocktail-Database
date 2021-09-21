//
//  FavoritesViewController.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/3/21.
//

import Foundation
import UIKit
import GoogleMobileAds

class FavoriteesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    fileprivate var tableView = UITableView();
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    fileprivate var arrayObject: [Object] = [];
    fileprivate var bannerView: GADBannerView!;
    
    var topContainer: UIView = {
        let view = UIView();
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = .systemBlue;
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 150)
        return view;
    }();
    
    var label: UILabel = {
        let label = UILabel();
        label.text = "Favorites.";
        label.font = UIFont(name: "Courier", size: CGFloat(22));
        label.textColor = .white;
        label.textAlignment = .left;
        return label;
    }();
    
    var lowerLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.numberOfLines = 2;
        label.text = "Drinks saved on current device.";
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
    
    var load = LoadingBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        loading();
        fillTableArray();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setTableView();
        setNavigationColor();
        showAdMob()
    }
    
    fileprivate func showAdMob()->Void {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true;
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
    
    fileprivate func fillTableArray()->Void {
        
        DispatchQueue.main.async {
            do{
                let items = try self.context.fetch(Object.fetchRequest());
                self.arrayObject = (items as! [Object]);
                
                for i in (items as! [Object]){
                    self.performanceArray.append(self.downloadImage(link: i.imageLink!));
                }
                self.load.stopAnimation();
                
            }catch let error {
                print("Error CORE", error);
            }
            self.tableView.reloadData();
        }
        
    }
    
    @objc func closeCurrentScreen()->Void {
        self.dismiss(animated: true, completion: nil);
    }
    
    fileprivate func setTableView()->Void {
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "myCell");
        
        view.addSubview(tableView);
        view.addSubview(topContainer);
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        tableView.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true;
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        
        
        view.addSubview(topContainer);
        topContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        topContainer.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true;
        topContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true;
        
        
        topContainer.addSubview(label);
        topContainer.addSubview(lowerLabel);
        topContainer.addSubview(closeScreen);
        
        label.anchorView(top: topContainer.centerYAnchor, leading: topContainer.leadingAnchor, bottom: nil, trailing: topContainer.trailingAnchor , padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20))
        
        lowerLabel.anchorView(top: label.bottomAnchor, leading: topContainer.leadingAnchor, bottom: topContainer.bottomAnchor, trailing: topContainer.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20));
        
        closeScreen.anchorView(top: nil, leading: nil, bottom: topContainer.bottomAnchor, trailing: topContainer.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5), size: CGSize(width: 30, height: 30));
        
        view.backgroundColor = .black;
        tableView.backgroundColor = .black;
    }
    
    
    fileprivate func refreshArray()->Void {
        do {
            let items = try self.context.fetch(Object.fetchRequest());
            self.arrayObject = (items as! [Object]);
            
            self.performanceArray.removeAll();
            for i in (items as! [Object]){
                self.performanceArray.append(self.downloadImage(link: i.imageLink!));
            }
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
            
            
        }catch let error {
            print("Error", error);
        }
    }
    
    fileprivate func handleSliderEvent(rm: Int, row: Int, dId: Int) ->Void {
        print("ID h", dId);
    
        switch rm {
        case 0:
            let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to trash this?", preferredStyle: .alert);
            let noBtn = UIAlertAction(title: "No", style: .default, handler: nil);
            let yesBtn = UIAlertAction(title: "Yes", style: .destructive) { (_) in
                
                self.context.delete(self.arrayObject[row]);
                do {
                    try self.context.save()
                    self.refreshArray();
                }catch let error as NSError {
                    print("Error deleting", error);
                }
                    
            }
            alertController.addAction(noBtn);
            alertController.addAction(yesBtn);
            self.present(alertController, animated: true, completion: nil);
            break;
        case 1:
            // Share button handle here
            let name: String = self.arrayObject[row].name!;
            let ingredients: String = self.arrayObject[row].ingredients!;
            let image: UIImage = self.downloadImage(link: self.arrayObject[row].imageLink!);
            let measure: String = self.arrayObject[row].instructions!;
            
            let allValues = [image, name ,ingredients, measure] as [Any];
            let activityContoller = UIActivityViewController(activityItems: allValues, applicationActivities: nil);
            
            if let popOver = activityContoller.popoverPresentationController {
                popOver.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                popOver.sourceView = self.view;
                popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0);
            }
            self.present(activityContoller, animated: true, completion: nil)
            
            break;
        default:
            print("DEFAULT: handleSliderEvent");
        }
    }
  
    
    public func addFrontLabel(str:String, labelToUse: String)->String{
        return labelToUse + " : \n" + str;
    }
    
    public func showValues(array: Object){
       
        DispatchQueue.main.async {
            // REFERENCE Drinks with first array object
            let drinkObject = array
            let instructions = self.addFrontLabel(str: drinkObject.instructions!, labelToUse: "Instructions");
            let ingredients = self.addFrontLabel(str:drinkObject.ingredients! , labelToUse: "Ingredients");

            let nextView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "PopupWindow", creator: nil) as PopupWindow;
            nextView.modalTransitionStyle = .flipHorizontal;
            nextView.setValues(img: self.downloadImage(link: drinkObject.imageLink!), drinkName: drinkObject.name!, alc: drinkObject.type!, drinkInstuctions: instructions , drinkIngredients: ingredients , drinkGlass: drinkObject.category!);
            
            // black
            //nextView.setColors(drinkName: .black, drinkInstructions:  .black, drinkIngredients:  .black, drinkGlass: .black, backgroundColor: .white, drinkAlc: .black);
            
            self.present(nextView, animated: true, completion: {
                print("Presented from Search");
            })
        }
        
    }
        

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let onClickId = self.arrayObject[indexPath.row];
        let alertView = UIAlertController(title:self.arrayObject[indexPath.row].name, message: "Show all information", preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Yes", style: .default, handler: {_ in self.showValues(array: onClickId)   });
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertView.addAction(button);
        alertView.addAction(cancelButton);
        self.present(alertView, animated: true, completion: nil);
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let objectId = self.arrayObject[indexPath.row].id;
        let removeAction = UIContextualAction(
            style: .normal,
            title: "Remove Action",
            handler: { _,_,_  in
                self.handleSliderEvent(rm: 0, row: indexPath.row, dId: Int(objectId) )
        })

        let shareAction = UIContextualAction(
            style: .normal,
            title: "New Alert Action",
            handler: { _,_,_  in
                //do what you want here
                self.handleSliderEvent(rm: 1, row: indexPath.row, dId: Int(objectId));
        })

        removeAction.image = UIImage(named: "trash.png")
        removeAction.title = "Delete";
        removeAction.backgroundColor = UIColor.systemRed;
        
        shareAction.image = UIImage(named: "share.png")
        shareAction.backgroundColor = UIColor.systemBlue;
        shareAction.title = "Share"

        let configuration = UISwipeActionsConfiguration(actions: [removeAction, shareAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    fileprivate var performanceArray: [UIImage] = []
    
    
    fileprivate func downloadImage()->Void {
        for i in arrayObject {
            self.performanceArray.append(self.downloadImage(link: i.imageLink!));
        }
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayObject.count ;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;//Choose your custom row height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TableViewCell;
        cell.title = self.arrayObject[indexPath.row].name;
        
        cell.image = self.performanceArray[indexPath.row];
        
        cell.drinkType = self.arrayObject[indexPath.row].category;
        cell.alcoholic = self.arrayObject[indexPath.row].type;
        return cell
    }
    
    public func downloadImage(link: String)->UIImage {
        if(link == "NA") {return UIImage(named: "default.png")!;}
        let url = URL(string: link)
        if let data = try? Data(contentsOf: url!) {
            return UIImage(data: data)!;
        }else {
            return UIImage(named: "default.png")!;
        }
    }
    
    
}
