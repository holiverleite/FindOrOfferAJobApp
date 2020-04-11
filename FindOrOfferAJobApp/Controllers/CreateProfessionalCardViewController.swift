//
//  CreateProfessionalCardViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 04/04/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CreateProfessionalCardViewController: UIViewController {
    
    enum ProfessionalQuestions: String, CaseIterable {
        case OcupationArea = "Area de atuação"
        case TimeExperience = "Tempo de experiência (em meses)"
    }

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
    var userProfileViewModel = UserProfileViewModel()
    var professionSelected: String = ""
    var textField: UITextField = UITextField()
    
    // MARK: - Methods
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSaveCardButton() {
        self.view.endEditing(true)
        
        let professionalCard = ProfessionalCard(occupationArea: self.professionSelected, experienceTime: self.textField.text ?? "")
        
        FirebaseAuthManager().addProfessionalCard(userId: userProfileViewModel.userId, professionalCard: professionalCard) { (success) in
            if let success = success, success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Local Methods
    private func shouldEnableSaveButton() {
        if let text = textField.text, !text.isEmpty && !self.professionSelected.isEmpty {
            self.enableSaveButton(true)
        } else {
            self.enableSaveButton(false)
        }
    }
    
    @objc private func textFieldDidChanged() {
        self.shouldEnableSaveButton()
    }
    
    private func enableSaveButton(_ value: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = value
    }
}

extension CreateProfessionalCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfessionalQuestions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ProfessionalQuestions.OcupationArea.rawValue
        case 1:
            return ProfessionalQuestions.TimeExperience.rawValue
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            if self.professionSelected.isEmpty {
                cell.textLabel?.text = "Selecione uma profissão..."
            } else {
                cell.textLabel?.text = self.professionSelected
            }
            
            return cell
        case 1:
            self.textField = UITextField(frame: CGRect(x: 15, y: 10, width: cell.frame.width, height: cell.frame.height))
            self.textField.keyboardType = .numberPad
            self.textField.placeholder = "Ex: 12"
            self.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
            
            cell.addSubview(self.textField)
            
            return cell
        default:
            return UITableViewCell()
        }
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
        self.shouldEnableSaveButton()
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.professionSelected = profession
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
