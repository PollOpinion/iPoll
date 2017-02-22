//
//  ProfileVC+handlers.swift
//  DDVP
//
//  Created by Pankaj Neve on 22/02/17.
//  Copyright © 2017 CTS. All rights reserved.
//

import Foundation
import Firebase

extension ProfileVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            userPhoto.image = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userPhoto.image = originalImage
        }
        userPhoto.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
        
        uploadUserPhoto()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image Picket Canceled")
        
        dismiss(animated: true, completion: nil)
        //Do nothing
    }
    
    // MARK: - Helper functions
    func uploadUserPhoto() {
        print ("Uplaod user photo to firebase")
        
//        let storageRef = FIRStorage.storage().reference()
    }
}
