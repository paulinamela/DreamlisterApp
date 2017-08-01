//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Paulina on 03.05.2017.
//  Copyright © 2017 Paulina. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var PriceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    var stores = [Store]()
    var types = [ItemType]()
    
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        let store = Store(context: context)
        store.name = "Koala Zoo"
        
        let store2 = Store(context: context)
        store2.name = "Tesla Auto"
        
        let store3 = Store(context: context)
        store3.name = "Media Markt"
        
        let store4 = Store(context: context)
        store4.name = "Walmart"
        
        let store5 = Store(context: context)
        store5.name = "Amazon"
        
        let store6 = Store(context: context)
        store6.name = "WH Smith"
        
        
        let itemType = ItemType(context: context)
        itemType.type = "Electronics"
        
        let itemType2 = ItemType(context: context)
        itemType2.type = "Books"
        
        let itemType3 = ItemType(context: context)
        itemType3.type = "Cars"
        
        let itemType4 = ItemType(context: context)
        itemType4.type = "Travelling"
        
        let itemType5 = ItemType(context: context)
        itemType5.type = "Clothing"
        
        let itemType6 = ItemType(context: context)
        itemType6.type = "Other"
        
        
        ad.saveContext()
        
        getStores()
        getItemTypes()
        
        
        if itemToEdit != nil {
            
            loadItemData()
            
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            let store = stores[row]
            return store.name
            
        } else {
            
            let itemType = types[row]
            return itemType.type
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if component == 0 {
            return stores.count
        }
            
        else {
            return types.count
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // update when selected
        
    }
    
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            // handle the error
        }
    }
    
    
    func getItemTypes() {
        
        let fetchRequestItemType: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            
            self.types = try context.fetch(fetchRequestItemType)
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            // handle the error
        }
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context) // tworzymy instancję encji Image
        
        picture.image = thumbImg.image // atrybut image danej encji Image przypisujemy do tego zdjecia ktore sami wgralismy
        
        
        if itemToEdit == nil {
            
            item = Item(context: context)
            
        } else {
            
            item = itemToEdit
        }
        
        item.toImage = picture // wiążemy dany image z konkretnym itemem
        
        
        
        
        if let title = titleField.text {
            
            item.title = title
        }
        
        if let price = PriceField.text {
            
            item.price = (price as NSString).doubleValue // konwersja Double na String
        }
        
        if let details = detailsField.text {
            
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)] // odwolanie przez relationship zdefiniowany wczesniej
        
        item.toItemType = types[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true) // dismiss obecnego View i powrót do poprzedniego
        
    }
    
    
    
    func loadItemData() {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            PriceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    
                    index+=1
                    
                } while (index < stores.count)
            }
            
            
            if let itemType = item.toItemType {
                
                var x = 0
                repeat {
                    
                    let t = types[x]
                    if t.type! == itemType.type! {
                        
                        storePicker.selectRow(x, inComponent: 1, animated: false)
                        break
                    }
                    
                    x+=1
                    
                } while (x < types.count)
            }

            
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    

    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    

}
