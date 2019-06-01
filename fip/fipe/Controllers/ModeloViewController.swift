//
//  ModeloViewController.swift
//  fipe
//
//  Created by IOS SENAC on 25/05/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit

class ModeloViewController: UIViewController {

    var idModelo: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

struct Marcas: Codable {
    let nome: String
    let fipeNome: String?
    let id: Int
    
    
    private enum CodingKeys : String, CodingKey
    {
        case nome = "name", fipeNome = "fipe_name", id
    }
}


