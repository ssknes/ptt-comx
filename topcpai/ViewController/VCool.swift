//
//  VCool.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/30/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
class VCool: PropertyNames {
    var function_id = ""
    var req_transaction_id = ""
    var transaction_id = ""
    var status = ""
    var type = ""
    var system = ""
    var system_type = ""

    var date_purchase: String = "" //date_purchase="13-Nov-2017 10:23"
    var purchase_no: String = "" //purchase_no="VCO-1711-0006"
    var supplier: String = "" //supplier="1000197"
    var final_price: String = ""
    var product_name: String = "" //product_name="KIMANIS"
    var incoterm : String = "" //incoterm="FOB"
    var formula_p: String = ""//DUBAI+40 FOB $/bbl"
    var discharging_period: String = "" //discharging_period="14-Nov-2017 to 19-Nov-2017"
    var loading_period: String = "" //loading_period="14-Nov-2017 to 19-Nov-2017"
    var lp_result : String = "" //lp_result="PHA+dmxja3NrZmpvaXIgKE1vYmlsZSkuPC9wPg=="
    var origin: String = "" //origin="Malaysia"
    var volume_kbbl_max: String = "" //volume_kbbl_max="200"
    var volume_kt_max: String = "" //volume_kt_max="26"
    var user_group: String = ""//user_group="CMVP"
    var user_group_delegate: String = ""
    var tpc_month: String = ""
    var tcp_year: String = ""
    var sc_status: String = ""
    var tn_status: String = ""
    var quantity_kbbl_max: String = ""
    var requested_name: String = ""
    var benchmark_price: String = ""
    var premium_maximum: String = ""
    var scsc_agree_flag: String = ""
    var revise_dischange_period: String = ""
    var purchase_result: String = ""
    
    var brief = ""
    init() {
        // do nothing
    }
}
