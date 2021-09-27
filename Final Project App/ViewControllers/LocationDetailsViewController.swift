//
//  LocationDetailsViewController.swift
//  Final Project App
//
//  Created by Omairys Uzcátegui on 2021-09-22.
//

import UIKit
import CoreLocation
import CoreData

class LocationDetailsViewController: UITableViewController {
    
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var birtdateLabel: UILabel!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var imageViewRow: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var managedObjectContext: NSManagedObjectContext!
    var datePickerVisible = false
    var gender = "No Selected"
    var country = "No Selected"
    var birtDate = Date()
    var locationToEdit: Location?
    var image: UIImage?
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
      super.viewDidLoad()
        imageViewRow.isHidden = true
        genderLabel.text = gender
        countryLabel.text = country
        updateBirtDateLabel()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        switch segue.identifier! {
        case "PickGender":
            let controller = segue.destination as!
            GenderPickerViewController
            controller.selectedGender = gender
        case "PickCountry":
            let controller = segue.destination as!
            CountryPickerViewController
            controller.selectedCountry = country
        default:
                break
            }
    }
    // MARK: - Actions
    

    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderPickerDidPickGender(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! GenderPickerViewController
        gender = controller.selectedGender
        genderLabel.text = gender
    }
    
    @IBAction func countryPickerDidPickCountry(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CountryPickerViewController
        country = controller.selectedCountry
        countryLabel.text = country
    }
    
    @IBAction func changeDate(_ sender: Any) {
        birtDate = datePicker.date
        updateBirtDateLabel()
    }
    
    @IBAction func done(_ sender: Any) {
        
        let hudView = HudView.hud(inView: navigationController!.view,
                                  animated: true)
        hudView.text = "Tagged"
        
        let location: Location
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
            location.photoID = nil
        }
        
        location.name = inputName.text
        location.gender = gender
        location.country = country
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
        }
        
        
    }
    
    
    // MARK: - Prviate Methods
    func updateBirtDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "MM/dd/yyyy"
        birtdateLabel.text = formatter.string(from: birtDate)
    }
    
    func showDatePicker() {
      datePickerVisible = true
      
      let indexPathDateRow = IndexPath(row: 2, section: 0)
      let indexPathDatePicker = IndexPath(row: 3, section: 0)
      
      if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
        dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
      }
      
      tableView.beginUpdates()
      tableView.insertRows(at: [indexPathDatePicker], with: .fade)
      tableView.reloadRows(at: [indexPathDateRow], with: .none)
      tableView.endUpdates()
      
      datePicker.setDate(birtDate, animated: false)
    }
    
    func hideDatePicker() {
      if datePickerVisible {
        datePickerVisible = false
        
        let indexPathDateRow = IndexPath(row: 2, section: 0)
        let indexPathDatePicker = IndexPath(row: 3, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPathDateRow) {
          cell.detailTextLabel!.textColor = UIColor.black
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        tableView.endUpdates()
      }
    }
    func show(image: UIImage) {
        imageViewRow.image = image
        imageViewRow.isHidden = false
        addPhotoLabel.text = ""
        imageHeight.constant = 260
        tableView.reloadData()
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0 && datePickerVisible {
        return 4
      } else {
        return super.tableView(tableView, numberOfRowsInSection: section)
      }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      switch (indexPath.section, indexPath.row) {
      case (0, 3):
          return 217
      case (1, _):
          return imageViewRow.isHidden ? 44 : 280
      default:
        return 44
      }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
      var newIndexPath = indexPath
      if indexPath.section == 0 && indexPath.row == 3 {
        newIndexPath = IndexPath(row: 0, section: indexPath.section)
      }
      return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 3 {
          return datePickerCell
        } else {
          return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
        return indexPath
      } else {
        return nil
      }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.section == 0 && indexPath.row == 0 {
          inputName.resignFirstResponder()
      } else if indexPath.section == 0 && indexPath.row == 2 {
          if !datePickerVisible {
            showDatePicker()
          } else {
            hideDatePicker()
          }
      }else if indexPath.section == 1 && indexPath.row == 0 {
        tableView.deselectRow(at: indexPath, animated: true)
        pickPhoto()
      }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      hideDatePicker()
    }
  }

  extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhotoWithCamera() {
      let imagePicker = MyImagePickerController()
      imagePicker.sourceType = .camera
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.view.tintColor = view.tintColor
      present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
      let imagePicker = MyImagePickerController()
      imagePicker.sourceType = .photoLibrary
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.view.tintColor = view.tintColor
      present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        showPhotoMenu()
      } else {
        choosePhotoFromLibrary()
      }
    }
    
    func showPhotoMenu() {
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(actCancel)
      let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
        self.takePhotoWithCamera()
      })
      alert.addAction(actPhoto)
      let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
        self.choosePhotoFromLibrary()
      })
      alert.addAction(actLibrary)
      present(alert, animated: true, completion: nil)
    }
    
      // MARK: - Image Picker Delegates
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
          if let theImage = image {
              show(image: theImage)
          }
          dismiss(animated: true, completion: nil)
      }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
    }
      
    
  }
