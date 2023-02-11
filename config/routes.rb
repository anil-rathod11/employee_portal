
Rails.application.routes.draw do
  
  root to: "application#index"
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Account
  post "authenticate", to: "authentication#login"
  # post 'employee/login', to: "employee#login"
  put "reset/password", to: "employee#reset"
  post "forgot/password", to: "employee#forgot"
  post "change/password", to: "employee#change_password"

  # employee appraisal api
  post "create", to: "appraisal_form#create"
  put "update/:appraisal_id", to: "appraisal_form#update"
  
  # history_api
  post 'appraisal/history/:page/:which_one', to: "manager#get_history_by_page"
  post 'appraisal/history-by-name/:name/:page', to: "manager#search_history"
  # post 'history/manager-appraisal/:page', to: "manager#get_history_by_page"

# manager api
  # match 'manager/review/:year/:quarter/:employee_id', to: "welcome#index", via: [:get, :post, :put, :delete, :options, :head, :patch]
  post "manager/review/:history_id", to: "manager#get_appraisal_form_by_reviewer"
  post "get/appraisal/:year/:quarter", to: "appraisal_form#get_quarterly_appraisal"
  put "update/manager/review/:quarterly_appraisal_remarks_id", to: "manager#update_appraisal_form_only_reviewer"
  # post "manager/review", to: "appraisal_form#create_appraisal_form_only_reviewer"
  post "create/manager/review", to: "manager#create_appraisal_form_only_reviewer"
  # match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]


  # annual appraisal api
  post "create/annual/appraisal", to: "annual_appraisal_form#create"
  put "update/annual/appraisal/:id", to: "annual_appraisal_form#update"


  #Super admin api
  post "create/new/employee", to: "super_admin#create_employee"
  post "employee/list/:page", to:"super_admin#employee_list"
  delete "destroy/annual/appraisal/:id", to: "super_admin#destroy_annual_appraisal"
  delete "destroy/quaterly/appraisal/:employee_id/:year/", to: "super_admin#soft_delete_employee_appraisal_data"
  delete "permanent/delete/appraisal/record/:employee_id", to: "super_admin#permanent_delete_employee_appraisal_data"
  post "read/all/annual/appraisal", to: "super_admin#read_annual_appraisal"
  post "read/all/quarterly/appraisal", to: "super_admin#read_quarterly_appraisal"
  post "super/admin/create/remark/annual/appraisal", to: "super_admin#create_annual_appraisal_for_remark"
  post "super/admin/create/quarterly/appraisal/remark", to: "super_admin#create_quarterly_appraisal_for_remark"
  delete "super/admin/soft-delete-employee/:employee_id", to: "super_admin#delete_employee"
  delete "super/admin/delete-employee/:employee_id", to: "super_admin#permanent_delete_employee"
  post "super/admin/create/project", to: "super_admin#create_project"

  # Employee dashboard
  post "employee/dashboard", to: "dashboard#employee_dashboard"

  # create event
  post "create/event",to: "create_event#create"
  post "get-one-month-events", to: "create_event#read"

  # Employee Bday api
  post "get-employee-bday-list", to: "create_event#current_month_employee_bdays"
  post "send-bday-wish", to: "create_event#send_bday_wish_mail"

  # employee leaves
  post "super/admin/create-leave-counter", to:"employee_leaves#create_leave_counter"
  post "super/admin/read-leave-counter", to: "employee_leaves#read_leave_counter"
  post "create-leave-application", to:"employee_leaves#create_leave_app"
  put "update-leave-application/:id", to:"employee_leaves#update_leave_app"
  post "leaves/application-list", to: "employee_leaves#read_leave_app"


  # Employee profile
  post "employee/get-address/", to: "profile#get_employee_address"
  post "employee/get-address/:employee_id", to: "profile#get_employee_address"
  post "employee/get-education-detail/:employee_id", to: "profile#get_employee_education_detail"
  post "employee/get-education-detail/", to: "profile#get_employee_education_detail"
  post "employee/get-financial-info/", to: "profile#get_employee_financial_info"
  post "employee/get-financial-info/:employee_id", to: "profile#get_employee_financial_info"
  post "employee/get-additional-info/", to: "profile#get_employee_additional_info"
  post "employee/get-additional-info/:employee_id", to: "profile#get_employee_additional_info"

  post "employee/address", to: "profile#employee_address"
  post "employee/education-detail", to: "profile#employee_education_detail"
  post "employee/financial-info", to: "profile#employee_financial_info"

  put "employee/update-address/:id", to: "profile#update_employee_address"
  put "employee/update-education-detail/:id", to: "profile#update_employee_education_detail"
  put "employee/update-financial-info/:id", to: "profile#update_employee_financial_info"
  put "employee/update-additional-info/:id", to: "profile#employee_additional_info"
end