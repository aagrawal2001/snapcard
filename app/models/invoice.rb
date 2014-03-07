class Invoice < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :amount_usd

  validates :amount_usd, presence: true
  validates :amount_usd, numericality: { greater_than: 0 }
  validates :token, presence: true

  has_many :payments

  before_validation :create_token
  after_create :init_blockchain

  def create_token
    self.token = SecureRandom.hex(16)
  end

  def init_blockchain
    blockchain_address = ENV['BLOCKCHAIN_ADDRESS']
    callback_url = CGI::escape(payments_url(token: token))
    url = "https://blockchain.info/api/receive?method=create&address=#{blockchain_address}&callback=#{callback_url}"
    response = HTTParty.get(url)
    data = JSON.parse(response.body)
    self.blockchain_address = data["input_address"]
    save
  end

  def expired?
    (Time.now - created_at) > 15.minutes
  end

#   def init_coinbase

#     coinbase = Coinbase::Client.new(ENV['COINBASE_API_KEY'], ENV['COINBASE_API_SECRET'])
# #    options = { "custom_secure" => true, "callback_url" => payments_url  }
#     r = coinbase.create_button "Invoice #{token}", amount_usd.to_money('USD'), description, token
#     self.coinbase_button_code = r.button.code
#     save
#   end

  def find_by_token(token)
    where(token: token).first
  end

end
