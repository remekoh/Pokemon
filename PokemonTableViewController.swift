//
//  PokemonTableViewController.swift
//  Pokemon
//
//  Created by rem{e}koh on 10/31/16.
//  Copyright © 2016 rem{e}koh. All rights reserved.
//

import UIKit

class Pokemon: NSObject {
    
    var id: Int = 0
    var name: String!
    var imageURL: String!
    
}

class PokemonTableViewController: UITableViewController {
    
    var pokemons : [Pokemon]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
            populateTableView()
            
    }
        
        fileprivate func populateTableView() {
            
            self.pokemons = [Pokemon]()
            
            let pokemonsURL = "https://still-wave-26435.herokuapp.com/pokemon/all"
            
            let url = URL(string: pokemonsURL)
            
            DispatchQueue.main.async {
            
                URLSession.shared.dataTask(with: url!) { (data : Data?, response: URLResponse?, error: Error?) in
                    
                    let result = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
                    
                    for item in result {
                        
                        let pokemon = Pokemon()
                        pokemon.id = item["id"] as! Int
                        pokemon.name = item["name"] as! String
                        pokemon.imageURL = item["imageURL"] as! String
                        
                        self.pokemons.append(pokemon)
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }.resume()
            }
            
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.pokemons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonDisplayCell", for: indexPath)

        let pokemon = self.pokemons[indexPath.row]
        
        cell.textLabel?.text = pokemon.name
        cell.detailTextLabel?.text = "\(pokemon.id)"
        
        let imageData = try! Data(contentsOf: URL(string: pokemon.imageURL)!)
        
        cell.imageView?.image = UIImage(data: imageData)

        return cell
    }

}
