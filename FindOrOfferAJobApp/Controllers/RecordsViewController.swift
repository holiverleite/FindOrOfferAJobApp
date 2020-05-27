//
//  RecordsViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 09/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.separatorStyle = .none
            
            self.tableView.register(AnnouncesListCellTableViewCell.self, forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: AnnouncesListCellTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    
    var canceledAnnounces: [AnnounceJob] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("records_nav_bar")
        
        let user = UserProfileViewModel()
        FirebaseAuthManager().retrieveAnnouncesJob(userId: user.userId, onlyCancelledsAndFinisheds: true) { (canceledAndFinishedAnnounces) in
            if canceledAndFinishedAnnounces.count > 0 {
                self.canceledAnnounces.removeAll()
                self.canceledAnnounces.append(contentsOf: canceledAndFinishedAnnounces)
                self.view.bringSubviewToFront(self.tableView)
                self.tableView.reloadData()
            } else {
                self.view.bringSubviewToFront(self.emptyView)
            }
        }
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.canceledAnnounces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnnouncesListCellTableViewCell.self), for: indexPath) as? AnnouncesListCellTableViewCell else {
            return UITableViewCell()
        }
        
        let announce = self.canceledAnnounces[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyy 'às' HH:mm"
        
        let startDate = Date(timeIntervalSince1970: announce.startTimestamp)
        let canceledOrFinishedDate = Date(timeIntervalSince1970: announce.finishTimestamp)
        
        if announce.isCanceled {
            cell.totalCandidatesOrCancelledDateLabel.text = "Data do cancelamento:"
            cell.totalCandidatesOrCancelledDateLabel.textColor = .red
            cell.totalOfCandidates.textColor = .red
        } else {
            cell.totalCandidatesOrCancelledDateLabel.text = "Data de finalização:"
        }
        
        let formatterdStartedDate = dateFormatter.string(from: startDate)
        let formatterdFinishedDate = dateFormatter.string(from: canceledOrFinishedDate)
        
        cell.announceArea.text = announce.occupationArea
        cell.startDate.text = formatterdStartedDate
        cell.totalOfCandidates.text = formatterdFinishedDate // Ajuste para mostrar data de cancelamento ou finalizacao
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announceJob = self.canceledAnnounces[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        if let detailViewController = storyBoard.instantiateViewController(withIdentifier: "AnnounceDetailViewController") as? AnnounceDetailViewController {
            detailViewController.announceJob = announceJob
            detailViewController.cameFromRecordsAnnounce = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
