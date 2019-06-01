//
//  Veiculo.swift
//  fipe
//
//  Created by IOS SENAC on 01/06/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import Foundation
import CoreData

public class Veivulo: NSManagedObject{
    
    class func createWith(titulo: String, editora: String?, ano: Int16?, in context: NSManagedObjectContext) -> Veiculo? {
        let request = NSFetchRequest<Veiculo>(entityName: "VeiculoEntity")
        let query = "titulo == %@"
        let params = [ titulo ]
        
        request.predicate = NSPredicate(format: query, argumentArray: params)
        
        // tenta recuperar o livro
        if let livro = (try? context.fetch(request))?.first {
            return livro
        }
        // senao cria o livro
        if let livro = NSEntityDescription.insertNewObject(forEntityName: "VeiculoEntity", into: context) as? Livro {
            livro.titulo = titulo
            livro.editora = editora
            livro.ano = ano ?? 0
            return livro
        }
        // em caso de erro...
        return nil
    }
}
