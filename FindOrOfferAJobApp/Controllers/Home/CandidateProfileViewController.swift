//
//  CandidateProfileViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 27/06/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

protocol SelectCondaidateDelegate: class {
    func candidateSelected(announceJobId: String)
}

class CandidateProfileViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var experienceDescription: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var selectCandidate: UIButton! {
        didSet {
            selectCandidate.setTitle("Aprovar candidato", for: .normal)
            selectCandidate.addTarget(self, action: #selector(selectCandidateDidTape), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var candidateImage: UIImageView! {
        didSet {
            self.candidateImage.image = ImageConstants.ProflePlaceHolder
            self.candidateImage.layer.borderWidth = 1
            self.candidateImage.layer.masksToBounds = false
            self.candidateImage.layer.borderColor = UIColor.clear.cgColor
            self.candidateImage.layer.cornerRadius = self.candidateImage.frame.height/3.3
            self.candidateImage.clipsToBounds = true
        }
    }
    
    var announce: AnnounceJob? = nil
    var candidateProfile: UserProfile? = nil
    var delegate: SelectCondaidateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(image: ImageConstants.Back, landscapeImagePhone: ImageConstants.Back, style: .plain, target: self, action: #selector(didTapBackButton)), animated: true)

        if let candidate = candidateProfile, let announce = announce {
            if let candidateImageData = candidate.userImageData  {
                candidateImage.image = UIImage(data: candidateImageData)
            } else {
                candidateImage.image = ImageConstants.ProflePlaceHolder
            }
            name.text = "\(candidate.firstName)\(candidate.lastName)"
            age.text = candidate.birthDate
            
            let card = candidate.professionalCards.first
            if card?.occupationArea == announce.occupationArea {
                experienceDescription.text = card?.descriptionOfProfession
            } else {
                experienceDescription.text = "Candidato sem experiência"
            }
        }
        
        if let announceIsFinished = announce?.isFinished, announceIsFinished {
            selectCandidate.removeTarget(self, action: #selector(selectCandidateDidTape), for: .touchUpInside)
            selectCandidate.setTitle("Chamar no Whatsapp", for: .normal)
            selectCandidate.backgroundColor = UIColor.green.withAlphaComponent(0.8)
            selectCandidate.addTarget(self, action: #selector(openWhatsappDidTape), for: .touchUpInside)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "Detalhes do Candidato"
    }
    
    @objc
    func selectCandidateDidTape() {
        let alert = UIAlertController(title: "Atenção!", message: "Você está prestes a aprovar este candidato para o seu anúncio. Após aprovar este candidato, todos os outros candidatos serão dispensados e seu anúncio será finalizado.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Estou ciente", style: .default, handler: { (_) in
            if let candidate = self.candidateProfile, let announce = self.announce {
                let alert = UIAlertController(title: "Atenção!", message: String(format: "Ao aprovar o candidato %@ o contato dele estará disponível para você.", candidate.firstName), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
                alert.addAction(UIAlertAction(title: "Aprovar candidato", style: .default, handler: { (_) in
                    FirebaseAuthManager().approveCandidateOfAnnounce(candidateId: candidate.userId, announceJob: announce) { (success) in
                        if let success = success, success {
                            let alert = UIAlertController(title: "Sucesso", message: "Candidato selecionado com sucesso!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                                self.delegate?.candidateSelected(announceJobId: announce.id)
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Atenção", message: "Ocorreu um erro durante a seleção do candidato. Tente novamente.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func openWhatsappDidTape() {
        print("Open Whatsapp !!!!")
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
