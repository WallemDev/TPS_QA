# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140623081113) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "logins", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tblWSQuoteDtls", :id => false, :force => true do |t|
    t.integer  "intID",                           :null => false
    t.integer  "intWSQuoteHdrID"
    t.string   "strIMONo",        :limit => 8,    :null => false
    t.string   "strVslCode",      :limit => 3,    :null => false
    t.string   "strRMSTPID",      :limit => 10,   :null => false
    t.string   "strQuotesNo",     :limit => 36,   :null => false
    t.integer  "intQteVerNo",     :limit => 2,    :null => false
    t.integer  "intRQLineNo",                     :null => false
    t.string   "strItemCode",     :limit => 50,   :null => false
    t.string   "strItemDesc",     :limit => 2000, :null => false
    t.string   "strUnit",         :limit => 3,    :null => false
    t.string   "strQty",          :limit => 20,   :null => false
    t.string   "strPrice",        :limit => 20,   :null => false
    t.string   "intDiscRate",     :limit => 20
    t.string   "strDaysReady",    :limit => 10,   :null => false
    t.string   "strAmount",       :limit => 20
    t.string   "strVariance",     :limit => 2000
    t.datetime "dteDateCreated"
    t.datetime "dteUpdated"
    t.string   "strFileName"
    t.binary   "binContents"
    t.boolean  "bolQuoted"
    t.string   "guiID",           :limit => 50
  end

  create_table "tblWSQuoteDtlsNEW", :primary_key => "intID", :force => true do |t|
    t.integer  "intWSQuoteHdrID"
    t.string   "strIMONo",        :limit => 8,                     :null => false
    t.string   "strVslCode",      :limit => 3,                     :null => false
    t.string   "strRMSTPID",      :limit => 10,                    :null => false
    t.string   "strQuotesNo",     :limit => 36,                    :null => false
    t.integer  "intQteVerNo",     :limit => 2,                     :null => false
    t.integer  "intRQLineNo",                                      :null => false
    t.string   "strItemCode",     :limit => 50,                    :null => false
    t.string   "strItemDesc",     :limit => 2000,                  :null => false
    t.string   "strUnit",         :limit => 3,                     :null => false
    t.string   "strQty",          :limit => 20,                    :null => false
    t.string   "strPrice",        :limit => 20,                    :null => false
    t.string   "intDiscRate",     :limit => 20
    t.string   "strDaysReady",    :limit => 10,   :default => "0", :null => false
    t.string   "strAmount",       :limit => 20
    t.string   "strVariance",     :limit => 2000
    t.datetime "dteDateCreated"
    t.datetime "dteUpdated"
    t.string   "strFileName"
    t.binary   "binContents"
    t.boolean  "bolQuoted"
    t.string   "guiID",           :limit => 50
  end

  add_index "tblWSQuoteDtlsNEW", ["strQuotesNo", "intQteVerNo", "intRQLineNo"], :name => "IX_tblWSQuoteDtls_Constraint", :unique => true

  create_table "tblWSQuoteHdr", :id => false, :force => true do |t|
    t.integer  "intID",                              :null => false
    t.string   "strIMONo",           :limit => 8,    :null => false
    t.string   "strVslcode",         :limit => 3,    :null => false
    t.string   "strRMSTPID",         :limit => 10,   :null => false
    t.string   "strQuotesNo",        :limit => 36,   :null => false
    t.integer  "intQteVerNo",        :limit => 2,    :null => false
    t.integer  "lngRFQNo",                           :null => false
    t.string   "strRQNo",            :limit => 5,    :null => false
    t.string   "strRFQNo",           :limit => 20,   :null => false
    t.integer  "intRFQVerNo",        :limit => 2,    :null => false
    t.datetime "dteCreated",                         :null => false
    t.datetime "dteUpdated",                         :null => false
    t.string   "strSupRemark",       :limit => 2000
    t.boolean  "bolOrigMaker"
    t.boolean  "bolOtherSupplier"
    t.string   "strCurCode",         :limit => 3,    :null => false
    t.string   "strOrigCountryCode", :limit => 2,    :null => false
    t.boolean  "sboldiscount"
    t.string   "strPayTerm",         :limit => 200
    t.string   "strDaysReady",       :limit => 10
    t.string   "strGrossWt",         :limit => 20
    t.boolean  "bolAllQuoted"
    t.string   "strSupRefNo",        :limit => 20
    t.string   "strDiscByPerc",      :limit => 20
    t.string   "strDiscByCurr",      :limit => 20
    t.string   "strDiscDesc",        :limit => 2000
    t.string   "strSupContact1",     :limit => 30
    t.string   "strSupContact2",     :limit => 30
    t.string   "intDelivCharge",     :limit => 20
    t.datetime "dteQuoteValid"
    t.boolean  "bolWebSupplier",                     :null => false
    t.string   "strQuoteStatus",     :limit => 30,   :null => false
    t.string   "strBuyRMSTPID",      :limit => 10,   :null => false
    t.boolean  "bolBuyerRaised",                     :null => false
    t.string   "strCountryCode",     :limit => 2
    t.string   "strCountryCodeEx",   :limit => 2
  end

  create_table "tblWSQuoteHdrNEW", :primary_key => "intID", :force => true do |t|
    t.string   "strIMONo",           :limit => 8,                       :null => false
    t.string   "strVslcode",         :limit => 3,                       :null => false
    t.string   "strRMSTPID",         :limit => 10,                      :null => false
    t.string   "strQuotesNo",        :limit => 36,                      :null => false
    t.integer  "intQteVerNo",        :limit => 2,                       :null => false
    t.integer  "lngRFQNo",                                              :null => false
    t.string   "strRQNo",            :limit => 5,                       :null => false
    t.string   "strRFQNo",           :limit => 20,                      :null => false
    t.integer  "intRFQVerNo",        :limit => 2,                       :null => false
    t.datetime "dteCreated",                                            :null => false
    t.datetime "dteUpdated",                                            :null => false
    t.string   "strSupRemark",       :limit => 2000
    t.boolean  "bolOrigMaker"
    t.boolean  "bolOtherSupplier"
    t.string   "strCurCode",         :limit => 3,                       :null => false
    t.string   "strOrigCountryCode", :limit => 2,                       :null => false
    t.boolean  "sboldiscount"
    t.string   "strPayTerm",         :limit => 200
    t.string   "strDaysReady",       :limit => 10
    t.string   "strGrossWt",         :limit => 20
    t.boolean  "bolAllQuoted"
    t.string   "strSupRefNo",        :limit => 20
    t.string   "strDiscByPerc",      :limit => 20
    t.string   "strDiscByCurr",      :limit => 20
    t.string   "strDiscDesc",        :limit => 2000
    t.string   "strSupContact1",     :limit => 30
    t.string   "strSupContact2",     :limit => 30
    t.string   "intDelivCharge",     :limit => 20,   :default => "0"
    t.datetime "dteQuoteValid"
    t.boolean  "bolWebSupplier",                     :default => true,  :null => false
    t.string   "strQuoteStatus",     :limit => 30,                      :null => false
    t.string   "strBuyRMSTPID",      :limit => 10,                      :null => false
    t.boolean  "bolBuyerRaised",                     :default => false, :null => false
    t.string   "strCountryCode",     :limit => 2
    t.string   "strCountryCodeEx",   :limit => 2
  end

end
