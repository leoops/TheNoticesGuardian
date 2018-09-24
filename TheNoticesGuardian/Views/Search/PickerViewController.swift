//
//  PickerViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 24/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit


protocol PickerViewControllerDelegate: class {
    func selectedSection(section: String)
    
}
class PickerViewController: UIViewController {
    
    @IBOutlet weak var sectionsPicker: UIPickerView!
    
    var sections = [SectionResults]()
    weak var delegate: PickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sectionsPicker.dataSource = self;
        self.sectionsPicker.delegate = self;
        self.requestSections(element: "all")
    }
    func requestSections(element : String ) {
        ApiService.requestAllSections(showElements: element, handler: { (items) in
            if let items = items {
                self.sections = items
            }
            self.sectionsPicker.reloadAllComponents()
        })
    }
    
    @IBAction func selectFilter(_ sender: UIBarButtonItem) {
        delegate?.selectedSection(section: sections[sectionsPicker.selectedRow(inComponent: 0)].id!)
        self.dismiss(animated: true)
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row].webTitle
    }
}
