class Invoice < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :amount_usd

  validates :amount_usd, presence: true
  validates :amount_usd, numericality: { greater_than: 0 }
  validates :token, presence: true

  before_validation :create_token
  after_create :init_coinbase

  def create_token
    self.token = SecureRandom.hex(16)
  end

  def init_coinbase
    coinbase = Coinbase::Client.new(ENV['COINBASE_API_KEY'], ENV['COINBASE_API_SECRET'])
#    options = { "custom_secure" => true, "callback_url" => payments_url  }
    r = coinbase.create_button "Invoice #{token}", amount_usd.to_money('USD'), description, token
    self.coinbase_button_code = r.button.code
    save
  end

  def find_by_token(token)
    where(token: token).first
  end

end
