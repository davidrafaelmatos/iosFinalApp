//
//  MakeData.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

public class MakeData {
    
    // variables
    var makeArray: [Make] = []
    public var makeNomeArray: [String] = []
    
    public func MakeData() {
        let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/getallmakes?format=json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(MakeReturn.self, from: data)
                DispatchQueue.main.async {
                    self.makeArray = response.Results
                    print(self.makeArray)
                }
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
    }
    
    private func retreiveName(){
        for make in makeArray{
            makeNomeArray.append(make.Make_Name)
        }
    }
    
}
