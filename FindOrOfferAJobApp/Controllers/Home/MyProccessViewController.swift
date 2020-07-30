//
//  MyProccessViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 25/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class MyProccessViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            tableView.separatorStyle = .none
            tableView.register(AnnouncesListCellTableViewCell.self, forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
            tableView.register(UINib(nibName: String(describing: AnnouncesListCellTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    
    var announces: [AnnounceJob] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Meus Processos"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("my_selective_proccess_nav_bar")
        
        shouldShowActivity(true)
        let user = UserProfileViewModel()
        FirebaseAuthManager().retrieveMyJobApplications(userId: user.userId, completion: { (myApplications) in
            self.shouldShowActivity(false)
            if myApplications.count > 0 {
                self.emptyView.isHidden = true
                self.view.bringSubviewToFront(self.tableView)
                self.announces.removeAll()
                self.announces.append(contentsOf: myApplications)
                self.tableView.reloadData()
            } else {
                self.view.bringSubviewToFront(self.emptyView)
            }
        })
    }
    
    // MARK: - Private
    
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

extension MyProccessViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.selectionStyle = .none
        
        if announce.isProcessFinished {
            let finishedDate = Date(timeIntervalSince1970: announce.finishTimestamp)
            let formatterFinishedDate = dateFormatter.string(from: finishedDate)
            cell.totalCandidatesOrCancelledDateLabel.text = "Processo finalizado"
            cell.totalCandidatesOrCancelledDateLabel.textColor = .systemBlue
            cell.totalOfCandidates.textColor = .systemBlue
            cell.totalOfCandidates.text = formatterFinishedDate
        } else {
            cell.totalCandidatesOrCancelledDateLabel.text = "Data de finalização"
            cell.totalOfCandidates.text = formatterdFinalDate
            cell.totalCandidatesOrCancelledDateLabel.textColor = .black
            cell.totalOfCandidates.textColor = .black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announceJob = announces[indexPath.row]
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        if let detailViewController = storyBoard.instantiateViewController(withIdentifier: "AnnounceDetailViewController") as? AnnounceDetailViewController {
            detailViewController.announceJob = announceJob
            detailViewController.cameFromMyApplications = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
