//
//  ListaFavoritosViewController.swift
//  fipe
//
//  Created by IOS SENAC on 01/06/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit
import CoreData

class ListaFavoritosViewController: CoreDataTableViewController
{
    var fetchedResultsController: NSFetchedResultsController<Livro>? {
        didSet {
            try? refreshData(for: fetchedResultsController)
        }
    }
    
    // MARK: - CoreDataTableViewController FetchedResultsController setup
    
    override func updateRequest()
    {
        let request = NSFetchRequest<Livro>(entityName: "Veiculo")
        request.sortDescriptors = [ NSSortDescriptor(key: "titulo", ascending: true) ]
        
        fetchedResultsController = getFetchedResultsController(for: request)
    }
    
    // MARK: - UITableView Cell Render
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let livro = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = livro.titulo
            cell.detailTextLabel?.text = livro.editora
        }
        
        return cell
    }
    
    override func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetalheLivroController {
            destination.managedObjectContext = container?.viewContext
            if segue.identifier == "" {
                destination.livro = nil
            } else
                if let indexPath = tableView.indexPathForSelectedRow,
                    let livro = fetchedResultsController?.object(at: indexPath) {
                    destination.livro = livro
            }
        }
    }
    
}
