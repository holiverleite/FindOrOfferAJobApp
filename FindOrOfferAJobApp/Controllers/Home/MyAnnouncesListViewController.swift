//
//  MyAnnouncesListViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 23/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class MyAnnouncesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        }
    }
    
    // MARK: - Variables
    var announces: [AnnounceJob] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        
        let user = UserProfileViewModel()
        FirebaseAuthManager().retrieveAnnouncesJob(userId: user.userId) { (announcesJob) in
            if announcesJob.count > 0 {
                self.announces.removeAll()
                self.announces.append(contentsOf: announcesJob)
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("my_announces_nav_bar")
        
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = announces[indexPath.row].occupationArea
        
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
