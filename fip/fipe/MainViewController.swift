//
//  ViewController.swift
//  fip
//
//  Created by IOS SENAC on 25/05/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit



class MainViewController: UIViewController {
    
    var veiculo: Veiculos = .carros
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionCaminhao(_ sender: UIButton) {
        
        veiculo = .caminhoes
        performSegue(withIdentifier: "formpesquisa", sender: self)
    }
    

    @IBAction func actionCarro(_ sender: UIButton) {
        
        veiculo = .carros
        performSegue(withIdentifier: "formpesquisa", sender: self)
    }
    
    @IBAction func actionMoto(_ sender: Any) {
        
        veiculo = .motos
        performSegue(withIdentifier: "formpesquisa", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "formpesquisa") {
            
            if let vc: FormPesquisaViewController = segue.destination as? FormPesquisaViewController {
                vc.veiculo = veiculo
            }
            
        }
    }
}

enum Veiculos :String{
    case caminhoes
    case carros
    case motos
}

