class InquiryMailer < ActionMailer::Base
  default from: '"OTOLOG事務局" <otolog.officail@gmail.com>'   # 送信元アドレス
  default to: "otolog.officail@gmail.com"     # 送信先アドレス

  def received_email(inquiry, user_id)
    @inquiry = inquiry
    @user_id = user_id
    mail(:subject => 'お問い合わせを承りました')
  end
end