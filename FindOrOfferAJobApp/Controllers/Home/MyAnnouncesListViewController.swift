//
//  MyAnnouncesListViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 23/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class MyAnnouncesListViewController: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.register(AnnouncesListCellTableViewCell.self, forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: AnnouncesListCellTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AnnouncesListCellTableViewCell.self))
            
            self.tableView.separatorStyle = .none
        }
    }
    
    // MARK: - Variables
    var announces: [AnnounceJob] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("my_announces_nav_bar")
        
        let user = UserProfileViewModel()
        FirebaseAuthManager().retrieveAnnouncesJob(userId: user.userId) { (announcesJob) in
            if announcesJob.count > 0 {
                self.announces.removeAll()
                self.announces.append(contentsOf: announcesJob)
                self.tableView.isHidden = false
                self.view.bringSubviewToFront(self.tableView)
                self.tableView.reloadData()
            } else {
                self.view.bringSubviewToFront(self.emptyView)
            }
        }
    }
    
    // MARK: - Private
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyAnnouncesListViewController: UITableViewDataSource, UITableViewDelegate {
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
        let formatterdDate = dateFormatter.string(from: startDate)

        cell.announceArea.text = announce.occupationArea
        cell.startDate.text = formatterdDate
        cell.totalOfCandidates.text = "\(announce.candidatesIds.count) candidatos"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AnnounceDetailViewController", sender: announces[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let announceViewController = segue.destination as? AnnounceDetailViewController, let announce = sender as? AnnounceJob {
            announceViewController.announceJob = announce
        }
    }
}
