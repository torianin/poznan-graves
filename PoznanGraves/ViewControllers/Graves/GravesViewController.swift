//
//  ViewController.swift
//  PoznanGraves
//
//  Created by Robert Ignasiak on 20.05.2017.
//  Copyright © 2017 Torianin. All rights reserved.
//

import UIKit
import CoreData

class GravesViewController: UIViewController {

    let cellHeight:CGFloat = 60
    
    var graves: [NSManagedObject] = []
    weak var tableView: UITableView!
    
    var gravesApi = GravesApi()
    
    var progressHUD: ProgressHUD = {
        let progressHUD = ProgressHUD(text: NSLocalizedString("title_activity_download", comment: ""))
        return progressHUD
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(progressHUD)
        self.progressHUD.show()
        
        self.getGraves()
        
        if graves.count == 0 {
            gravesApi.getGraves( completion: { [weak self] in
                guard let `self` = self else { return }
        
                self.getGraves()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.progressHUD.hide()
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            })
        } else {
            self.progressHUD.hide()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("app_name", comment: "")

        let tableView = UITableView(frame: view.bounds)
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.register(GraveCell.self, forCellReuseIdentifier: GraveCell.Identifier)
        
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateGravesData), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    func getGraves()
    {
        let fec:NSFetchRequest = Grave.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "printSurname", ascending: true)
        fec.sortDescriptors = [sortDescriptor]
        do {
            self.graves = try self.context.fetch(fec)
        } catch {
            print("Error fetching data from CoreData")
        }
    }
    
    func resetAllRecords()
    {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Grave")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }
    
    func updateGravesData(refreshControl: UIRefreshControl) {
        self.progressHUD.show()
        
        resetAllRecords()
        
        gravesApi.getGraves( completion: { [weak self] in
            guard let `self` = self else { return }
            
            self.getGraves()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.progressHUD.hide()
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        })
        
        refreshControl.endRefreshing()
    }
}

extension GravesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let grave = graves[indexPath.row]
        let cellIdentifier = GraveCell.Identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GraveCell
        cell.grave = grave as? Grave
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = GraveDetailsViewController()
        destination.grave = graves[indexPath.row] as? Grave
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
