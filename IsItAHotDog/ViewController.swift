//
//  ViewController.swift
//  IsItAHotDog
//
//  Created by UTKARSH VARMA on 2021-01-08.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var capturedIMageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(_ image:CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)else{
            fatalError("Couldnt load coreML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation]else{
                fatalError("Error Casting result array to VNclassification Array")
            }
            if let firstResult = results.first{
//                if firstResult.identifier.contains("hotdog"){
//                    self.navigationController?.navigationBar.topItem?.title = "Hot Dog"
//                    print("Hot Dog")
//                }else{
//                    self.navigationController?.navigationBar.topItem?.title = "Not Hotdog"
//
//                }
                self.navigationController?.navigationBar.topItem?.title =  "\(firstResult.identifier)"
            }
            
            
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
            
        }catch{
            print("Handler Error \(error)")
        }
    }
    
}





extension ViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            capturedIMageView.image = capturedImage
            
            guard let ciImage = CIImage(image: capturedImage) else{
                fatalError("Error convertiing the userpicked image to CIImage")
            }
            detect(ciImage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController:UINavigationControllerDelegate{
    
}
