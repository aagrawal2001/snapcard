class PaymentsController < ApplicationController
  def create
    @invoice = Invoice.find_by_token(params[:token])
    return if @invoice.expired?
    @invoice.payments.create!(params.slice(:value, :transaction_hash))
    render text: "*ok*"
  end

end
