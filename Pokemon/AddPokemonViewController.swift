//
//  AddPokemonViewController.swift
//  Pokemon
//
//  Created by rem{e}koh on 11/2/16.
//  Copyright © 2016 rem{e}koh. All rights reserved.
//

import UIKit
import MapKit


protocol AddPokemonViewControllerDelegate: class {
    
    func addPokemonViewControllerDelegateDidAddPokemon(pokemon: Pokemon)
    
}

//var pokemons = [Pokemon]()


class AddPokemonViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var newPokemonName : UITextField!
    @IBOutlet weak var newPokemonImage : UITextField!
    
    var newlatitude :Double!
    var newlongitude :Double!
    
    var newLatitudeLabel :UILabel!
    var newLongitudeLabel :UILabel!
    
    
    var coordinate: CLLocationCoordinate2D!
    
    
    weak var delegate: AddPokemonViewControllerDelegate!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.locationManager = CLLocationManager()
//        self.locationManager.delegate = self
//        
//        self.locationManager.startUpdatingLocation()
        
        newLatitudeLabel?.text = "\(self.coordinate.latitude)"
        newLongitudeLabel?.text = "\(self.coordinate.longitude)"
        
    }
    
    @IBAction func AddNewPokemonButtonWasPressed(_ sender: AnyObject) {
        
        newlatitude = self.coordinate.latitude
        newlongitude = self.coordinate.longitude
        
        let newPokemon = Pokemon()
        newPokemon.name = newPokemonName.text!
        newPokemon.imageURL = newPokemonImage.text!
        newPokemon.latitude = newlatitude
        newPokemon.longitude = newlongitude
        
        // add Location using Core Location
        
        
        let tacoURL = "https://still-wave-26435.herokuapp.com/pokemon"
        
        let postURL = URL(string: tacoURL)
        
        var request = URLRequest(url: postURL!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let pokemonDictionary = ["name" : newPokemonName.text!, "imageURL": newPokemonImage.text!,"latitude" :newPokemon.latitude, "longitude" :newPokemon.longitude] as [String: Any]
        
        let pokemonDictionaryData = try! JSONSerialization.data(withJSONObject: pokemonDictionary, options: .prettyPrinted)
        
        request.httpBody = pokemonDictionaryData
        
        URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
         
            print(error?.localizedDescription)
            
        }.resume()
 
        
        
        self.delegate.addPokemonViewControllerDelegateDidAddPokemon(pokemon: newPokemon)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
