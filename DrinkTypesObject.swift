//
//  DrinkTypesObject.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/6/21.
//

import Foundation
import UIKit


class DrinkTypesObject {
    
    private static var seedId = 0;
    
    var id: Int;
    var name: String;
    var image: UIImage;
    var state: Bool;
    var searchTerm: String;
    
    var specialContainer: [String] = [];
    
    init(name:String, imagePath: UIImage, searchTerm: String) {
        DrinkTypesObject.seedId += 1;
        self.id = DrinkTypesObject.seedId;
        self.name = name;
        self.searchTerm = searchTerm;
        self.image = imagePath;
        self.state = false;
    }
    
    public func getName()->String {return self.name;}
    public func getImagePath()->UIImage {return self.image;}
    public func getId()->Int {return self.id;}
    public func getState()->Bool {return self.state;}
    public func setState(bool: Bool)->Void{ self.state = bool; }
    public func getSearchTerm()->String { return self.searchTerm; }
    
    public func addToContainer(value: String) {
        self.specialContainer.append(value);
    }
    
    
        
}
