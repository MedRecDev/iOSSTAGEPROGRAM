//
//  SideMenuViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 23/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPSideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var sideMenuTitles = ["Profile", "Privacy Policy", "Share", "Feedback", "About us", "Contact us"]
    var sideMenuImages = ["ic_person", "ic_lock", "ic_share", "ic_info", "ic_info", "ic_phone"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SideMenuTVCell", bundle: nil), forCellReuseIdentifier: "SideMenuTVCell")
        self.tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
}

extension SPSideMenuViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVCell", for: indexPath) as! SideMenuTVCell
        cell.updateUI(imageName: sideMenuImages[indexPath.row], title: sideMenuTitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
