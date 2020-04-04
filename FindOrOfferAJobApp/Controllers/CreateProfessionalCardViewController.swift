//
//  CreateProfessionalCardViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 04/04/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CreateProfessionalCardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.separatorStyle = .none
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = String.localize("create_professional_card_nav_bar")
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        
        // Do any additional setup after loading the view.
        let saveButton = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(didTapSaveCardButton))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: - Variables
    var professionSelected: String = ""
    
    // MARK: - Methods
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSaveCardButton() {
        
    }
}

extension CreateProfessionalCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
            return UITableViewCell()
        }
        
        if self.professionSelected.isEmpty {
            cell.textLabel?.text = "Selecione uma profissão..."
        } else {
            cell.textLabel?.text = self.professionSelected
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ProfessionOptionsViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let professionOptionsViewController = segue.destination as? ProfessionOptionsViewController {
            professionOptionsViewController.delegate = self
        }
    }
}

extension CreateProfessionalCardViewController: ProfessionSelectedDelegate {
    func professionSelected(profession: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.professionSelected = profession
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
