//
//  FormPesquisaViewController.swift
//  fip
//
//  Created by IOS SENAC on 25/05/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit

class MarcaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var veiculo: Veiculos = .carros
    
    @IBOutlet weak var VeiculosTableView: UITableView!
    var selectedItem: Veiculo?

    var veiculos: [Veiculo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewVeiculo()
        VeiculosTableView.dataSource = self
        VeiculosTableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcao que configura web service
    func loadNewVeiculo()
    {
        // Criando configuracao da sessao
        let configuration = URLSessionConfiguration.default
        
        //Alterando propriedades da configuracao
        configuration.waitsForConnectivity = true
        //Criando sessao de configuracao
        let session = URLSession(configuration: configuration)
        let url = URL(string: "http://fipeapi.appspot.com/api/1/\(veiculo.rawValue)/marcas.json")!
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
                let veiculos = try decoder.decode([Veiculo].self, from: data)
                DispatchQueue.main.async{
                    self.veiculos = veiculos
                    self.VeiculosTableView.reloadData()
                }
            }catch{
                print("Error\(error)")
            }
            
            
        }
        task.resume()
    }
    
    //Carregando tabela
    
    
    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        return veiculos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
        cell?.textLabel?.text = veiculos[indexPath.row].nome
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = veiculos[indexPath.row]
        performSegue(withIdentifier: "modelopesquisa", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "modelopesquisa") {
            
            if let vc: ModeloViewController = segue.destination as? ModeloViewController {
                
                vc.idModelo = selectedItem?.id
            }
            
        }
    }
    
    
}


struct Veiculo: Codable {
    let nome: String
    let fipeNome: String?
    let id: Int
    
    
    private enum CodingKeys : String, CodingKey
    {
        case nome = "name", fipeNome = "fipe_name", id
    }
}
