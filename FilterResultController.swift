//
//  FilterResultController.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/19/21.
//

import Foundation
import UIKit
import GoogleMobileAds
import CoreData

class FilterResultController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    // Array contains Name, Image, Id
    public var drinkResult: [Drink]?;
    public var querySearchValues: String?;
    fileprivate var bannerView: GADBannerView!
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let screen = UIScreen.main.bounds;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout);
        cv.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        cv.decelerationRate = .normal;
        cv.translatesAutoresizingMaskIntoConstraints = false;
        return cv
    }();
    
    var topContainer: UIView = {
        let someView = UIView();
        someView.translatesAutoresizingMaskIntoConstraints = false;
        someView.backgroundColor = .systemBlue;
        return someView;
    }();
    
    var upperLabel: UILabel = {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textColor = .white;
        label.text = "Filtered Results";
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
    
    
    fileprivate var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    var imageArrayPerformance: [UIImage] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setTextValues()
        setUpperView();
        setupCollectionConstraints();
        showAdMob();
        
        
        /// ADD THIS BACK
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        imageArrayPerformance.removeAll();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        downloadImagesForPerformance();
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
    
    // Perfomrance
    fileprivate func downloadImagesForPerformance()->Void{
        // MAke this escaping: complete
        for i in self.drinkResult!{
            self.imageArrayPerformance.append(self.downloadImage(link: i.getImageUrl()));
        }
    }
    
    fileprivate func setTextValues()->Void {
        self.lowerLabel.text = "Results for " + self.querySearchValues! + "\nDouble click to show more information."
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = IndexPath(item: indexPath.item, section: indexPath.section)
        let cell = self.collectionView.cellForItem(at: indexPath) as! ResultcollectionCell;
        
        self.handleApiCall(id: cell.getId(), name:cell.getName());
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ResultcollectionCell;
        cell?.mainImage.image = self.imageArrayPerformance[indexPath.row];
        cell?.title.text = self.drinkResult![indexPath.row].getName();
        cell?.setId(id: self.drinkResult![indexPath.row].getId());
        cell?.setName(name: self.drinkResult![indexPath.row].getName());
        
        cell?.saveButton.isUserInteractionEnabled = true;
        cell?.saveButton.tag = self.drinkResult![indexPath.row].getId();
        cell?.saveButton.addTarget(self, action: #selector(onSaveButtonClick(sender:)), for: .touchUpInside);
        
        let idObj = self.drinkResult![indexPath.row].getId();
        DispatchQueue.main.async {
            cell?.saveButton.setImage(self.checkSavedStatus(id: idObj), for: .normal);
        }
 
        return cell!;
    }
    
    public func checkSavedStatus(id: Int)-> UIImage {
        if( checkInDatabase(id: id) ){
            return UIImage(named: "heart_red_small.png")!;
        }else {
            return UIImage();
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
    
    @objc public func onSaveButtonClick(sender: UIButton)->Void {
        // Loading Label?
        let id = sender.tag;
        
        
        if (deleteCoreObject(id: id)){
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.5){
                    sender.alpha = 0.0;
                    
                }
                sender.removeFromSuperview();
            }
        }
        // Make API CALL with id
        // Use the data to save
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
    
   


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.drinkResult!.count;
    }
    
    public func handleApiCall(id:Int, name: String)->Void {
        let alert = UIAlertController(title: "Do you want to view more information?", message: "Show " + name + " details.", preferredStyle: .actionSheet);

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let api = APICall();
            api.searchCallId(id: id) { drinkSingleton in
                if(drinkSingleton.isEmpty || drinkSingleton.count < 0){
                    self.showMessage(title: "Error", message: "We encountered a strange error. Close and retry again.")
                    return;
                }else {
                    self.showValues(array: drinkSingleton);
                    return;
                }
            }
        }));
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    public func showMessage(title: String, message: String)->Void {
        let editRadiusAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        self.present(editRadiusAlert, animated: true);
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
                    
                })
            }
        }
    }

    
    public func downloadImage(link: String)->UIImage {
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        return UIImage(data: data!) ?? UIImage(named: "default.png")!;
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 2) - 10, height: 190)
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
        
        upperLabel.anchorView(top: topContainer.centerYAnchor, leading: topContainer.leadingAnchor, bottom: nil, trailing: topContainer.trailingAnchor , padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20))
        
        lowerLabel.anchorView(top: upperLabel.bottomAnchor, leading: topContainer.leadingAnchor, bottom: topContainer.bottomAnchor, trailing: topContainer.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20));
        
        closeScreen.anchorView(top: nil, leading: nil, bottom: topContainer.bottomAnchor, trailing: topContainer.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5), size: CGSize(width: 30, height: 30));

    }
    
    public func setupCollectionConstraints() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ResultcollectionCell.self,forCellWithReuseIdentifier: "cell");
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white;

        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topContainer.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true;
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true;
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        
        
 
    }
    
    @objc func closeCurrentScreen()->Void {
        self.dismiss(animated: true, completion: nil);
    }
    
    
}



