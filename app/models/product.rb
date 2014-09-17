class Product < ActiveRecord::Base
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item
  validates :title, :image_url, :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)\Z}i,
      message: 'must be a URL for GIF, JPG or PNG image.'
  }
  after_validation :enclose_with_paragraph

  def self.latest
    Product.order(:updated_at).last
  end



  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

  def enclose_with_paragraph
    tmp = "<p>" + self[:description].to_s + '<\p>'
    self[:description] = tmp.to_sym
  end

end
