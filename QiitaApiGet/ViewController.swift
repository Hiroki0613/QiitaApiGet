//
//  ViewController.swift
//  QiitaApiGet
//
//  Created by 近藤宏輝 on 2020/02/11.
//  Copyright © 2020 Hiroki. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //QiitaStructの構造体を定義
    var qiitaStruct : [QiitaStruct]?
    
    //tableViewを定義
    var tableView: UITableView!
    
    //QiitaのAPIで使うURLを宣言
    var url = "https://qiita.com/api/v2/items?page=1&per_page=20"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        print("hirohiro")
        startAlamofire()
        tableView.reloadData()
    }

    
    func startAlamofire(){
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                print("hirohiro2")
                guard let data = response.data else { return
                    print("hirhiro4")
                }
                
                guard let qiitaData = try? JSONDecoder().decode([QiitaStruct].self, from: data) else { return print("hirohiro5") }
                
                print(qiitaData)

                self.qiitaStruct = qiitaData
                self.tableView.reloadData()
            case .failure(let error):
                print("hirohiro3")
                print(error)
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //通信が非同期のため、初回はnilを返すため。リロード時と処理を分岐
        if let cnt = self.qiitaStruct?.count {
            return cnt
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        
        //通信が非同期のため、初回はnilを返すため。リロード時と処理を分岐
        if let qiitaData = qiitaStruct?[indexPath.row]{
            
            cell.textLabel?.text = qiitaData.title
            print("hirohiro6\(qiitaData.title)")
            cell.detailTextLabel?.text = qiitaData.user.name
            print("hirohiro7\(qiitaData.user.name)")
        }
        return cell
    }
    
}

