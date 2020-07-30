//
//  CreateAnnounceViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 30/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CreateAnnounceViewController: UIViewController {
    
    // MARK: - Constants
    
    let descriptionTextPlaceHolder = "Breve descrição da experiência"
    
    enum AnnounceQuestions: String, CaseIterable {
        case OcupationArea = "Linguagem/Tecnologia de atuação"
        case Description = "Descrição da atividade"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
            
            self.tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: String(describing: TextViewTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: TextViewTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TextViewTableViewCell.self))

        }
    }
    
    @IBOutlet weak var buttonCreateAnnounce: UIButton! {
        didSet {
            buttonCreateAnnounce.backgroundColor = UIColor.systemBlue
            buttonCreateAnnounce.setTitle("Avançar", for: .normal)
            buttonCreateAnnounce.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
            enableSaveButton(false)
        }
    }
    
    // MARK: - Variables
    
    var professionSelected: String = ""
    var textViewDescription: UITextView = UITextView()
    var descriptionAnnounce: String = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = String.localize("announce_a_job_nav_bar")
        
        shouldEnableSaveButton()
    }
    
    // MARK: - Private Methods
    
    private func shouldEnableSaveButton() {
        if let textDescript = self.textViewDescription.text, !self.professionSelected.isEmpty && !textDescript.isEmpty {
            self.enableSaveButton(true)
        } else {
            self.enableSaveButton(false)
        }
    }
    
    private func enableSaveButton(_ value: Bool) {
        if value {
            buttonCreateAnnounce.isEnabled = true
            buttonCreateAnnounce.backgroundColor = UIColor.systemBlue
        } else {
            buttonCreateAnnounce.isEnabled = false
            buttonCreateAnnounce.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc
    private func nextButtonDidTap() {
        self.textViewDescription.resignFirstResponder()
        
        let announceJob = AnnounceJob(id: "", occupationArea: professionSelected, descriptionOfAnnounce: descriptionAnnounce)
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        if let detailViewController = storyBoard.instantiateViewController(withIdentifier: "AnnounceDetailViewController") as? AnnounceDetailViewController {
            detailViewController.announceJob = announceJob
            detailViewController.cameFromCreateAnnounce = true
            detailViewController.delegate = self
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    @objc
    private func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateAnnounceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AnnounceQuestions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return AnnounceQuestions.OcupationArea.rawValue
        case 1:
            return AnnounceQuestions.Description.rawValue
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
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
                return UITableViewCell()
            }

            if professionSelected.isEmpty {
                cell.textLabel?.text = "Selecione a técnologia de atuação..."
            } else {
                cell.textLabel?.text = professionSelected
            }
            cell.selectionStyle = .none
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextViewTableViewCell.self), for: indexPath) as? TextViewTableViewCell else {
                return UITableViewCell()
            }
            
            self.textViewDescription = cell.descriptionTextView
            cell.selectionStyle = .none
            cell.descriptionTextView.delegate = self
            cell.descriptionTextView.text = descriptionAnnounce
            cell.selectionStyle = .none
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            if let initialViewController = storyboard.instantiateViewController(withIdentifier: "ProfessionOptionsViewController") as? ProfessionOptionsViewController {
                initialViewController.delegate = self
                navigationController?.pushViewController(initialViewController, animated: true)
            }
        }

        closeKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        closeKeyboard()
    }
}

extension CreateAnnounceViewController: ProfessionSelectedDelegate {
    func professionSelected(profession: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        professionSelected = profession
        tableView.reloadRows(at: [indexPath], with: .fade)
        shouldEnableSaveButton()
    }
}

extension CreateAnnounceViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        shouldEnableSaveButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        descriptionAnnounce = textView.text
    }
}

extension CreateAnnounceViewController: ClearFieldsDelegate {
    func clearFields() {
        self.professionSelected = ""
        self.descriptionAnnounce = ""
        self.enableSaveButton(false)
        tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}
