//
//  CandidateProfileViewController.swift
//  FindOrOfferAJobApp
//
//  Created by Haroldo Leite on 27/06/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CandidateProfileViewController: UIViewController {

    @IBOutlet weak var experienceDescription: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let candidate = candidateProfile, let announce = announce, let candidateImageData = candidate.userImageData {
            candidateImage.image = UIImage(data: candidateImageData)
            name.text = "\(candidate.firstName)\(candidate.lastName)"
            age.text = candidate.birthDate
            
            let card = candidate.professionalCards.first
            if card?.occupationArea == announce.occupationArea {
                experienceDescription.text = card?.descriptionOfProfession
            } else {
                experienceDescription.text = "Candidato sem experiência"
            }
            
//            parei mostrando essa parte
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
