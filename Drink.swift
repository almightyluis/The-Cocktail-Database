//
//  Drink.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//

import Foundation

// API KEY:  9973533


class Drink {
    
    var id: Int = 0;
    var name: String = "";
    var category: String = "";
    var instructions: String = "";
    var type: String = "";
    var ingredientsArray: [String];
    var measureArray: [String];
    var imageUrl: String = "";
    
    var clUnitArray = [String]();
    var ozUnitArray = [String]();
    var mlUnitArray = [String]();
    
    // This will be overrided if available
    var strInstructionsES: String = "Not Available";
    var strInstructionsDE: String = "Not Available";
    var strInstructionsFR: String = "Not Available";
    var strInstructionsIT: String = "Not Available";
    
    
    init(id: Int, name:String, category: String, type: String, instructions: String, ingredientsArray: [String], measureArray: [String], imageUrl: String ){
        self.id = id;
        self.name = name;
        self.type = type;
        self.measureArray = measureArray;
        self.category = category;
        self.instructions = instructions;
        self.imageUrl = imageUrl;
        self.ingredientsArray = ingredientsArray;

    }
    
    
    public func setES(str:String)->Void {self.strInstructionsES = str;}
    public func setDE(str:String)->Void {self.strInstructionsDE = str;}
    public func setFR(str:String)->Void {self.strInstructionsFR = str;}
    public func setIT(str:String)->Void {self.strInstructionsIT = str;}
    
    
    public func getES()->String {return self.strInstructionsES;}
    public func getDE()->String {return self.strInstructionsDE;}
    public func getFR()->String {return self.strInstructionsFR;}
    public func getIT()->String {return self.strInstructionsIT;}
    
    public func setType(str: String)->Void {self.type = str;}
    public func getType()->String {return self.type;}
    
    public func getId()->Int { return self.id;}
    public func setId(id:Int)->Void {self.id = id; }
    
    public func getName()->String { return self.name; }
    public func setName(name:String)->Void { self.name = name; }
    
    
    public func getCategory()->String {return self.category; }
    public func setCategory(category: String) { self.category = category; }
    
    public func getInstructions()->String { return self.instructions; }
    public func setInstructions(inst: String) {self.instructions = inst; }
    
    
    public func getImageUrl()->String { return self.imageUrl; }
    public func setImageUrl(img: String)->Void { self.imageUrl = img; }
    
    public func getIngredientsArr()->[String] { return self.ingredientsArray; }
    
    public func getMeasureArray()->[String] { return self.measureArray; }
    
    public func getToStringIngredients()->String {
        return self.correct(left: self.ingredientsArray, right: self.measureArray);
    }
    
    public func getToStringCl()->String {
        convertToCl();
        return self.correct(left: self.ingredientsArray, right: self.clUnitArray);
    }
    public func getToStringMl()->String {
        convertToMl();
        return self.correct(left: self.ingredientsArray, right: self.mlUnitArray);
    }
    public func getToStringOz()->String {
        convertToOz();
        return self.correct(left: self.ingredientsArray, right: self.ozUnitArray);
    }
    
    public func getDivisionValue(str: String)->Double {
        print("String Val", str);
        if(str.contains("/")){
            let split = str.components(separatedBy: "/");
            return Double(split[0])! / Double(split[1])!;
        }
        return Double(str)!;
    }
    /*
        Function input: String
        Return: Dimension
        Purpose: Determine the type of Dimension
     */
    public func determineCurrentUnit(str:String)->Dimension {
        switch str.lowercased() {
        case "oz":
            return UnitVolume.fluidOunces;
        case "cl":
            return UnitVolume.centiliters;
        case "ml":
            return UnitVolume.milliliters;
        default:
            print("DEF in determine unit");
            return UnitVolume.fluidOunces;
        }
    }
    
    public func getMissingString(original: String, minusOriginal: String)->String {
        return original.replacingOccurrences(of: minusOriginal, with: "");
    }
    
    /*
        Function input: none
        Return: Void
        Purpose: Using regex, convert the given value to cl.
     */
    public func convertToCl()->Void {
        let format = NumberFormatter();
        format.maximumFractionDigits = 2;

        for i in self.measureArray {
            let wordMatch = matches(for: "(\\d+|\\d/\\d|\\d\\s\\d/\\d+|\\d+.\\d+)\\s[Oocm][zllL]", in: i)
            if(wordMatch.isEmpty){
                clUnitArray.append(i);
                continue;
            }
            
            let endStringValue = getMissingString(original: i, minusOriginal: wordMatch[0]);
            
            let unitNotConverted = wordMatch[0];
            let unitSeperatedWhiteSpace = unitNotConverted.components(separatedBy: " ");
            // Must be either 2,3
            switch unitSeperatedWhiteSpace.count {
            case 2:
                let value = getDivisionValue(str: unitSeperatedWhiteSpace[0]);
                print("OG", value);
                let unit = determineCurrentUnit(str: unitSeperatedWhiteSpace[1]);
                let convertedValue = convert(value, from: unit, to: UnitVolume.centiliters);
                print("CC", convertedValue);
                let floatValue = format.string(from: NSNumber(value: convertedValue))!;
                
                clUnitArray.append(String(floatValue) + " cl" + endStringValue)
                continue;
            case 3:
                let firstValue = getDivisionValue(str: unitSeperatedWhiteSpace[0]);
                let value = getDivisionValue(str: unitSeperatedWhiteSpace[1]);
                let unit = determineCurrentUnit(str: unitSeperatedWhiteSpace[2]);
                let convertedValue = convert(firstValue + value, from: unit, to: UnitVolume.centiliters);
                let floatValue = format.string(from: NSNumber(value: convertedValue))!;
                clUnitArray.append(String(floatValue) + " cl" + endStringValue)
                continue;
            default:
                clUnitArray.append(i);
                print("DEFAULT");
                continue;
            }
            
        }
    }
    
    /*
        Function input: none
        Return: Void
        Purpose: Using regex, convert the given value to oz.
     */
    public func convertToOz()->Void {
        let format = NumberFormatter();
        format.maximumFractionDigits = 2;
        format.roundingMode = .halfDown;

        for i in self.measureArray {
            let wordMatch = matches(for: "(\\d+|\\d/\\d|\\d\\s\\d/\\d+|\\d+.\\d+)\\s[Oocm][zllL]", in: i)
            if(wordMatch.isEmpty){
                ozUnitArray.append(i);
                continue;
            }
            
            let endStringValue = getMissingString(original: i, minusOriginal: wordMatch[0]);

            let unitNotConverted = wordMatch[0];
            let unitSeperatedWhiteSpace = unitNotConverted.components(separatedBy: " ");
            // Must be either 2,3
            switch unitSeperatedWhiteSpace.count {
            case 2:
                let value = getDivisionValue(str: unitSeperatedWhiteSpace[0]);
                let unit = determineCurrentUnit(str: unitSeperatedWhiteSpace[1]);
                let convertedValue = convert(value, from: unit, to: UnitVolume.fluidOunces);
                let floatValue = format.string(from: NSNumber(value: convertedValue))!;
                print(convertedValue);
                ozUnitArray.append(String(floatValue) + " oz" + endStringValue)
                continue;
            case 3:
                let firstValue = getDivisionValue(str: unitSeperatedWhiteSpace[0]);
                let value = getDivisionValue(str: unitSeperatedWhiteSpace[1]);
                let unit = determineCurrentUnit(str: unitSeperatedWhiteSpace[2]);
                let convertedValue = convert(firstValue + value, from: unit, to: UnitVolume.fluidOunces);
                let floatValue = format.string(from: NSNumber(value: convertedValue))!;
                ozUnitArray.append(String(floatValue) + " oz" + endStringValue)
                continue;
            default:
                ozUnitArray.append(i);
                print("DEFAULT");
                continue;
            }
            
        }
    }
    
    /*
        Function input: none
        Return: Void
        Purpose: Using regex, convert the given value to ml.
     */
    public func convertToMl()->Void {
        let format = NumberFormatter();
        format.maximumFractionDigits = 2;
        format.roundingMode = .halfDown;
        
        for i in self.measureArray {
            let wordMatch = matches(for: "(\\d+|\\d/\\d|\\d\\s\\d/\\d+|\\d+.\\d+)\\s[Oocm][zllL]", in: i)
            if(wordMatch.isEmpty){
                mlUnitArray.append(i);
                continue;
            }
            let endStringValue = getMissingString(original: i, minusOriginal: wordMatch[0]);

            let unitNotConverted = wordMatch[0];
            let unitSeperatedWhiteSpace = unitNotConverted.components(separatedBy: " ");
            // Must be either 2,3
            switch unitSeperatedWhiteSpace.count {
            case 2:
                let value = getDivisionValue(str: unitSeperatedWhiteSpace[0]);
                let unit = determineCurrentUnit(str: unitSeperatedWhiteSpace[1]);
                let convertedValue = convert(value, from: unit, to: UnitVolume.milliliters);
                let floatValue = format.string(from: NSNumber(value: convertedValue))!;
                mlUnitArray.append(String(floatValue) + " ml" + endStringValue)
                continue;
            case 3:
                let firstValue = getDivisionValue(str: unitSeperatedWhiteSpace[0]);
                let value = getDivisionValue(str: unitSeperatedWhiteSpace[1]);
                let unit = determineCurrentUnit(str: unitSeperatedWhiteSpace[2]);
                let convertedValue = convert(firstValue + value, from: unit, to: UnitVolume.milliliters);
                let floatValue = format.string(from: NSNumber(value: convertedValue))!;
                mlUnitArray.append(String(floatValue) + " ml" + endStringValue)
                continue;
            default:
                mlUnitArray.append(i);
                print("DEFAULT");
                continue;
            }
            
        }
    }
    
    func convert(_ value: Double, from sourceUnit: Dimension, to targetUnit: Dimension) -> Double {
        let a = Measurement(value: value, unit: sourceUnit)
        let b = a.converted(to: targetUnit).value
        return b
    }

    func matches(for regex: String, in text: String) -> [String] {
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
        Function input: String array, String array
        Return: String
        Purpose: Append ingredients list(left) to converted values(right) to a single String.
     */
    public func correct(left: [String], right: [String])-> String {
        var str = "";
        var it = 0;
        for i in left {
            if(i == " " || i.isEmpty || i == ""){
                return str;
            }
            str += i + ": " + right[it] + "\n";
            it += 1;
        }
        return str;
    }
    
    
}
