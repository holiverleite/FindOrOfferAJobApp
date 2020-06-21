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
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = String.localize("find_a_job_nav_bar")
        view.bringSubviewToFront(emptyView)
        
        FirebaseAuthManager().retrieveGlobalAnnouncesJob { (announces) in
            if announces.count > 0 {
                self.view.bringSubviewToFront(self.tableView)
                self.announces.removeAll()
                self.announces.append(contentsOf: announces)
                self.tableView.reloadData()
            } else {
                self.view.bringSubviewToFront(self.emptyView)
            }
        }
    }
    
    @objc
    private func closeKeyboard() {
        view.endEditing(true)
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
            detailViewController.cameFromApplyTheJobAnnounce = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        closeKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeKeyboard()
    }
}
