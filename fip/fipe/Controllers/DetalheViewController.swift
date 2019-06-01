//
//  DetalheViewController.swift
//  fipe
//
//  Created by IOS SENAC on 01/06/2019.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit
import CoreData

class DetalheViewController : UIViewController {
    
    weak var managedObjectContext: NSManagedObjectContext?
    
    weak var veiculo: Veiculo?{
        didSet{
            //updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateUI()
    }
    
    @IBAction func favoritar(_sender: UIBarButtonItem){
        // Se existe um contexto gerenciado...
        if let context = managedObjectContext {
            // ou atualiza o livro existente...
            if let book = livro {
                book.titulo = tituloEdit.text
                book.editora = editoraEdit.text
                if let anoText = anoEdit.text,
                    let ano = Int16(anoText)
                {
                    book.ano = ano
                }
            } else {
                // ou, se o usuario digitou um titulo, cria um livro...
                if let titulo = tituloEdit.text
                {
                    let editora = editoraEdit.text
                    var ano: Int16? = nil
                    if let anoText = anoEdit.text {
                        ano = Int16(anoText)
                    }
                    let _ = Veiculo.createWith(titulo: titulo,
                                             editora: editora,
                                             ano: ano,
                                             in: context)
                }
            }
            // ao final, salva as alteracoes do documento.
            do {
                try context.save()
            } catch let error {
                print("\(error)")
            }
        }
        // retorna a tela anterior
        _ = navigationController?.popViewController(animated: true)
    }
}
