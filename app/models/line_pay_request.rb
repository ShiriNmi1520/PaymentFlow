# frozen_string_literal: true

require 'uri'

# Model for request payment
class LinePay < ActiveRecord::Base
  validate :validate_currency
  validates_length_of :orderId, maximum: 100, too_long: 'ORDER_ID_TOO_LONG'

  attribute :amount, :integer, null: false
  attribute :currency, :string, null: false
  attribute :orderId, :string, null: false
  attribute :packages, :LinePayPackages, null: false
  attribute :redirectUrls, :LinePayRedirectUrls, null: false

  def validate_currency
    currency = Money::Currency.table.values.map []
    errors.add(:currency, 'INVALID_CURRENCY_PASSED') if currency.exclude(:currency)
  end
end

# Model for packages in request body (Item name, price, etc.)
class LinePayPackages < ActiveRecord::Base
  validates_length_of :packageId, maximum: 50, too_long: 'PACKAGE_ID_TOO_LONG'
  validates_length_of :packageName, maximum: 100, too_long: 'PACKAGE_NAME_TOO_LONG'

  attribute :packageId, :string, null: false
  attribute :packageAmount, :integer, null: false
  attribute :userFee, :integer
  attribute :packageName, :string
  attribute :products, :LinePayPackagesProduct, null: false
end

class LinePayPackagesProduct < ActiveRecord::Base
  attribute :productName, :string, null: false
  attribute :productImageUrl, :string
  attribute :productQuantity, :integer, null: false
  attribute :productPrice, :integer, null: false
  attribute :productOriginalPrice, :integer
end

# Model for redirect urls in request body (Confirm, cancel)
class LinePayRedirectUrls < ActiveRecord::Base
  validate :validate_url

  attribute :appPackageName, :string # For Android environment
  attribute :confirmUrl, :string, null: false
  attribute :confirmUrlType, :string
  attribute :cancelUrl, :string, null: false
  def validate_url
    errors.add(:confirmUrl, 'INVALID_REDIRECT_URL') if confirmUrl != ~ URI::DEFAULT_PARSER.make_regexp
    errors.add(:cancelUrl, 'INVALID_CANCEL_URL') if cancelUrl != ~ URI::DEFAULT_PARSER.make_regexp
  end
end
