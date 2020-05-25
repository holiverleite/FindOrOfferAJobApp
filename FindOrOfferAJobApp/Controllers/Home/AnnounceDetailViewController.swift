//
//  AnnounceDetailViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 24/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class AnnounceDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.register(AnnounceDetailResumeTableViewCell.self, forCellReuseIdentifier: String(describing: AnnounceDetailResumeTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: AnnounceDetailResumeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AnnounceDetailResumeTableViewCell.self))
            
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
            
            self.tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var buttonSaveAnnounce: UIButton! {
        didSet {
            self.buttonSaveAnnounce.setTitle("Anunciar", for: .normal)
            self.buttonSaveAnnounce.backgroundColor = UIColor.systemBlue
            self.buttonSaveAnnounce.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint! {
        didSet {
            if cameFromCreateAnnounce {
                self.buttonHeightConstraint.constant = 55
            } else {
                self.buttonHeightConstraint.constant = 0
            }
        }
    }
    
    // MARK: - Variables
    
    var announceJob: AnnounceJob?
    var cameFromCreateAnnounce: Bool = false
    var delegate: ClearFieldsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = String.localize("announce_detail_nav_bar")
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        
        if cameFromCreateAnnounce {
            let alert = UIAlertController(title: "Atenção", message: "Confira os dados do anúncio com atenção antes de finalizar. Eles não poderão ser alterados posteriormente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.buttonSaveAnnounce.isHidden = false
        } else {
            self.buttonSaveAnnounce.isHidden = true
        }
    }
    
    // MARK: - Methods
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapSaveButton() {
        let userProfileViewModel = UserProfileViewModel()
        
        if let announceJob = self.announceJob {
            FirebaseAuthManager().addAnnounceJob(userId: userProfileViewModel.userId, announceJob: announceJob) { (success) in
                if let success = success, success {
                    let alert = UIAlertController(title: "Sucesso", message: "Anúncio publicado com sucesso!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.delegate?.clearFields()
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension AnnounceDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if cameFromCreateAnnounce {
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Resumo do anúncio"
        case 1:
            return "Candidatos à vaga"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnnounceDetailResumeTableViewCell.self), for: indexPath) as? AnnounceDetailResumeTableViewCell else {
                fatalError("AnnounceDetailResumeTableViewCell not found!")
            }
            
            cell.selectionStyle = .none
            
            let startDate = Date()
            let finishDate = Calendar.current.date(byAdding: .day, value: 3, to: startDate)!
            
            announceJob?.startTimestamp = startDate.timeIntervalSince1970
            announceJob?.finishTimestamp = finishDate.timeIntervalSince1970
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd/MM/yyy 'às' HH:mm"
            
            let startDateFormatter = dateFormatter.string(from: startDate)
            cell.startAnnounceDate.text = startDateFormatter
            cell.startAnnounceDate?.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
            
            let finishDateFormatter = dateFormatter.string(from: finishDate)
            cell.finalAnnounceDate.text = finishDateFormatter
            cell.finalAnnounceDate?.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
            
            cell.professionalArea.text = announceJob?.occupationArea
            cell.professionalArea?.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
            
            cell.announceDescription.text = announceJob?.descriptionOfAnnounce
            cell.announceDescription?.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
                return UITableViewCell()
            }
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "Ainda não surgiram candidatos para esta vaga."
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
