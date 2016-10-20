//
//  NNSQLiteManager.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/20.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

class NNSQLiteManager: NSObject {
    private static let manager: NNSQLiteManager = NNSQLiteManager()
    /// 单粒
    class func shareManager() -> NNSQLiteManager {
        return manager
    }
    
    var dbQueue: FMDatabaseQueue?
    
    /**
     *  打开数据库
     */
    func openDB(DBName: String)
    {
        // 1.根据传入的数据库名称拼接数据库路径
        let path = DBName.docDir()
        print(path)
        
        // 2.创建数据库对象
        // 注意: 如果是使用FMDatabaseQueue创建数据库对象, 那么就不用打开数据库
        dbQueue = FMDatabaseQueue(path: path)
        
        
        // 4.创建表
        creatTable()
    }
    
    private func creatTable()
    {
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Status( \n" +
            "statusId INTEGER PRIMARY KEY, \n" +
            "statusText TEXT, \n" +
            "userId INTEGER, \n" +
            "createDate TEXT NOT NULL DEFAULT (datetime('now', 'localtime')) \n" +
        "); \n"
        
        // 2.执行SQL语句
        dbQueue!.inDatabase { (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        }
    }
}
