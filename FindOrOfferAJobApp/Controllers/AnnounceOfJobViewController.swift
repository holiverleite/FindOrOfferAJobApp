//
//  AnnounceOfJobViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 09/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

protocol ClearFieldsDelegate: class {
    func clearFields()
}

class AnnounceOfJobViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.separatorStyle = .none
            
            tableView.register(AnnouncesListCellTableViewCell.self, forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: AnnouncesListCellTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
        }
    }
    
    // MARK: - Variables
    
    var announces: [AnnounceJob] = []
    var occupationArea: [String] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = String.localize("find_a_job_nav_bar")
        
        let dispatchGroup = DispatchGroup()
        let user = UserProfileViewModel()
        
        shouldShowActivity(true)
        dispatchGroup.enter()
        FirebaseAuthManager().retrieveProfessionalCards(userId: user.userId) { cards in
            if cards.count > 0 {
                for card in cards {
                    let occupationArea = card.occupationArea
                    self.occupationArea.append(occupationArea)
                }
            }
            dispatchGroup.leave()
        }
        
        shouldShowActivity(true)
        dispatchGroup.notify(queue: .main) {
            FirebaseAuthManager().retrieveGlobalAnnouncesJob { (announces) in
                self.shouldShowActivity(false)
                self.announces.removeAll()
                if announces.count > 0 {
                    self.emptyView.isHidden = true
                    self.view.bringSubviewToFront(self.tableView)
                    self.announces.append(contentsOf: announces)
                    self.tableView.reloadData()
                } else {
                    self.view.bringSubviewToFront(self.emptyView)
                }
            }
        }
    }
    
    @objc
    private func closeKeyboard() {
        view.endEditing(true)
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

extension AnnounceOfJobViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.announces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnnouncesListCellTableViewCell.self), for: indexPath) as? AnnouncesListCellTableViewCell else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyy 'às' HH:mm"
        
        let announce = announces[indexPath.row]
        let startDate = Date(timeIntervalSince1970: announce.startTimestamp)
        let formatterdStartDate = dateFormatter.string(from: startDate)
        
        let finalizeDate = Date(timeIntervalSince1970: announce.finishTimestamp)
        let formatterdFinalDate = dateFormatter.string(from: finalizeDate)
        
        if announce.isCanceled {
            cell.totalCandidatesOrCancelledDateLabel.text = "Data do cancelamento:"
            cell.totalCandidatesOrCancelledDateLabel.textColor = .red
            cell.totalOfCandidates.textColor = .red
        } else {
            cell.totalCandidatesOrCancelledDateLabel.text = "Data de finalização:"
            cell.totalCandidatesOrCancelledDateLabel.textColor = .black
            cell.totalOfCandidates.textColor = .black
        }
        
        cell.announceArea.text = announce.occupationArea
        cell.startDate.text = formatterdStartDate
        cell.totalOfCandidates.text = formatterdFinalDate
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announceJob = announces[indexPath.row]
        self.shouldShowActivity(true)
        if occupationArea.contains(announceJob.occupationArea) {
            self.shouldShowActivity(false)
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            if let detailViewController = storyBoard.instantiateViewController(withIdentifier: "AnnounceDetailViewController") as? AnnounceDetailViewController {
                detailViewController.announceJob = announceJob
                detailViewController.cameFromApplyTheJobAnnounce = true
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        } else {
            self.shouldShowActivity(false)
            let alert = UIAlertController(title: "Atenção", message: String(format: "Você não possui nenhum Cartão Profissional para esta vaga em específico. Crie um Cartão Profissiona para area de '%@' e tente novamente.", announceJob.occupationArea), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        closeKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeKeyboard()
    }
}
