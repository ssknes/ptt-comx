//
//  Chartering.swift
//  topcpai
//
//  Created by Piyanant Srisirinant on 12/20/2559 BE.
//  Copyright © 2559 PTT ICT Solutions. All rights reserved.
//

import UIKit

class Chartering: PropertyNames {
    var req_transaction_id = ""
    var transaction_id = ""
    var status = ""
    var type = ""
    var function_id = ""  
    var system = ""
    var system_type = ""
    var date_purchase: String = ""
    var purchase_no: String = ""
    var supplier: String = ""
    var vessel: String = ""
    var cust_name: String = ""
    var owner: String = ""
    var laycan_from: String = ""
    var laycan_to: String = ""
    var final_price: String = ""
    var exten_cost: String = ""
    var est_freight: String = ""
    var create_by: String = ""
    
    //type 26
    var broker_name: String = ""
    var route: String = ""
    var no_total_ex: String = ""
    var total_ex: String = ""
    var net_benefit = ""
    var ws = ""

    //type 7
    var broker_id: String = ""
    var result_flag: String = ""
    var result_a: String = ""
    var result_b: String = ""
    var load_port: String = ""
    var discharge_port: String = ""
    var unit_price_value: String = ""
    
    //type 25
    var charterer: String = ""
    var charterer_name: String = ""
    
    var brief = ""
    init() {
        // do nothing
    }
}
