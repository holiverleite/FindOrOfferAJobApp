//
//  MyProccessViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 25/05/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class MyProccessViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - Variables
    var myProccess: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        
        if myProccess.isEmpty {
            view.bringSubviewToFront(emptyView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = String.localize("my_selective_proccess_nav_bar")
    }
    
    // MARK: - Private
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyProccessViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProccess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text =  ""
        
        return cell
    }
}
