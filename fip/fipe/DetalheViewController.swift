//
//  DetalheViewController.swift
//  fipe
//
//  Created by IOS SENAC on 01/06/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit

class DetalheViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var detalhes: [Detalhe] = []
    var veiculo: Veiculos = .carros
    var selectedItem: Ano?
    var idAno: String?
    var idModelo: String?
    
    
    @IBOutlet weak var detalheTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewModelo()
        detalheTableView.dataSource = self
        detalheTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcao que configura web service
    func loadNewModelo()
    {
        // Criando configuracao da sessao
        let configuration = URLSessionConfiguration.default
        
        //Alterando propriedades da configuracao
        configuration.waitsForConnectivity = true
        //Criando sessao de configuracao
        let session = URLSession(configuration: configuration)
        let url = URL(string: "http://fipeapi.appspot.com/api/1/\(veiculo.rawValue)/veiculos/\(idModelo!)/\(idAno!).json")!
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
                let detalhes = try decoder.decode([Detalhe].self, from: data)
                DispatchQueue.main.async{
                    self.detalhes = detalhes
                    self.detalheTableView.reloadData()
                }
            }catch{
                print("Error\(error)")
            }
            
            
        }
        task.resume()
    }
    
    //Carregando tabela
    
    
    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        return detalhes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellModelo")
        cell?.textLabel?.text = detalhes[indexPath.row].nome
        return cell!
    }
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
