class InquiryController < ApplicationController
  def index
    # 入力画面を表示
    @inquiry = Inquiry.new
    render :action => 'index'
  end

  def thanks
    #set_meta_tags canonical: "http://ticket-finder.jp/inquiry"
    # メール送信
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.valid?
      render :action => 'thanks'
    else
      render :action => 'index'
    end

    @user_id = current_user.try(:id)
    InquiryMailer.received_email(@inquiry, @user_id).deliver
  end

  private
  def inquiry_params
   params.require(:inquiry).permit(:message)
  end
end