//
//  DetalheViewController.swift
//  fipe
//
//  Created by IOS SENAC on 01/06/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit
import CoreData

class DetalheViewController: UIViewController {

    var detalhes: Detalhe?
    var veiculo: Veiculos = .carros
//    var selectedItem: Ano?
    var idAno: String?
    var idModelo: String?
    var idMarca: String?
    var id: String?
    
    @IBOutlet weak var lMarca: UILabel!
    @IBOutlet weak var lModelo: UILabel!
    @IBOutlet weak var lAno: UILabel!
    @IBOutlet weak var lValor: UILabel!
    @IBOutlet weak var lReferencia: UILabel!
    
    @IBAction func salvarPesquisa(_ sender: Any) {
        
        // Se existe um contexto gerenciado...
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            // ou atualiza o veiculo existente...
            
                // ou, se o usuario digitou um titulo, cria um livro...
                let marca =  lMarca.text
                let modelo = lModelo.text
                let ano = lAno.text
                let valor = lValor.text
                let referencia = lReferencia.text
                
                let veiculo = VeiculoEntity.createWith(
                    marca: marca,
                    veiculo: "",
                    id: idMarca,
                    ano_modelo: ano,
                    preco: valor,
                    combustivel: "",
                    referencia: referencia,
                    fipe_codigo: "",
                    key: "",
                    nome: "nome",
                    in: context
            )
            print(veiculo)
            
        
            // ao final, salva as alteracoes do documento.
            do {
                try context.save()
            } catch let error {
                print("\(error)")
            }
        }
        // retorna a tela anterior
        //_ = navigationController?.popViewController(animated: true)
        
        
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewDetalhe()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcao que configura web service
    func loadNewDetalhe()
    {
        // Criando configuracao da sessao
        let configuration = URLSessionConfiguration.default
        
        //Alterando propriedades da configuracao
        configuration.waitsForConnectivity = true
        //Criando sessao de configuracao
        let session = URLSession(configuration: configuration)
        let url = URL(string: "http://fipeapi.appspot.com/api/1/\(veiculo.rawValue)/veiculo/\(idMarca!)/\(idModelo!)/\(idAno!).json")!
        let task = session.dataTask(with: url)
        {(data, response, error) in
            
            //Quando terminar de executar o request cai aqui
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else{
                    return
            }
            
            guard let data = data
                else {
                    return
            }
            
            if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            {
                print(result)
            }
            do
            {
                let decoder = JSONDecoder()
                let detalhes = try decoder.decode(Detalhe.self, from: data)
                DispatchQueue.main.async{
                    self.detalhes = detalhes
                    
                    self.lMarca.text = self.detalhes?.marca
                    self.lModelo.text = self.detalhes?.veiculo
                    self.lAno.text = self.detalhes?.ano_modelo
                    self.lValor.text = self.detalhes?.preco
                    self.lReferencia.text = self.detalhes?.referencia
                }
            }catch{
                print("Error\(error)")
            }
            
           
           
            
        }
        task.resume()
    }
    
    // Carregando dados na Label
    
   
    
    
    
    
//Carregando tabela
    
//    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
//        return detalhes.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetalhe")
//        cell?.textLabel?.text = detalhes[indexPath.row].referencia
//        cell?.textLabel?.text = detalhes[indexPath.row].nome
//        cell?.textLabel?.text = detalhes[indexPath.row].marca
//        cell?.textLabel?.text = detalhes[indexPath.row].ano_modelo
//        cell?.textLabel?.text = detalhes[indexPath.row].combustivel
//        cell?.textLabel?.text = detalhes[indexPath.row].preco
//        cell?.textLabel?.text = detalhes[indexPath.row].fipe_codigo
//
//        return cell!
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedItem = detalhes[indexPath.row]
//        performSegue(withIdentifier: "anopesquisa", sender: nil)
//    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "anopesquisa") {
//
//            if let vc: AnoViewController = segue.destination as? DetalheViewController {
//
//                vc.idAno = selectedItem?.id
//                vc.idModelo = idModelo
//                vc.veiculo = veiculo
//            }
//
//        }
//    }
    
    
}

struct Detalhe: Codable {
    let nome: String
    let veiculo: String?
    let id: String
    let ano_modelo: String?
    let marca: String?
    let preco: String?
    let combustivel: String?
    let referencia: String?
    let fipe_codigo: String?
    let key: String?
    
    private enum CodingKeys : String, CodingKey
    {
        case nome = "name", veiculo = "veiculo", id, ano_modelo,marca, preco, combustivel, referencia, fipe_codigo, key
    }
}
