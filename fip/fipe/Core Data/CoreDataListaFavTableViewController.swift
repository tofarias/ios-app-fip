//
//  CoreDataVeiculoTableViewController.swift
//  fipe
//
//  Created by IOS SENAC on 15/06/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataListaFavTableViewController: UITableViewController
{
    var veiculos: [VeiculoEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVeiculosFromCoreData()
        
    }
    
    func getVeiculosFromCoreData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VeiculoEntity")
        
        do {
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let context = appDelegate?.persistentContainer.viewContext {
                veiculos = try context.fetch(request) as! [VeiculoEntity]
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        
        return veiculos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFav")
        
            for data in veiculos {
                if let marca = data.value(forKey: "marca") {
                    
                    cell?.textLabel?.text = veiculos[indexPath.row].marca
                }
            }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = anos[indexPath.row]
        performSegue(withIdentifier: "detalhepesquisa", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detalhepesquisa") {
            
            if let vc: DetalheViewController = segue.destination as? DetalheViewController {
                
                vc.idAno = selectedItem?.id
                vc.idMarca = idMarca
                vc.idModelo = idModelo
                vc.veiculo = veiculo
            }
            
        }
    }
}
