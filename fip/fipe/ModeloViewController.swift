//
//  ModeloViewController.swift
//  fipe
//
//  Created by IOS SENAC on 25/05/19.
//  Copyright © 2019 IOS SENAC. All rights reserved.
//

import UIKit

class ModeloViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var modelos:  [Modelo] = []
    var veiculo: Veiculos = .carros
    var selectedItem: Modelo?
    var idMarca: String?
    var idModelo: String?
    
    @IBOutlet weak var modeloTableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewModelo()
        modeloTableView.dataSource = self
        modeloTableView.delegate = self
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
        let url = URL(string: "http://fipeapi.appspot.com/api/1/\(veiculo.rawValue)/veiculos/\(idMarca!).json")!
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
                let modelos = try decoder.decode([Modelo].self, from: data)
                DispatchQueue.main.async{
                    self.modelos = modelos
                    self.modeloTableView.reloadData()
                }
            }catch{
                print("Error\(error)")
            }


        }
        task.resume()
    }

    //Carregando tabela


    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int {
        return modelos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellModelo")
        cell?.textLabel?.text = modelos[indexPath.row].nome
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = modelos[indexPath.row]
        performSegue(withIdentifier: "anopesquisa", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "anopesquisa") {

            if let vc: ModeloViewController = segue.destination as? ModeloViewController {

                vc.idModelo = selectedItem?.id
                vc.idMarca = idMarca
                vc.veiculo = veiculo
            }

        }
    }

    
}

struct Modelo: Codable {
    let nome: String
    let fipeNome: String?
    let id: String
    
    
    private enum CodingKeys : String, CodingKey
    {
        case nome = "name", fipeNome = "fipe_name", id
    }
}


