class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      redirect_to @invoice, notice: 'Invoice Created'
    else
      render :new
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
  end
end
