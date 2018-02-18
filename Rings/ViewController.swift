//
//  ViewController.swift
//  Rings
//
//  Created by Joshua Tucker on 17/02/2018.
//  Copyright © 2018 Joshua Lee Tucker. All rights reserved.
//

import UIKit
import ContactsUI
import CoreGraphics

class ViewController: UIViewController, CNContactPickerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var tapHereLabel: UILabel!
  
  var colors: [Color]?
  var selectedContact: CNContact?

  // MARK: View Controller

  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadColors()
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.alpha = 0.3
    self.saveButton.alpha = 0.3
    let selectImageTapRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.selectImage))
    self.imageView.addGestureRecognizer(selectImageTapRecogniser)
  }
  
  override func viewDidLayoutSubviews() {
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: Business Logic
  
  func loadColors() {
    if let colorsPath = Bundle.main.path(forResource: "colors", ofType: "json") {
      do {
        let colorsString = try String(contentsOfFile: colorsPath)
        let decoder = JSONDecoder()
        self.colors = try decoder.decode([Color].self, from: colorsString.data(using: .utf8)!)
      } catch {
        print("Something went wrong: \(error)")
      }
    } else {
      print("Colors could not be found on disk.")
    }
  }

  @objc func selectImage(sender: UITapGestureRecognizer) {
    let contactPicker = CNContactPickerViewController()
    contactPicker.delegate = self
    contactPicker.predicateForEnablingContact = NSPredicate(format: "imageData != nil")
    self.present(contactPicker, animated: true, completion: nil)
  }
  
  func animateImageView() {
    UIView.animateKeyframes(withDuration: 0.8, delay: 0.0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
        self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2, animations: {
        self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3, animations: {
        self.imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      })
    }, completion: nil)
  }
  
  @IBAction func saveContact() {
    if (self.selectedContact != nil) {
      let store = CNContactStore()
      let mutableContact = self.selectedContact?.mutableCopy() as! CNMutableContact
      mutableContact.imageData = UIImagePNGRepresentation(self.imageView.image!)
      let saveRequest = CNSaveRequest()
      saveRequest.update(mutableContact)
      do {
        try store.execute(saveRequest)
      } catch {
        print("There was an error saving the contact: \(error)")
      }
    }
  }

  // MARK: Contact Picker Delegate

  func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    let image = UIImage(data: contact.thumbnailImageData!)
    self.selectedContact = contact
    self.imageView.image = image!.rounded()
    self.tapHereLabel.removeFromSuperview()
    self.collectionView.alpha = 1.0
    self.saveButton.isEnabled = true
    self.saveButton.alpha = 1.0
  }
  // MARK: Collection View Data Source

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.colors!.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
    cell.contentView.backgroundColor = UIColor(hex: self.colors![indexPath.row].hexCode)
    return cell
  }
  
  // MARK: Collection View Delegate
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width / 5 , height: collectionView.frame.size.height / 4)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if (self.selectedContact != nil) {
      self.animateImageView()
      self.imageView.image = self.imageView.image?.applyBorder(color: UIColor(hex: self.colors![indexPath.row].hexCode), width: 15)
    }
  }
    
}

