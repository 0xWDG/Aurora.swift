//
//  File.swift
//  
//
//  Created by Wesley de Groot on 22/01/2021.
//

#if canImport(UIKit)
import Foundation
import UIKit

public class AuroraLogView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var logMessages = Aurora.shared.getLogMessages()
    var tableView: UITableView = UITableView()
    
    public override func viewDidLoad() {
        logMessages.append("END OF REPORT\r\n\r\n")
        logMessages.append("AuroraExitLogViewButton")
        
        // Setup UITableView
        tableView = UITableView(frame: UIApplication.shared.key!.frame).configure { [self] in
            $0.delegate = self
            $0.dataSource = self
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 85
        }
        
        view.addSubview(tableView)
        
        super.viewDidLoad()
        
        Aurora.shared.execute(after: 0.5) { [self] in
            let indexPath: IndexPath = NSIndexPath(row: self.logMessages.count - 1, section: 0) as IndexPath
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        Aurora.shared.execute(after: 10) {
            self.reloadLogView()
        }
    }
    
    private func reloadLogView() {
        logMessages = Aurora.shared.getLogMessages()
        logMessages.append("END OF REPORT\r\n\r\n")
        logMessages.append("AuroraExitLogViewButton")
        
        self.tableView.reloadData()
        
        Aurora.shared.execute(after: 10) {
            self.reloadLogView()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logMessages.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if logMessages[indexPath.row] == "AuroraExitLogViewButton" {
            self.dismiss(animated: true, completion: nil)
        } else {
            UIPasteboard.general.string = logMessages[indexPath.row]
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init().configure {
            if logMessages[indexPath.row] != "AuroraExitLogViewButton" {
                $0.textLabel!.text = logMessages[indexPath.row]
            } else {
                $0.textLabel!.text = NSLocalizedString(
                    "Close window",
                    comment: "Close window"
                ) + "\n\n\n"
                $0.textLabel?.textAlignment = .center
            }
            
            $0.textLabel!.numberOfLines = 0
            $0.textLabel!.lineBreakMode = .byWordWrapping
            $0.textLabel!.sizeToFit()
        }
    }
}

#endif
