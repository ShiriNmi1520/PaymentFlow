require 'uri'
class LinePay < ActiveRecord::Base
  validate :validate_currency, :validate_url
  attribute :amount, :integer, null: false
  attribute :currency, :string, null: false
  attribute :orderId, :string, null: false
  attribute :packages, :LinePayPackages, null: false
  attribute :redirectUrls, :object, null: false

  def validate_currency
    if currency not (Money::Currency.table.values.map {})
      errors.add(:currency, "INVALID_CURRENCY_PASSED")
    end
  end

  def validate_url
    if redirectUrls !=~ URI::regexp
      errors.add(:redirectUrls, "INVALID_REDIRECT_URL")
    end
  end
end

class LinePayPackages < ActiveRecord::Base

end
