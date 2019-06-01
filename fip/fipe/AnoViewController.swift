//
//  AnoViewController.swift
//  fipe
//
//  Created by IOS SENAC on 25/05/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit

class AnoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var anos: [Ano] = []
    var veiculo: Veiculos = .carros
    var selectedItem: Ano?
    var idAno: String?
    var idMarca: String?
    var idModelo: String?
    
   
    @IBOutlet weak var anoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewModelo()
        anoTableView.dataSource = self
        anoTableView.delegate = self
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
        let url = URL(string: "http://fipeapi.appspot.com/api/1/\(veiculo.rawValue)/veiculos/\(idMarca!)/\(idModelo!).json")!

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
                let anos = try decoder.decode([Ano].self, from: data)
                DispatchQueue.main.async{
                    self.anos = anos
                    self.anoTableView.reloadData()
                }
            }catch{
                print("Error\(error)")
            }
            
            
        }
        task.resume()
    }
    
    //Carregando tabela
    
    
    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        return anos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellModelo")
        cell?.textLabel?.text = anos[indexPath.row].nome
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = anos[indexPath.row]
        performSegue(withIdentifier: "detalhepesquisa", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detalhepesquisa") {
            
            if let vc: AnoViewController = segue.destination as? AnoViewController {
                
                vc.idAno = selectedItem?.id
                vc.idMarca = idMarca
                vc.veiculo = veiculo
            }
            
        }
    }
    
    
}

struct Ano: Codable {
    let nome: String
    let veiculo: String?
    let id: String
    
    
    private enum CodingKeys : String, CodingKey
    {
        case nome = "name", veiculo = "veiculo", id
    }
}

