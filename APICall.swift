//
//  APICall.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//



// MARK: HANDLE TIME OUT ERROR,
// MARK: FOR SLOW INTERNET CONNECTIONS END THE CALL


import Foundation
import UIKit

class APICall {
    
    fileprivate var filterAPI = "https://www.thecocktaildb.com/api/json/v2/9973533/filter.php?i=";
    fileprivate var randomLink = "https://www.thecocktaildb.com/api/json/v2/9973533/randomselection.php";
    fileprivate var findByIdLink = "https://www.thecocktaildb.com/api/json/v2/9973533/lookup.php?i=";
    fileprivate var searchLink = "https://www.thecocktaildb.com/api/json/v2/9973533/search.php?s=";
    
    public init() { }
    
    
    
    /*
        Function input: int array
        Return: Via @escaping -> array Drink(Object)
        Purpose: given a number of id
     */
    public func queryWithIds(arr: [Int], complete: @escaping ([Drink])->Void)->Void {
        var intArray: [Int] = arr;
        var objectArray = [Drink]();
        while(!intArray.isEmpty){
            for i in 0..<intArray.count {
                print(intArray[i]);
            }
            
            let count = intArray.count - 1; // last element
            if(count < 0){
                complete(objectArray);
                return;
            }
            let id = intArray[count];
            let ss = findByIdLink + String(id);
            print("WHILE LOOP",ss);
            var request = URLRequest(url: NSURL(string: String(ss) )! as URL );

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET";
            request.timeoutInterval = 30.0;

            
            // This might not be called fast enough
            //
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    if(data == nil){
                        complete(objectArray);
                        print("Error in data");
                        return;
                    }else {
                        let jsonDecoder = JSONDecoder()
                        // Returns single array
                        let diff = try jsonDecoder.decode(Json4Swift_Base.self, from: data!);
                        if( (diff.drinks?.isEmpty) == true || diff.drinks == nil){
                            print("queryWithIds is empty");
                        }
                        // each call returns a single value at zero
                        let ref = diff.drinks![0];
                        objectArray.append(Drink(id: Int(ref.idDrink!)!, name: ref.strDrink!, category: ref.strCategory!, type: ref.strAlcoholic!, instructions: ref.strInstructions!, ingredientsArray: ref.ingredArray, measureArray: ref.measureArray, imageUrl: ref.strDrinkThumb!));
                    }
                    complete(objectArray);
                } catch {
                    print("JSON Serialization error, DrinkData Function");
                }
            }).resume();
            
            intArray.removeLast();
        }
        
    }
    

    public func searchRandomWithType(link:String, type: Int, numberOfValues: Int?,completionBlock: @escaping([Drink])->Void)->Void{
        var temp = [Drink]();
        var request = URLRequest(url: NSURL(string: String(link) )! as URL );
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET";
        request.timeoutInterval = 30.0;

        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if(data == nil){
                    print("Error in data");
                    completionBlock(temp);
                    return;
                }else {
                    let jsonDecoder = JSONDecoder();
                    
                    switch type {
                    // Default if none of 1-2 are pickeed
                    case 0:
                        //
                        let diff = try jsonDecoder.decode(Json4Swift_Base.self, from: data!);
                        DispatchQueue.main.async {
                            if let array = diff.drinks {
                                for object in array {
                                    let ref = Drink(id: Int(object.idDrink!)!, name: object.strDrink!, category: object.strCategory!, type: object.strAlcoholic!, instructions: object.strInstructions!, ingredientsArray: object.ingredArray, measureArray: object.measureArray, imageUrl: object.strDrinkThumb!)
                                    temp.append(ref);
                                }
                                completionBlock(temp);
                            }else {
                                completionBlock(temp);
                            }
                        }
                        break;
                    case 1:
                        let json = try jsonDecoder.decode(Json4Swift_Base_Ext.self, from: data!);
                        var randomArray = [Int]();
                        for _ in 0..<numberOfValues! {
                            let ref = Int.random(in: 0..<json.drinks!.count);
                            
                            if let objId = json.drinks![ref].idDrink {
                                randomArray.append(Int(objId)!);
                            }
                        }
                        self.queryWithIds(arr: randomArray) { array in
                            print("COMPLETED ARRAY", array.count); // Should match listNumber
                            if(array.count == numberOfValues){
                                completionBlock(array);
                            }
                        }
                        break;
                    case 2:
                        let json = try jsonDecoder.decode(Json4Swift_Base_Ext.self, from: data!);
                        var randomArray = [Int]();
                        for _ in 0..<numberOfValues! {
                            let ref = Int.random(in: 0..<json.drinks!.count);
                            let objId = json.drinks![ref].idDrink;
                            
                            randomArray.append(Int(objId!)!);
                        }

                        self.queryWithIds(arr: randomArray) { array in
                            print("COMPLETED ARRAY", array.count); // Should match listNumber
                            if(array.count == numberOfValues){
                                completionBlock(array);
                            }
                        }
                        break;
                    default:
                        print("Deff");
                        completionBlock(temp);
                        break;
                    }
                }
            } catch {
                print("JSON Serialization error, DrinkData Function");
            }
        }).resume();
    }
    
    
    public func searchCallId(id: Int, completionBlock: @escaping ([Drink])->Void ) ->Void {
        let searchLink = findByIdLink + String(id);
        var temp: [Drink] = [];
        var request = URLRequest(url: NSURL(string: String(searchLink))! as URL);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET";
        request.timeoutInterval = 30.0;

        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if(data == nil){
                    print("Error in data");
                    completionBlock(temp);
                    return;
                }else {
                    let jsonDecoder = JSONDecoder()
                    // Returns single array
                    let diff = try jsonDecoder.decode(Json4Swift_Base.self, from: data!);
                    
                    if let array = diff.drinks {
                        DispatchQueue.main.async {
                            for i in array {
                                temp.append(Drink(id: Int(i.idDrink!)!, name: i.strDrink!, category: i.strCategory!, type: i.strAlcoholic!, instructions: i.strInstructions!, ingredientsArray: i.ingredArray, measureArray: i.measureArray, imageUrl: i.strDrinkThumb!));
                            }
                            completionBlock(temp);
                            return;
                        }
                    }else {
                        completionBlock(temp);
                        print("Error empty array search ID");
                        return;
                    }
                }
            } catch {
                completionBlock(temp);
                print("JSON Serialization error, DrinkData Function");
            }
        }).resume();
    }
    
    fileprivate func checkStringForSearch(str:String)->String {
        var editedString:String = "";
        if(str.rangeOfCharacter(from: .whitespaces) != nil){
            // Space is found
            let first = str.components(separatedBy: " ");
            for i in first {
                if(first.last == i){
                    editedString += i;
                    break;
                }
                editedString += i + "+";
            }
            return editedString;
        }else{
            // Space is not found;
            return str;
        }
    }
    
    
    // ________________________________________________________
    // Having errors here from FilteredViewController AUG-19-2021
    // MARK THIS IS A MAJOR ERROR
    // TEST POINTS: DRY_VERMOUTH, DARK_RUM
    // ________________________________________________________
    public func returnFirstCall(link:String,completionBlock: @escaping ([Drink]) -> Void)->Void {
        var request = URLRequest(url: URL(string: link)!)
        var temp:[Drink] = []
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30.0;
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if(data == nil){
                    print("Error in data");
                    completionBlock(temp);
                    return;
                }else {
                    let jsonDecoder = JSONDecoder()
                    // Returns single array
                    let responseModel = try jsonDecoder.decode(Json4Swift_Base_Ext.self, from: data!);
                    if let array = responseModel.drinks {
                        for i in array {
                            let tempObj = Drink(id: Int(i.idDrink!)!, name: i.strDrink!, category: "", type: "", instructions: "", ingredientsArray: [""], measureArray: [""], imageUrl: i.strDrinkThumb!);
                            temp.append(tempObj);
                        }
                        completionBlock(temp);
                        return;
                    }else {
                        print("ID ARRAY EMPTY 1")
                        completionBlock(temp);
                        print("Error on return first call");
                        return;
                    }
                }
            } catch {
                print("JSON Serialization error, returnFirstCall data");
                completionBlock(temp);
            
            }
        }).resume()
    }
    
   
    
    public func getData(link: URL, complete: @escaping (Drink)->Void, errorType: @escaping (String)->Void )->Void {
        print("LOOP",link)
        var request = URLRequest(url: link)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET";
        request.timeoutInterval = 30.0;

        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if(data == nil){
                    print("Error in data");
                    errorType("Data Error");
                    return;
                }else {
                    let jsonDecoder = JSONDecoder()
                    // Returns single array
                    let diff = try jsonDecoder.decode(Json4Swift_Base.self, from: data!);
                    
                    if let array = diff.drinks {
                        let i = array[0];
                        complete(Drink(id: Int(i.idDrink!)!, name: i.strDrink!, category: i.strCategory!, type: i.strAlcoholic!, instructions: i.strInstructions!, ingredientsArray: i.ingredArray, measureArray: i.measureArray, imageUrl: i.strDrinkThumb!));
                    }
                }
            } catch {
                print("JSON Serialization error, DrinkData Function");
                errorType("Error");
            }
        }).resume();
    }

    
    // Will return empty array?
    public func searchCallString (searchString: String, completionBlock: @escaping ([Drink])->Void ) ->Void {
        let searchStringChecked = checkStringForSearch(str: searchString);
        let finalLink = self.searchLink + searchStringChecked;
        var temp: [Drink] = [];
        var request = URLRequest(url: NSURL(string: String(finalLink) )! as URL );
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET";
        request.timeoutInterval = 30.0;

        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if(data == nil){
                    print("Error in data");
                    completionBlock(temp);
                    return;
                }else {
                    do {
                        let jsonDecoder = JSONDecoder()
                        // Returns single array
                        let diff = try jsonDecoder.decode(Json4Swift_Base.self, from: data!);
                        if let array = diff.drinks {
                            DispatchQueue.main.async {
                                for i in array {
                                    temp.append(Drink(id: Int(i.idDrink!)!, name: i.strDrink!, category: i.strCategory!, type: i.strAlcoholic!, instructions: i.strInstructions!, ingredientsArray: i.ingredArray, measureArray: i.measureArray, imageUrl: i.strDrinkThumb!));
                                }
                                completionBlock(temp);
                            }
                        }else {
                            completionBlock(temp);
                        }
                    }catch let error {
                        completionBlock(temp);
                        print("Error", error);
                    }
                }
            }
        }).resume();
    }
    
    
    
    public func randomSearch(completionBlock: @escaping ([Drink]) -> Void )->Void {
        var request = URLRequest(url: URL(string: self.randomLink)!)
        var temp: [Drink] = [];
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        request.timeoutInterval = 30.0;

        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if(data == nil){
                    print("Error in data");
                    completionBlock(temp);
                    return;
                }else {
                    let jsonDecoder = JSONDecoder()
                    // Returns single array
                    let diff = try jsonDecoder.decode(Json4Swift_Base.self, from: data!);
                    
                    if((diff.drinks?.isEmpty) == nil){
                        completionBlock(temp);
                        return;
                    }
                    for i in diff.drinks! {
                        let val = Drink(id: Int(i.idDrink!)!, name: i.strDrink!, category: i.strCategory!, type: i.strAlcoholic!, instructions: i.strInstructions!, ingredientsArray: i.ingredArray, measureArray: i.measureArray, imageUrl: i.strDrinkThumb!)
                        val.setES(str: i.strInstructionsES ?? "Not available");
                        val.setFR(str: i.strInstructionsFR ?? "Not available");
                        val.setDE(str: i.strInstructionsDE ?? "Not available");
                        val.setIT(str: i.strInstructionsIT ?? "Not available");
                        temp.append(val);
                    }
                    completionBlock(temp);
                }
            } catch {
                print("JSON Serialization error, DrinkData")
            }
        }).resume()
    }
    
    
    public func generalSearch(link: String,completionBlock: @escaping ([Drink]) -> Void ){
        var request = URLRequest(url: URL(string: link)!)
        var temp: [Drink] = [];
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        request.timeoutInterval = 30.0;

        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if(data == nil){
                    print("Error in data");
                    return;
                }else {
                    let jsonDecoder = JSONDecoder()
                    // Returns single array
                    let diff = try jsonDecoder.decode(Json4Swift_Base.self, from: data!);
                    
                    if((diff.drinks?.isEmpty) == nil){
                        completionBlock(temp);
                        return;
                    }
                    for i in diff.drinks! {
                        temp.append(Drink(id: Int(i.idDrink!)!, name: i.strDrink!, category: i.strCategory!, type: i.strAlcoholic!, instructions: i.strInstructions!, ingredientsArray: i.ingredArray, measureArray: i.measureArray, imageUrl: i.strDrinkThumb!))
                    }
                    completionBlock(temp);
                }
            } catch {
                print("JSON Serialization error, DrinkData")
            }
        }).resume()
    }
    
    
}
struct Json4Swift_Base_Ext : Codable {
    let drinks : [DrinkPrev]?;
    
    enum CodingKeys: String, CodingKey {

        case drinks = "drinks"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        drinks = try values.decodeIfPresent([DrinkPrev].self, forKey: .drinks)
    }

}


struct DrinkPrev : Codable {
    let strDrink : String?
    let strDrinkThumb : String?
    let idDrink : String?

    enum CodingKeys: String, CodingKey {

        case strDrink = "strDrink"
        case strDrinkThumb = "strDrinkThumb"
        case idDrink = "idDrink"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        strDrink = try values.decodeIfPresent(String.self, forKey: .strDrink)
        strDrinkThumb = try values.decodeIfPresent(String.self, forKey: .strDrinkThumb)
        idDrink = try values.decodeIfPresent(String.self, forKey: .idDrink)
    }
}

struct Json4Swift_Base : Codable {
    var drinks : [Drinks]?

    enum CodingKeys: String, CodingKey {
        case drinks = "drinks"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self);
        drinks = try values.decodeIfPresent([Drinks].self, forKey: .drinks);
    }
}

struct Drinks : Codable {
    let idDrink : String?
    let strDrink : String?
    let strDrinkAlternate : String?
    let strTags : String?
    let strVideo : String?
    let strCategory : String?
    let strIBA : String?
    let strAlcoholic : String?
    let strGlass : String?
    let strInstructions : String?
    let strInstructionsES : String?
    let strInstructionsDE : String?
    let strInstructionsFR : String?
    let strInstructionsIT : String?

    
    let strDrinkThumb : String?
    let strIngredient1 : String?
    let strIngredient2 : String?
    let strIngredient3 : String?
    let strIngredient4 : String?
    let strIngredient5 : String?
    let strIngredient6 : String?
    let strIngredient7 : String?
    let strIngredient8 : String?
    let strIngredient9 : String?
    let strIngredient10 : String?
    let strIngredient11 : String?
    let strIngredient12 : String?
    let strIngredient13 : String?
    let strIngredient14 : String?
    let strIngredient15 : String?
    let strMeasure1 : String?
    let strMeasure2 : String?
    let strMeasure3 : String?
    let strMeasure4 : String?
    let strMeasure5 : String?
    let strMeasure6 : String?
    let strMeasure7 : String?
    let strMeasure8 : String?
    let strMeasure9 : String?
    let strMeasure10 : String?
    let strMeasure11 : String?
    let strMeasure12 : String?
    let strMeasure13 : String?
    let strMeasure14 : String?
    let strMeasure15 : String?
    let strImageSource : String?
    let strImageAttribution : String?
    let strCreativeCommonsConfirmed : String?
    let dateModified : String?
    var ingredArray = [String]();
    var measureArray = [String]();

    enum CodingKeys: String, CodingKey {

        case idDrink = "idDrink"
        case strDrink = "strDrink"
        case strDrinkAlternate = "strDrinkAlternate"
        case strTags = "strTags"
        case strVideo = "strVideo"
        case strCategory = "strCategory"
        case strIBA = "strIBA"
        case strAlcoholic = "strAlcoholic"
        case strGlass = "strGlass"
        case strInstructions = "strInstructions"
        case strInstructionsES = "strInstructionsES"
        case strInstructionsDE = "strInstructionsDE"
        case strInstructionsFR = "strInstructionsFR"
        case strInstructionsIT = "strInstructionsIT"
        
        case strDrinkThumb = "strDrinkThumb"
        case strIngredient1 = "strIngredient1"
        case strIngredient2 = "strIngredient2"
        case strIngredient3 = "strIngredient3"
        case strIngredient4 = "strIngredient4"
        case strIngredient5 = "strIngredient5"
        case strIngredient6 = "strIngredient6"
        case strIngredient7 = "strIngredient7"
        case strIngredient8 = "strIngredient8"
        case strIngredient9 = "strIngredient9"
        case strIngredient10 = "strIngredient10"
        case strIngredient11 = "strIngredient11"
        case strIngredient12 = "strIngredient12"
        case strIngredient13 = "strIngredient13"
        case strIngredient14 = "strIngredient14"
        case strIngredient15 = "strIngredient15"
        case strMeasure1 = "strMeasure1"
        case strMeasure2 = "strMeasure2"
        case strMeasure3 = "strMeasure3"
        case strMeasure4 = "strMeasure4"
        case strMeasure5 = "strMeasure5"
        case strMeasure6 = "strMeasure6"
        case strMeasure7 = "strMeasure7"
        case strMeasure8 = "strMeasure8"
        case strMeasure9 = "strMeasure9"
        case strMeasure10 = "strMeasure10"
        case strMeasure11 = "strMeasure11"
        case strMeasure12 = "strMeasure12"
        case strMeasure13 = "strMeasure13"
        case strMeasure14 = "strMeasure14"
        case strMeasure15 = "strMeasure15"
        case strImageSource = "strImageSource"
        case strImageAttribution = "strImageAttribution"
        case strCreativeCommonsConfirmed = "strCreativeCommonsConfirmed"
        case dateModified = "dateModified"
        
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idDrink = try values.decodeIfPresent(String.self, forKey: .idDrink)
        strDrink = try values.decodeIfPresent(String.self, forKey: .strDrink)
        strDrinkAlternate = try values.decodeIfPresent(String.self, forKey: .strDrinkAlternate)
        strTags = try values.decodeIfPresent(String.self, forKey: .strTags)
        strVideo = try values.decodeIfPresent(String.self, forKey: .strVideo)
        strCategory = try values.decodeIfPresent(String.self, forKey: .strCategory)
        strIBA = try values.decodeIfPresent(String.self, forKey: .strIBA)
        strAlcoholic = try values.decodeIfPresent(String.self, forKey: .strAlcoholic)
        strGlass = try values.decodeIfPresent(String.self, forKey: .strGlass)
        strInstructions = try values.decodeIfPresent(String.self, forKey: .strInstructions)
        strInstructionsES = try values.decodeIfPresent(String.self, forKey: .strInstructionsES)
        strInstructionsDE = try values.decodeIfPresent(String.self, forKey: .strInstructionsDE)
        strInstructionsFR = try values.decodeIfPresent(String.self, forKey: .strInstructionsFR)
        strInstructionsIT = try values.decodeIfPresent(String.self, forKey: .strInstructionsIT)
        
        strDrinkThumb = try values.decodeIfPresent(String.self, forKey: .strDrinkThumb)
        strIngredient1 = try values.decodeIfPresent(String.self, forKey: .strIngredient1)
        strIngredient2 = try values.decodeIfPresent(String.self, forKey: .strIngredient2)
        strIngredient3 = try values.decodeIfPresent(String.self, forKey: .strIngredient3)
        strIngredient4 = try values.decodeIfPresent(String.self, forKey: .strIngredient4)
        strIngredient5 = try values.decodeIfPresent(String.self, forKey: .strIngredient5)
        strIngredient6 = try values.decodeIfPresent(String.self, forKey: .strIngredient6)
        strIngredient7 = try values.decodeIfPresent(String.self, forKey: .strIngredient7)
        strIngredient8 = try values.decodeIfPresent(String.self, forKey: .strIngredient8)
        strIngredient9 = try values.decodeIfPresent(String.self, forKey: .strIngredient9)
        strIngredient10 = try values.decodeIfPresent(String.self, forKey: .strIngredient10)
        strIngredient11 = try values.decodeIfPresent(String.self, forKey: .strIngredient11)
        strIngredient12 = try values.decodeIfPresent(String.self, forKey: .strIngredient12)
        strIngredient13 = try values.decodeIfPresent(String.self, forKey: .strIngredient13)
        strIngredient14 = try values.decodeIfPresent(String.self, forKey: .strIngredient14)
        strIngredient15 = try values.decodeIfPresent(String.self, forKey: .strIngredient15)
        strMeasure1 = try values.decodeIfPresent(String.self, forKey: .strMeasure1)
        strMeasure2 = try values.decodeIfPresent(String.self, forKey: .strMeasure2)
        strMeasure3 = try values.decodeIfPresent(String.self, forKey: .strMeasure3)
        strMeasure4 = try values.decodeIfPresent(String.self, forKey: .strMeasure4)
        strMeasure5 = try values.decodeIfPresent(String.self, forKey: .strMeasure5)
        strMeasure6 = try values.decodeIfPresent(String.self, forKey: .strMeasure6)
        strMeasure7 = try values.decodeIfPresent(String.self, forKey: .strMeasure7)
        strMeasure8 = try values.decodeIfPresent(String.self, forKey: .strMeasure8)
        strMeasure9 = try values.decodeIfPresent(String.self, forKey: .strMeasure9)
        strMeasure10 = try values.decodeIfPresent(String.self, forKey: .strMeasure10)
        strMeasure11 = try values.decodeIfPresent(String.self, forKey: .strMeasure11)
        strMeasure12 = try values.decodeIfPresent(String.self, forKey: .strMeasure12)
        strMeasure13 = try values.decodeIfPresent(String.self, forKey: .strMeasure13)
        strMeasure14 = try values.decodeIfPresent(String.self, forKey: .strMeasure14)
        strMeasure15 = try values.decodeIfPresent(String.self, forKey: .strMeasure15)
        strImageSource = try values.decodeIfPresent(String.self, forKey: .strImageSource)
        strImageAttribution = try values.decodeIfPresent(String.self, forKey: .strImageAttribution)
        strCreativeCommonsConfirmed = try values.decodeIfPresent(String.self, forKey: .strCreativeCommonsConfirmed)
        dateModified = try values.decodeIfPresent(String.self, forKey: .dateModified)
        ingredArray.append(strIngredient1 ?? " ");
        ingredArray.append(strIngredient2 ?? " ");
        ingredArray.append(strIngredient3 ?? " ");
        ingredArray.append(strIngredient4 ?? " ");
        ingredArray.append(strIngredient5 ?? " ");
        ingredArray.append(strIngredient6 ?? " ");
        ingredArray.append(strIngredient7 ?? " ");
        ingredArray.append(strIngredient8 ?? " ");
        ingredArray.append(strIngredient9 ?? " ");
        ingredArray.append(strIngredient10 ?? " ");
        ingredArray.append(strIngredient11 ?? " ");
        ingredArray.append(strIngredient12 ?? " ");
        ingredArray.append(strIngredient13 ?? " ");
        ingredArray.append(strIngredient14 ?? " ");
        ingredArray.append(strIngredient15 ?? " ");
        
        measureArray.append(strMeasure1 ?? " ");
        measureArray.append(strMeasure2 ?? " ");
        measureArray.append(strMeasure3 ?? " ");
        measureArray.append(strMeasure4 ?? " ");
        measureArray.append(strMeasure5 ?? " ");
        measureArray.append(strMeasure6 ?? " ");
        measureArray.append(strMeasure7 ?? " ");
        measureArray.append(strMeasure8 ?? " ");
        measureArray.append(strMeasure9 ?? " ");
        measureArray.append(strMeasure10 ?? " ");
        measureArray.append(strMeasure11 ?? " ");
        measureArray.append(strMeasure12 ?? " ");
        measureArray.append(strMeasure13 ?? " ");
        measureArray.append(strMeasure14 ?? " ");
        measureArray.append(strMeasure15 ?? " ");
    }

}
