class OrderMailer < ApplicationMailer
  default from: 'yourapp@example.com'

  def user_confirmation(order)
    @order = order

    pdf = WickedPdf.new.pdf_from_string(
      ApplicationController.render(
        template: 'order_mailer/invoice',
        layout: 'pdf',
        locals: { order: @order }
      )
    )

    attachments["Invoice_#{@order.id}.pdf"] = pdf

    mail(to: @order.user.email, subject: 'Order Confirmation')
  end

  def seller_notification(order, seller)
    @order = order
    @seller = seller
    mail(to: @seller.email, subject: 'New Order Received')
  end
end
