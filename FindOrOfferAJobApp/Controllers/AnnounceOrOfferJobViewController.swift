//
//  AnnounceOrOfferJobViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 09/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class AnnounceOrOfferJobViewController: UIViewController {
    
    // MARK: - Constants
    
    let descriptionTextPlaceHolder = "Breve descrição da experiência"
    
    enum AnnounceQuestions: String, CaseIterable {
        case OcupationArea = "Área de atuação do trabalhador"
        case Description = "Descrição da atividade"
        case TimeExperience = "Tempo de experiência (em meses)"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.addTarget(self, action: #selector(segmentedControlDidChanged), for: .valueChanged)
        }
    }
    
    // MARK: - Variables
    var professionSelected: String = ""
    var textViewDescription: UITextView = UITextView()
    var saveButton: UIButton =  UIButton()
    var descriptionAnnounce: String = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            navigationController?.navigationBar.topItem?.title = String.localize("find_a_job_nav_bar")
            view.bringSubviewToFront(emptyView)
        } else {
            navigationController?.navigationBar.topItem?.title = String.localize("announce_a_job_nav_bar")
            view.bringSubviewToFront(tableView)
        }
        
//        tableView.reloadData()
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
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.systemBlue
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc
    private func saveButtonDidTap() {
        
        let userProfileViewModel = UserProfileViewModel()
        let announceJob = AnnounceJob(id: "", occupationArea: professionSelected, descriptionOfAnnounce: descriptionAnnounce)
        
        FirebaseAuthManager().addAnnounceJob(userId: userProfileViewModel.userId, announceJob: announceJob) { (success) in
            if let success = success, success {
                let alert = UIAlertController(title: "Sucesso", message: "Anúncio publicado com sucesso!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    self.professionSelected = ""
                    self.descriptionAnnounce = ""
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc
    private func segmentedControlDidChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            navigationController?.navigationBar.topItem?.title = String.localize("find_a_job_nav_bar")
            view.bringSubviewToFront(emptyView)
        } else {
            navigationController?.navigationBar.topItem?.title = String.localize("announce_a_job_nav_bar")
            view.bringSubviewToFront(tableView)
        }
        
        tableView.reloadData()
    }
    
    @objc
    private func closeKeyboard() {
        view.endEditing(true)
    }
}

extension AnnounceOrOfferJobViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 1
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            return AnnounceQuestions.allCases.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 0 {
            return ""
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            switch section {
            case 0:
                return AnnounceQuestions.OcupationArea.rawValue
            case 1:
                return AnnounceQuestions.Description.rawValue
            default:
                return ""
            }
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 0
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            switch indexPath.section {
            case 0:
                return 50.0
            case 1:
                return 220.0
            case 2:
                return 70.0
            default:
                return 50.0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 0
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return UITableViewCell()
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            
            switch indexPath.section {
            case 0:
                if professionSelected.isEmpty {
                    cell.textLabel?.text = "Selecione a área de atuação..."
                } else {
                    cell.textLabel?.text = professionSelected
                }
                
                return cell
            case 1:
                textViewDescription = UITextView(frame: CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: tableView.frame.width, height: 200)))
                
                textViewDescription.layer.borderWidth = 0.5
                textViewDescription.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                textViewDescription.layer.cornerRadius = 4.0
                textViewDescription.font = UIFont.systemFont(ofSize: 14, weight: .thin)
                textViewDescription.delegate = self
                textViewDescription.text = descriptionAnnounce
                
                cell.addSubview(textViewDescription)
                
                return cell
            case 2:
                saveButton = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: tableView.frame.width, height: 50)))
                
                enableSaveButton(false)
                
                saveButton.setTitle("Anunciar", for: .normal)
                saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
                
                cell.addSubview(saveButton)
                
                return cell
            default:
                return UITableViewCell()
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentedControl.selectedSegmentIndex == 0 {

        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            if indexPath.section == 0 {
                let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                if let initialViewController = storyboard.instantiateViewController(withIdentifier: "ProfessionOptionsViewController") as? ProfessionOptionsViewController {
                    initialViewController.delegate = self
                    navigationController?.pushViewController(initialViewController, animated: true)
                }
            }
        }

        closeKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeKeyboard()
    }
}

extension AnnounceOrOfferJobViewController: ProfessionSelectedDelegate {
    func professionSelected(profession: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        professionSelected = profession
        tableView.reloadRows(at: [indexPath], with: .fade)
        shouldEnableSaveButton()
    }
}

extension AnnounceOrOfferJobViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        shouldEnableSaveButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        descriptionAnnounce = textView.text
    }
}
