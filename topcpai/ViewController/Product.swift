//
//  Product.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 5/9/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
class Product: PropertyNames {
    var req_transaction_id = ""
    var transaction_id = ""
    var status = ""
    var type = ""
    var function_id = ""
    var function_des = ""
    var result_namespace = ""
    var result_status = ""
    var result_code = ""
    var result_desc = ""
    var response_message = ""
    var system = ""
    var system_type = ""
    
    var doc_date: String = ""
    var doc_trans_id: String = ""
    var doc_req_id: String = ""
    var doc_no: String = ""
    var doc_for: String = ""
    var doc_type: String = ""
    var doc_form: String = ""
    var doc_status: String = ""
    var awaeded: Any?
    var created_by: String = ""
    
    var brief = ""
    
    var advace_loading_request_data: Any?
    init() {
        // do nothing
    }
}

class Advance_loading: PropertyNames {
    
    var alr_trans_id: String = ""
    var alr_approval_type: String = ""
    var alr_status: String = ""
    var alr_row_no: String = ""
    var alr_is_need_to_request: String = ""
    var alr_request_reason: String = ""
    var alr_customer: String = ""
    var alr_supplier: String = ""
    var alr_material: String = ""
}

class Product_Award: PropertyNames {
    var awarded_customer: String = ""
    var awarded_supplier: String = ""
    var awarded_product: String = ""
    var awarded_quantity: String = ""
    var awarded_incoterm: String = ""
    var awarded_selling_price: String = ""
    var awarded_purchasing_price: String = ""
    var awarded_freight: String = ""
    var awarded_final_price: String = ""
    var awarded_export_surcharge_price: String = ""
    var awarded_net_export_price: String = ""
    var awarded_rfo_price: String = ""
    var awarded_ng_price: String = ""
    var awarded_market_price: String = ""
    var awarded_lp_price: String = ""
    var awarded_benchmark_price: String = ""
    var awarded_break_even_price: String = ""
    var awarded_argus_price: String = ""
    var awarded_hsfo_price: String = ""
    var awarded_simplan_price: String = ""
    var awarded_benefit_rfo: String = ""
    var awarded_benefit_ng: String = ""
    var awarded_benefit_market: String = ""
    var awarded_benefit_lp: String = ""
    var awarded_benefit_benchmark: String = ""
    var awarded_benefit_break_even: String = ""
    var awarded_benefit_argus: String = ""
    var awarded_benefit_hsfo: String = ""
    var awarded_benefit_simplan: String = ""
    var awarded_contract_prd: String = ""
    var awarded_loading_prd: String = ""
    var awarded_pricing_prd: String = ""
    var awarded_discharging_prd: String = ""
    var awarded_up_tier: Any?
    var brief = ""
    var status = ""  
}

class Awarded_up_tier_obj: PropertyNames {
    var awarded_tier_quantity: String = ""
    var awarded_tier_price: String = ""
}
