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
            
            self.tableView.register(CandidateTableViewCell.self, forCellReuseIdentifier: String(describing: CandidateTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: CandidateTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CandidateTableViewCell.self))
            
            self.tableView.register(CandidateSelectedTableViewCell.self, forCellReuseIdentifier: String(describing: CandidateSelectedTableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: CandidateSelectedTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CandidateSelectedTableViewCell.self))
            
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
            
            self.tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var messageToEvaluateCandidateLabel: UILabel!
    @IBOutlet weak var buttonSaveAnnounce: UIButton! {
        didSet {
            self.buttonSaveAnnounce.backgroundColor = UIColor.systemBlue
        }
    }
    
    // MARK: - Variables
    
    var announceJob: AnnounceJob?
    var profileCandidates: [UserProfile] = []
    var myApplicationsIds: [String] = []
    
    var cameFromCreateAnnounce: Bool = false
    var cameFromRecordsAnnounce: Bool = false
    var cameFromApplyTheJobAnnounce: Bool = false
    var cameFromJobToMe: Bool = false
    var cameFromMyApplications: Bool = false
    var cameFromMyAnnounces: Bool = false
    
    var delegate: ClearFieldsDelegate?
    let userProfileViewModel = UserProfileViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = String.localize("announce_detail_nav_bar")
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)
        
        if cameFromCreateAnnounce {
            let alert = UIAlertController(title: "Atenção", message: "Confira os dados do anúncio com atenção antes de finalizar. Eles não poderão ser alterados posteriormente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.buttonSaveAnnounce.setTitle("Anunciar", for: .normal)
            self.buttonSaveAnnounce.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        } else if cameFromRecordsAnnounce {
            self.buttonSaveAnnounce.setTitle("Reativar Anúncio", for: .normal)
            self.buttonSaveAnnounce.addTarget(self, action: #selector(didTapReactivateButton), for: .touchUpInside)
        } else if cameFromApplyTheJobAnnounce || cameFromJobToMe {
            if let isCanceled = announceJob?.isCanceled, let isProccessFinished = announceJob?.isProcessFinished, isCanceled || isProccessFinished {
                self.buttonSaveAnnounce.setTitle("Candidatar-se", for: .normal)
                self.buttonSaveAnnounce.backgroundColor = .gray
                self.buttonSaveAnnounce.isEnabled = false
                if isCanceled {
                    self.buttonSaveAnnounce.setTitle("Anúncio Cancelado", for: .normal)
                }
                if isProccessFinished {
                    self.buttonSaveAnnounce.setTitle("Processo finalizado", for: .normal)
                }
            } else {
                if let announceJobId = self.announceJob?.id, myApplicationsIds.contains(announceJobId) {
                    self.buttonSaveAnnounce.setTitle("Desistir do processo", for: .normal)
                    self.buttonSaveAnnounce.addTarget(self, action: #selector(didTapGiveUpButton), for: .touchUpInside)
                } else {
                    self.buttonSaveAnnounce.setTitle("Candidatar-se", for: .normal)
                    self.buttonSaveAnnounce.addTarget(self, action: #selector(didTapApplyToJobButton), for: .touchUpInside)
                }
            }
        } else if cameFromMyApplications {
            self.buttonSaveAnnounce.setTitle("Desistir do processo", for: .normal)
            self.buttonSaveAnnounce.addTarget(self, action: #selector(didTapGiveUpButton), for: .touchUpInside)
        } else if cameFromMyAnnounces {
            loadCandidates()
            
            if let processIsFinished = announceJob?.isProcessFinished, processIsFinished {
                
                messageToEvaluateCandidateLabel.text = "Assim que possível, não se esqueça de classificar como o serviço foi prestado. Seu comentário será vinculado ao perfil do usuário. Você pode classificar o candidato entrando no perfil dele acima."
                messageToEvaluateCandidateLabel.isHidden = true // To be implemented in another oportunity
                self.buttonSaveAnnounce.backgroundColor = .gray
                self.buttonSaveAnnounce.setTitle("Processo finalizado", for: .normal)
                self.buttonSaveAnnounce.isEnabled = false
            } else {
                self.buttonSaveAnnounce.setTitle("Cancelar Anúncio", for: .normal)
                self.buttonSaveAnnounce.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
            }
        }
    }
    
    private func loadCandidates() {
        if let candidatesIds = announceJob?.candidatesIds, let ocupationArea = announceJob?.occupationArea {
            FirebaseAuthManager().retrieveCandidatesFromFirebase(userIds: candidatesIds, occupationAreaAnnounce: ocupationArea) { (profileUsers) in
                if let profileUsers = profileUsers {
                    self.profileCandidates.removeAll()
                    self.profileCandidates.append(contentsOf: profileUsers)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Methods
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapGiveUpButton() {
        let alert = UIAlertController(title: "Atenção", message: "Realmente deseja desistir desse porcesso seletivo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { (_) in
            if let announceJob = self.announceJob {
                FirebaseAuthManager().cancelJobApplication(userId: self.userProfileViewModel.userId, announceJob: announceJob) { (success) in
                    if let success = success, success {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let alert = UIAlertController(title: "Atenção", message: "Algum erro ocorreu. Tente novamente mais tarde!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                            self.delegate?.clearFields()
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func didTapSaveButton() {
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
    
    @objc
    private func didTapCancelButton() {
        let alert = UIAlertController(title: "Atenção", message: "Você tem certeza de que deseja cancelar este anúncio? Essa operação não poderá ser desfeita e você perderá o contatos dos candidatos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar Anúncio", style: .destructive) { (action) in
            self.cancelAnnounce()
        })
        alert.addAction(UIAlertAction(title: "Manter Anúncio", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func didTapReactivateButton() {
        let alert = UIAlertController(title: "Atenção", message: "Você realmente deseja reativar este anúncio?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reativar Anúncio", style: .default) { (action) in
            self.reactivateAnnounce()
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func didTapApplyToJobButton() {
        let alert = UIAlertController(title: "Atenção", message: "Você realmente deseja candidatar-se a este anúncio?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Candidatar-se", style: .default) { (action) in
            self.applyToJob()
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func applyToJob() {
        if let announceJob = self.announceJob {
            FirebaseAuthManager().applyToJob(userId: userProfileViewModel.userId, announceJob: announceJob) { (success) in
                if let success = success, success {
                    let alert = UIAlertController(title: "Sucesso", message: "Candidatura realizada com sucesso!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func reactivateAnnounce() {
        if let announceJob = self.announceJob {
            let startDate = Date()
            let finishDate = Calendar.current.date(byAdding: .day, value: 3, to: startDate)!
            announceJob.startTimestamp = startDate.timeIntervalSince1970
            announceJob.finishTimestamp = finishDate.timeIntervalSince1970
        
            FirebaseAuthManager().reactivateAnnounceJob(userId: userProfileViewModel.userId, announceJob: announceJob) { (success) in
                if let success = success, success {
                    let alert = UIAlertController(title: "Sucesso", message: "Anúncio reativado com sucesso!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func cancelAnnounce() {
        if let announceJob = self.announceJob {
            let finishedTimestamp = Date().timeIntervalSince1970
            announceJob.finishTimestamp = finishedTimestamp
            FirebaseAuthManager().cancelAnnounceJob(userId: userProfileViewModel.userId, announceJob: announceJob) { (success) in
                if let success = success, success {
                    let alert = UIAlertController(title: "Sucesso", message: "Anúncio cancelado com sucesso!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
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
            if cameFromJobToMe || cameFromRecordsAnnounce || cameFromApplyTheJobAnnounce || cameFromMyApplications {
                return "Status da vaga"
            }
            
            if cameFromMyAnnounces {
                if let announceJob = announceJob, announceJob.isProcessFinished {
                    return "Candidato selecionado"
                }
                
                if !profileCandidates.isEmpty {
                    return "Candidatos à vaga"
                } else {
                    return "Status da vaga"
                }
            }

            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if !cameFromRecordsAnnounce && !cameFromApplyTheJobAnnounce {
                if (announceJob?.selectedCandidateId != nil) || cameFromMyApplications {
                    return 1
                }
                
                if profileCandidates.count > 0 {
                    return profileCandidates.count
                } else {
                    return 1 // pra mostrar linha de info
                }
            }
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
            
            var startDate: Date = Date()
            var finishDate: Date = Date()
            if !cameFromCreateAnnounce {
                if let announceJob = announceJob {
                    startDate = Date(timeIntervalSince1970: announceJob.startTimestamp)
                    finishDate = Date(timeIntervalSince1970: announceJob.finishTimestamp)
                    
                    if announceJob.isCanceled {
                        cell.finalizeOrCanceledLabel.text = "Data do cancelamento"
                        cell.finalizeOrCanceledLabel.textColor = .red
                        cell.finalAnnounceDate.textColor = .red
                    } else
                    if announceJob.isProcessFinished {
                        cell.finalizeOrCanceledLabel.text = "Processo finalizado em"
                        cell.finalizeOrCanceledLabel.textColor = .systemBlue
                        cell.finalAnnounceDate.textColor = .systemBlue
                    } else {
//                        cell.finalAnnounceDate.text = "Finaliza em:"
                    }
                }
            } else {
                startDate = Date()
                finishDate = Calendar.current.date(byAdding: .day, value: 3, to: startDate)!
                
                announceJob?.startTimestamp = startDate.timeIntervalSince1970
                announceJob?.finishTimestamp = finishDate.timeIntervalSince1970
            }
            
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
             if profileCandidates.count > 0, !cameFromMyApplications {
                if let processIsFinished = announceJob?.isProcessFinished, processIsFinished {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CandidateSelectedTableViewCell.self), for: indexPath) as? CandidateSelectedTableViewCell else {
                        fatalError("CandidateSelectedTableViewCell not found!")
                    }
                    
                    cell.selectionStyle = .none
                    
                    let candidateSelectedId = announceJob?.selectedCandidateId
                    let candidate = profileCandidates[indexPath.row]
                    
                    if candidateSelectedId == candidate.userId {
                        cell.textLabel?.textAlignment = .left
                        cell.userName.text = candidate.firstName
                        cell.celPhone.text = candidate.cellphone
                        
                        if let imageData = candidate.userImageData {
                            cell.userPhoto.image = UIImage(data: imageData)
                        } else {
                            cell.userPhoto.image = ImageConstants.ProflePlaceHolder
                        }
                        
                        return cell
                    }
                    
                    return UITableViewCell()

                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CandidateTableViewCell.self), for: indexPath) as? CandidateTableViewCell else {
                        fatalError("CandidateTableViewCell not found!")
                    }
                    
                    cell.selectionStyle = .none
                    
                    let candidate = profileCandidates[indexPath.row]
                    cell.textLabel?.textAlignment = .left
                    cell.userName.text = candidate.firstName
                    if let imageData = candidate.userImageData {
                        cell.userPhoto.image = UIImage(data: imageData)
                    } else {
                        cell.userPhoto.image = ImageConstants.ProflePlaceHolder
                    }

                    return cell
                }
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell") else {
                    return UITableViewCell()
                }
                
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.numberOfLines = 0
                
                if cameFromRecordsAnnounce {
                    if let isCanceled = announceJob?.isCanceled, isCanceled {
                        cell.textLabel?.text = "Anúncio cancelado."
                    }
                } else
                if cameFromMyApplications || cameFromJobToMe || cameFromApplyTheJobAnnounce {
                    if let isProcessFinished = announceJob?.isProcessFinished, isProcessFinished {
                        self.buttonSaveAnnounce.backgroundColor = .gray
                        self.buttonSaveAnnounce.isEnabled = false
                        if announceJob?.selectedCandidateId == userProfileViewModel.userId {
                            cell.textLabel?.text = "Parabéns, você foi selecionado para esta vaga. Aguarde o contato do anunciante."
                            cell.textLabel?.textColor = .systemBlue
                        } else {
                            cell.textLabel?.text = "Infelizmente você não foi selecionado neste processo seletivo."
                            cell.textLabel?.textColor = .red
                        }
                    } else if let isCanceled = announceJob?.isCanceled, isCanceled {
                        self.buttonSaveAnnounce.backgroundColor = .gray
                        self.buttonSaveAnnounce.isEnabled = false
                        cell.textLabel?.text = "Infelizmente este processo seletivo foi cancelado pelo anunciante."
                        cell.textLabel?.textColor = .red
                    } else {
                        if let announceJobId = self.announceJob?.id, myApplicationsIds.contains(announceJobId) || cameFromMyApplications {
                            cell.textLabel?.text = "Fique atento! Caso você seja selecionado, o anunciante da vaga entrará em contato com você."
                        } else {
                            cell.textLabel?.text = "O processo seletivo para está vaga já está acontecendo."
                        }
                    }
                } else {
                    cell.textLabel?.text = "Ainda não surgiram candidatos para esta vaga."
                }
                
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !profileCandidates.isEmpty {
            self.performSegue(withIdentifier: "CandidateProfileViewController", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderIndex = sender as? IndexPath {
            if let candidateProfile = segue.destination as? CandidateProfileViewController {
                let candiadate = profileCandidates[senderIndex.row]
                candidateProfile.candidateProfile = candiadate
                candidateProfile.announce = announceJob
                candidateProfile.delegate = self
            }
        }
    }
}

extension AnnounceDetailViewController: SelectCondaidateDelegate {
    func candidateSelected(announceJobId: String) {
        FirebaseAuthManager().retrieveAnnouncesJob(announceId: announceJobId) { (announce) in
            if let announce = announce {
                self.announceJob = announce
                self.tableView.reloadData()
                
                self.buttonSaveAnnounce.backgroundColor = .gray
                self.buttonSaveAnnounce.setTitle("Processo finalizado", for: .normal)
                self.buttonSaveAnnounce.isEnabled = false
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
