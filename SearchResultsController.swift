//
//  SearchResultsController.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/26/21.
//

import Foundation
import UIKit


class SearchResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var objectArray = [Drink]();
    public var tableView = UITableView();
    fileprivate var link = "https://www.thecocktaildb.com/api/json/v2/9973533/search.php?s=";
    fileprivate var load = LoadingBox(frame: CGRect(x: 0, y: 0, width: 100, height: 100));
    public var imageArray:[UIImage] = [UIImage]();

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setTableView();

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        objectArray.removeAll();
        imageArray.removeAll();
        self.tableView.reloadData();
    }

    
    fileprivate func loading() {
        view.addSubview(load);
        load.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        load.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
    }
    

    
    public func downloadImage(link: String)->UIImage {
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        return UIImage(data: data!) ?? UIImage(named: "default.png")!;
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let onClickId = self.objectArray[indexPath.row].getId();
        let alertView = UIAlertController(title:self.objectArray[indexPath.row].getName(), message: "Show all information", preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Yes", style: .default, handler: {_ in self.createApiCall(id: onClickId)});
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertView.addAction(button);
        alertView.addAction(cancelButton);
        self.present(alertView, animated: true, completion: nil);
    }
    /*
        Function input: Int
        Return: Void
        Purpose: Create api call given id.
        Calls showsValues function
     */
    public func createApiCall(id:Int)->Void {
        let api = APICall()
        api.searchCallId(id: id) { drinkArray in
            if(drinkArray.isEmpty){
                self.load.stopAnimation();
                print("Error in API CALL id");
                return;
            }
            self.showValues(array: drinkArray);
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray.count;
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imageArray:[UIImage] = [UIImage]();
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TableViewCell;
        cell.selectionStyle = .gray;
        cell.title = self.objectArray[indexPath.row].getName();
        cell.image = self.imageArray[indexPath.row];
        cell.drinkType = self.objectArray[indexPath.row].getCategory();
        cell.alcoholic = self.objectArray[indexPath.row].getType();
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0;//Choose your custom row height
    }
    
    fileprivate func setTableView()->Void{
        view.addSubview(tableView);
        tableView.backgroundColor = .black;
        tableView.separatorColor = .lightText;
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "myCell");

        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true;
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
    }
    
    /*
        Function input:  String
        Return: Void
        Purpose: set returned array to ob (objectArray) to populate views
        Also removes any leftover & checks for empty array.
     */
    public func setTableValues(str:String)->Void {
        loading();
        let api = APICall();
        api.searchCallString(searchString: str) { drinkArray in
            if(drinkArray.isEmpty){
                self.load.stopAnimation();
                DispatchQueue.main.async {
                    self.load.stopAnimation();
                    self.showMessage(title: "Error", message: "No Result Found, Try Again.");
                }
            }
            // Check if
            if(self.imageArray.isEmpty){
                for i in drinkArray {
                    self.imageArray.append(self.downloadImage(link: i.getImageUrl()));
                }
            }else {
                self.imageArray.removeAll();

            }
            for i in drinkArray {
                self.imageArray.append(self.downloadImage(link: i.getImageUrl()));
            }
            self.objectArray = drinkArray;
            print(drinkArray.count, "Current Array Count");
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.load.stopAnimation();
            }
        }
    }
    
    
    public func showMessage(title: String, message: String)->Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let button = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alert.addAction(button);
        self.present(alert, animated: true, completion: nil);
    }
    
    
    // This is all needed to show the clicked object
    public func addFrontLabel(str:String, labelToUse: String)->String{
        return labelToUse + " : \n" + str;
    }
    /*
        Function input: [Drink] object array
        Return: Void
        Purpose: Display drink information
     */
    public func showValues(array: [Drink]){
        if(array.count <= 0){
            // Handle Error
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

    
    
}
