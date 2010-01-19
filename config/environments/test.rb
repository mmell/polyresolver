# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

config.gem "factory_girl", :source => "http://gemcutter.org"

DevPlayerEndPoint = 'http://0.0.0.0:3010' # using localhost gives me redirects
  # this comes from the dev db, used to test RPC. run rake db:seeds in dev
DevPlayerEmail = 'devplayer@example.com'
DevPlayer = { 
  :signifier => 'devplayer',
  :public_key => %Q{-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD1RvN92Ztb3J/h7fvdxffqqjyY
IX8E3Tej3uE9SDpXSuxQKqhLn6QSarmbiDO7opvAcQFsITQinR4kcnn4KFOS1JR3
5Lvgath7H9TAIqdw6bMO4bHZrguiGz0jd1hiQMVrPaZW+LBCe8G+vSMtKA6I78pA
pYNqMu2yAHIhFaAinQIDAQAB
-----END PUBLIC KEY-----},
  :private_key => %Q{-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQD1RvN92Ztb3J/h7fvdxffqqjyYIX8E3Tej3uE9SDpXSuxQKqhL
n6QSarmbiDO7opvAcQFsITQinR4kcnn4KFOS1JR35Lvgath7H9TAIqdw6bMO4bHZ
rguiGz0jd1hiQMVrPaZW+LBCe8G+vSMtKA6I78pApYNqMu2yAHIhFaAinQIDAQAB
AoGBALboOhvXcquGUxRATFqNjttIJ/eqwvX1odBqHL1+Z0NBdAg0R1xdqBSz0cXS
RAHguRVBMDZabG6DjD7Rv3L3X5nheg63IryMRMwRG0SbdPraQPmQMRwWZXNSwS8B
UTYSS1cQ3OZunL+xY2iKVwxWuvx0tU6mDogNTj1hcRRo5RthAkEA/dBN3dtTBRra
GXFPvU4DLEU5H/CA5jqHChc+cLusHJwIdWJpb31yTF/+0vMRCwHDBMDXUzenceQl
vpkO1OG3xwJBAPdj0pshfIPHpIOa7wpoBUYat3QBu6NPJeteH1hTlvy4pzvR0r1w
FnhdYaO0iapxNCGBKM+7yKSCOKhbSFeoensCQQCziGWb2ajWwpClUI5b1FPQO8LV
gdRbhejBTYHAUi/DKOeeyJbV4wE3XuusIXzbsUpWEWX+Gi7aE8xTDob8NBE/AkAk
bzsxRblE3z5Hc6YI7lD4hi7GkwrDfoCjLXWIWKdACSH4GWrkI4HrsDUVGx27UHjR
BmiwT4O5VsRpZyg8YL/JAkEArkE1l/l+QB7IXwNRaGlruuYnO4Ty6NXm8UmkP8nr
Ov9EBKYfP9/CI95BcqLAJGoB/YwvEBA1K4pGsqJr0NfuPQ==
-----END RSA PRIVATE KEY-----}
}
