//
//  CreateProfessionalCardViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 04/04/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CreateProfessionalCardViewController: UIViewController {
    
    let descriptionTextPlaceHolder = "Breve descrição da experiência"
    
    enum ProfessionalQuestions: String, CaseIterable {
        case OcupationArea = "Área de atuação"
        case Description = "Descrição da experiência"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
            
            self.tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: String(describing: TextViewTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: TextViewTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TextViewTableViewCell.self))
        }
    }
    
    // MARK: - Variables
    var userProfileViewModel = UserProfileViewModel()
    var professionSelected: String = ""
    var experienceText: String = ""
    var descriptionProfession: String = ""
//    var textFieldExperience: UITextField = UITextField()
    var textViewDescription: UITextView = UITextView()
    var isEditingMode: Bool = false
    var occupationAreaAlreadyCreated: [String] = []
    var professionalCardEdit: ProfessionalCard? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isEditingMode, let card = self.professionalCardEdit {
            self.navigationItem.title = String.localize("edit_professional_card_nav_bar")
            let updateButton = UIBarButtonItem(title: "Atualizar", style: .plain, target: self, action: #selector(didTapUpdateCardButton))
            
            self.navigationItem.rightBarButtonItem = updateButton
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            self.professionSelected = card.occupationArea
            self.descriptionProfession = card.descriptionOfProfession
            
        } else {
            self.navigationItem.title = String.localize("create_professional_card_nav_bar")
            
            let saveButton = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(didTapSaveCardButton))
            self.navigationItem.rightBarButtonItem = saveButton
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
    }
    
    // MARK: - Methods
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapUpdateCardButton() {
        self.view.endEditing(true)
        
        if let professionalCard = self.professionalCardEdit {
            let professionalCard = ProfessionalCard(id: professionalCard.id, occupationArea: self.professionSelected, descriptionOfProfession: self.textViewDescription.text ?? "")
            
            FirebaseAuthManager().updateProfessionalCard(userId: userProfileViewModel.userId, card: professionalCard, completion: { (success) in
                if let success = success, success {
                    let alert = UIAlertController(title: "Sucesso", message: "Cartão Profissional atualizado com sucesso!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @objc func didTapSaveCardButton() {
        self.view.endEditing(true)
        
        let professionalCard = ProfessionalCard(id: "", occupationArea: self.professionSelected, descriptionOfProfession: self.textViewDescription.text ?? "")
        
        FirebaseAuthManager().addProfessionalCard(userId: userProfileViewModel.userId, professionalCard: professionalCard) { (success) in
            if let success = success, success {
                let alert = UIAlertController(title: "Sucesso", message: "Cartão Profissional criado com sucesso!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Local Methods
    private func shouldEnableSaveButton() {
        if self.isEditingMode {
            if let textDescript = self.textViewDescription.text, let descriptionTextView = self.professionalCardEdit?.descriptionOfProfession, textDescript != descriptionTextView {
                self.enableSaveButton(true)
            } else {
                self.enableSaveButton(false)
            }
        } else {
            if let textDescript = self.textViewDescription.text, !self.professionSelected.isEmpty && !textDescript.isEmpty {
                self.enableSaveButton(true)
            } else {
                self.enableSaveButton(false)
            }
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
            return ProfessionalQuestions.Description.rawValue
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50.0
        case 1:
            return 220.0
        default:
            return 0.0
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
            cell.selectionStyle = .none
            if self.professionSelected.isEmpty {
                cell.textLabel?.text = "Selecione uma tecnologia..."
            } else {
                cell.textLabel?.text = self.professionSelected
            }
            
            return cell
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextViewTableViewCell.self), for: indexPath) as? TextViewTableViewCell else {
                return UITableViewCell()
            }

            self.textViewDescription = cell.descriptionTextView
            cell.descriptionTextView.delegate = self
            cell.descriptionTextView.text = self.descriptionProfession
            
            return cell
            
//            self.textFieldExperience = UITextField(frame: CGRect(x: 15, y: 0, width: cell.frame.width, height: cell.frame.height))
//            self.textFieldExperience.keyboardType = .numberPad
//            self.textFieldExperience.placeholder = "Ex: 12"
//            self.textFieldExperience.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
//            self.textFieldExperience.text = self.experienceText
//
//            cell.addSubview(self.textFieldExperience)
            
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
            professionOptionsViewController.occupationAreaAlreadyCreated = occupationAreaAlreadyCreated
        }
    }
}

extension CreateProfessionalCardViewController: ProfessionSelectedDelegate {
    func professionSelected(profession: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.professionSelected = profession
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.shouldEnableSaveButton()
    }
}

extension CreateProfessionalCardViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.shouldEnableSaveButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        descriptionProfession = textView.text
    }
}
