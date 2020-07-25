//
//  RecommendedJobsForYouViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 30/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class RecommendedJobsForYouViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageEmptyStateLabel: UILabel!
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.isHidden = true
        }
    }
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
    var myApplicationsIds: [String] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = String.localize("job_for_you_nav_bar")
        
        let dispatchGroup = DispatchGroup()
        var professionalCards: [ProfessionalCard] = []
        
        let user = UserProfileViewModel()
        shouldShowActivity(true)
        dispatchGroup.enter()
        FirebaseAuthManager().retrieveProfessionalCards(userId: user.userId) { cards in
            if cards.count > 0 {
                dispatchGroup.leave()
                professionalCards = cards
            } else {
                self.shouldShowActivity(false)
                self.view.bringSubviewToFront(self.emptyView)
                self.messageEmptyStateLabel.text = "Você nao possui cartões profissionais para as vagas existentes. Cadastre seus cartões profissionais e tente novamente."
            }
        }
        
        dispatchGroup.enter()
        FirebaseAuthManager().retrieveJobApplicationsIds(userId: user.userId) { myApplicationsIds in
            dispatchGroup.leave()
            self.myApplicationsIds = myApplicationsIds
        }
        
        dispatchGroup.notify(queue: .main) {
            FirebaseAuthManager().retrieveAnnouncesForMe(professionalCards: professionalCards) { (announces) in
                self.shouldShowActivity(false)
                if announces.count > 0 {
                    self.emptyView.isHidden = true
                    self.view.bringSubviewToFront(self.tableView)
                    self.announces.removeAll()
                    self.announces.append(contentsOf: announces)
                    self.tableView.reloadData()
                } else {
                    self.view.bringSubviewToFront(self.emptyView)
                    self.messageEmptyStateLabel.text = "No momento ainda não surgiram vagas para o seu perfil. Fique atento!"
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc
    private func closeKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    @objc private func didTapBackButton() {
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

extension RecommendedJobsForYouViewController: UITableViewDelegate, UITableViewDataSource {
    
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

        cell.announceArea.text = announce.occupationArea
        cell.startDate.text = formatterdStartDate
        cell.totalCandidatesOrCancelledDateLabel.text = "Data de finalização:"
        cell.totalOfCandidates.text = formatterdFinalDate
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announceJob = announces[indexPath.row]
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        if let detailViewController = storyBoard.instantiateViewController(withIdentifier: "AnnounceDetailViewController") as? AnnounceDetailViewController {
            detailViewController.announceJob = announceJob
            detailViewController.cameFromJobToMe = true
//            detailViewController.cameFromApplyTheJobAnnounce = true
            detailViewController.myApplicationsIds = self.myApplicationsIds
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        closeKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeKeyboard()
    }
}
