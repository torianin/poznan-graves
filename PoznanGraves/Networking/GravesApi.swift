//
//  GravesApi.swift
//  PoznanGraves
//
//  Created by Robert Ignasiak on 21.05.2017.
//  Copyright © 2017 Torianin. All rights reserved.
//

import Foundation
import MapKit
import CoreData

enum GravesApiEndpoint : String {
    case AllGraves = "all.json"
}

class GravesApi {
    private var baseApiPath:String!

    init() {
        self.baseApiPath = ApiConfig.baseURL
    }
    
    func getGraves( completion: @escaping () -> Void) {


        guard let url = URL(string: baseApiPath + GravesApiEndpoint.AllGraves.rawValue) else
        {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            if error == nil && data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    
                    if let featuresArray = json["features"] as? NSArray {
                        for feature in featuresArray {
                            
                            let grave = Grave(context:context)

                            if let featureDict = feature as? NSDictionary {

                                if let geometryDict = featureDict["geometry"] as? NSDictionary{
                                    if let coordinatesArray = geometryDict["coordinates"] as? NSArray {
                                        if let coordinas = coordinatesArray[0] as? NSArray {
                                            grave.latitude = coordinas[1] as? NSNumber
                                            grave.longitude = coordinas[0] as? NSNumber
                                        }
                                    }
                                }
                                
                                if let propertiesDict = featureDict["properties"] as? NSDictionary{
                                    
                                    if propertiesDict["print_name"] as? String == "" {
                                        grave.printName = NSLocalizedString("unknown_data_text" , comment: "")
                                    } else {
                                        grave.printName = propertiesDict["print_name"] as? String
                                    }
                                    
                                    if propertiesDict["print_surname"] as? String == "" {
                                        grave.printSurname = NSLocalizedString("unknown_data_text" , comment: "")
                                    } else {
                                        grave.printSurname = propertiesDict["print_surname"] as? String
                                    }
                                    
                                    grave.birthDate = propertiesDict["g_date_birth"] as? String
                                    grave.deathDate = propertiesDict["g_date_death"] as? String
                                    
                                    grave.quarter = propertiesDict["g_quarter"] as? String
                                    grave.row = propertiesDict["g_row"] as? String
                                    grave.place = propertiesDict["g_place"] as? String
                                    
                                    if propertiesDict["paid"] as? Int == 1 {
                                        grave.paid = true
                                    } else if propertiesDict["paid"] as? Int == -1 {
                                        grave.paid = false
                                    } else {
                                        grave.paid = false
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            else if error != nil
            {
                print(error ?? "Error")
            }
            completion()
            
        }).resume()
    }
}
