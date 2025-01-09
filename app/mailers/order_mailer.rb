class OrderMailer < ApplicationMailer
  default from: 'yourapp@example.com'

  def user_confirmation(order)
    @order = order

    # Generate PDF
    pdf = WickedPdf.new.pdf_from_string(
      ApplicationController.render(
        template: 'orders/invoice',
        layout: 'pdf', # Ensure the PDF layout is used
        locals: { order: @order } # Pass necessary variables to the template
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
