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
        case OcupationArea = "Area de atuação"
        case TimeExperience = "Tempo de experiência (em meses)"
        case Description = "Descrição da experiência"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.separatorStyle = .none
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        }
    }
    
    // MARK: - Variables
    var userProfileViewModel = UserProfileViewModel()
    var professionSelected: String = ""
    var experienceText: String = ""
    var descriptionProfession: String = ""
    var textFieldExperience: UITextField = UITextField()
    var textViewDescription: UITextView = UITextView()
    var isEditingMode: Bool = false
    var professionalCardEdit: ProfessionalCard? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isEditingMode, let card = self.professionalCardEdit {
            self.navigationItem.title = String.localize("edit_professional_card_nav_bar")
            let updateButton = UIBarButtonItem(title: "Atualizar", style: .plain, target: self, action: #selector(didTapUpdateCardButton))
            
            self.navigationItem.rightBarButtonItem = updateButton
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            self.professionSelected = card.occupationArea
            self.experienceText = card.experienceTime
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
    }
    
    @objc func didTapSaveCardButton() {
        self.view.endEditing(true)
        
        let professionalCard = ProfessionalCard(occupationArea: self.professionSelected, experienceTime: self.textFieldExperience.text ?? "", descriptionOfProfession: self.textViewDescription.text ?? "")
        
        FirebaseAuthManager().addProfessionalCard(userId: userProfileViewModel.userId, professionalCard: professionalCard) { (success) in
            if let success = success, success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Local Methods
    private func shouldEnableSaveButton() {
        if let textExp = textFieldExperience.text, let textDescript = self.textViewDescription.text, !textExp.isEmpty && !self.professionSelected.isEmpty && !textDescript.isEmpty {
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
        case 2:
            return ProfessionalQuestions.Description.rawValue
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
            self.textFieldExperience = UITextField(frame: CGRect(x: 15, y: 0, width: cell.frame.width, height: cell.frame.height))
            self.textFieldExperience.keyboardType = .numberPad
            self.textFieldExperience.placeholder = "Ex: 12"
            self.textFieldExperience.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
            self.textFieldExperience.text = self.experienceText
            
            cell.addSubview(self.textFieldExperience)
            
            return cell
        case 2:
            self.textViewDescription = UITextView(frame: CGRect(x: 15, y: 10, width: self.view.frame.width - 25, height: 200))
            
            self.textViewDescription.layer.borderWidth = 0.5
            self.textViewDescription.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            self.textViewDescription.layer.cornerRadius = 4.0
            self.textViewDescription.font = UIFont.systemFont(ofSize: 14, weight: .thin)
            self.textViewDescription.delegate = self
            self.textViewDescription.text = self.descriptionProfession
            
            cell.addSubview(self.textViewDescription)
            
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

extension CreateProfessionalCardViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.shouldEnableSaveButton()
    }
}
