//
//  Veiculo.swift
//  fipe
//
//  Created by IOS SENAC on 15/06/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import Foundation
import CoreData

public class VeiculoEntity: NSManagedObject {
    
    class func createWith(marca: String?, veiculo: String?, id: String?, ano_modelo: String?, preco: String?, combustivel: String?, referencia: String?, fipe_codigo: String?, key: String?, nome: String?, in context: NSManagedObjectContext) -> VeiculoEntity? {
        let request = NSFetchRequest<VeiculoEntity>(entityName: "VeiculoEntity")
        //let query = "titulo == %@"
        //let params = [ titulo ]
        
        
        //request.predicate = NSPredicate(format: query, argumentArray: params)
        
        // tenta recuperar o veiculo
        //if let veiculo = (try? context.fetch(request))?.first {
        //    return veiculo
        // }
        // senao cria o veiculo
        if let veiculo = NSEntityDescription.insertNewObject(forEntityName: "VeiculoEntity", into: context) as? VeiculoEntity {
            veiculo.nome =  nome
            veiculo.marca = marca
            veiculo.id = id
            veiculo.ano_modelo = ano_modelo
            veiculo.preco = preco
            veiculo.combustivel = combustivel
            veiculo.referencia = referencia
            veiculo.fipe_codigo = fipe_codigo
            veiculo.key = key
            
            return veiculo
        }
        // em caso de erro...
        return nil
    }
}
