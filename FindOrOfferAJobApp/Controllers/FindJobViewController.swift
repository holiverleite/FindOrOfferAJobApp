//
//  FindJobViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 09/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class FindJobViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "Atenção", message: "Você precisa cadastrar suas habilidades em seus Dados Profissionais para poder ter acesso às vagas ofertadas. Clique em Continuar para ser redirecionado para seu perfil.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (_) in
            self.tabBarController?.selectedIndex = 0
        }))
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { (action) in
            self.tabBarController?.selectedIndex = 4
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
