class InquiryMailer < ActionMailer::Base
  default from: '"Rekhyt事務局" <rekhyt.info@gmail.com>'   # 送信元アドレス
  default to: "rekhyt.info@gmail.com"     # 送信先アドレス

  def received_email(inquiry, user_id)
    @inquiry = inquiry
    @user_id = user_id
    mail(:subject => 'お問い合わせを承りました')
  end
end