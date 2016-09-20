class Inquiry
  include ActiveModel::Model
  attr_accessor :message
  attr_accessor :user_id

  validates :message, :presence => {:message => 'お問い合わせ内容を入力してください'}
end