//
//  EditProfessionalDataViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo on 31/03/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class EditProfessionalDataViewController: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            self.tableview.delegate = self
            self.tableview.dataSource = self
            
            self.tableview.register(ProfessionalCardTableViewCell.self, forCellReuseIdentifier: String(describing: ProfessionalCardTableViewCell.self))
            self.tableview.register(UINib(nibName: String(describing: ProfessionalCardTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProfessionalCardTableViewCell.self))
            
            self.tableview.separatorStyle = .none
        }
    }
    
    // MARK: - Variables
    var userProfileViewModel = UserProfileViewModel()
    var professionalCards: [ProfessionalCard] = []
    var occupationAreaCArds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = String.localize("edit_professional_profile_nav_bar")
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        // Do any additional setup after loading the view.
        let createButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(didTapCreateProfessionalCardButton))
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldShowActivity(true)
        FirebaseAuthManager().retrieveProfessionalCards(userId: self.userProfileViewModel.userId) { (professionalCards) in
            self.shouldShowActivity(false)
            if professionalCards.count > 0 {
                
                professionalCards.forEach { (card) in
                    self.occupationAreaCArds.append(card.occupationArea)
                }
                
                self.emptyView.isHidden = true
                self.professionalCards.removeAll()
                self.professionalCards.append(contentsOf: professionalCards)
                self.tableview.isHidden = false
                self.view.bringSubviewToFront(self.tableview)
                self.tableview.reloadData()
            } else {
                self.view.bringSubviewToFront(self.emptyView)
            }
        }
        
        self.tableview.reloadData()
    }
    
    // MARK: - Methods
    @objc func didTapCreateProfessionalCardButton() {
        // did tap save
        self.performSegue(withIdentifier: "CreateProfessionalCardViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderIndex = sender as? IndexPath {
            if let editProfessionalCard = segue.destination as? CreateProfessionalCardViewController {
                editProfessionalCard.isEditingMode = true
                editProfessionalCard.userProfileViewModel = self.userProfileViewModel
                editProfessionalCard.professionalCardEdit = self.professionalCards[senderIndex.row]
                editProfessionalCard.occupationAreaAlreadyCreated = occupationAreaCArds.filter() {
                    $0 != self.professionalCards[senderIndex.row].occupationArea
                }
            }
        } else if let createProfessionalCard = segue.destination as? CreateProfessionalCardViewController {
            createProfessionalCard.userProfileViewModel = self.userProfileViewModel
            createProfessionalCard.occupationAreaAlreadyCreated = occupationAreaCArds
        }
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func shouldShowActivity(_ status: Bool) {
        if status {
            emptyView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            emptyView.isHidden = false
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
}

extension EditProfessionalDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.professionalCards.count == 0 {
            self.tableview.isHidden = true
        } else {
            self.tableview.isHidden = false
        }
        
        return self.professionalCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfessionalCardTableViewCell.self), for: indexPath) as? ProfessionalCardTableViewCell else {
            fatalError("ProfessionalCardTableViewCell not found!")
        }
        
        let card = self.professionalCards[indexPath.row]
        
        cell.setValues(professionaltitle: card.occupationArea, exp: card.experienceTime, professionDescription: card.descriptionOfProfession)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CreateProfessionalCardViewController", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Atenção", message: "Realmente deseja deletar este item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action) in
            if editingStyle == .delete {
                let professionalCard = self.professionalCards[indexPath.row]
                FirebaseAuthManager().deleteProfessionalCard(userId: self.userProfileViewModel.userId, cardId: professionalCard.id) { (success) in
                    if let success = success, success {
                        self.professionalCards.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        let alert = UIAlertController(title: "Atenção", message: "Não foi possível deletar este item.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
