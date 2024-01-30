class PagesController < ApplicationController
  def main_page
    # TODO include discount when calculating a remaining balance
    @buyers = Buyer.all.order(active: :desc)
    @providers = Provider.all.order(active: :desc)
    @delivery_from_counterparties =
      DeliveryFromCounterparty.where('created_at >= ?', DateTime.current.beginning_of_day)
                              .or(DeliveryFromCounterparty.unpaid)
                              .order(created_at: :desc)
    @expenditures = Expenditure.where('created_at >= ?', DateTime.current.beginning_of_day)
                               .or(Expenditure.unpaid).order(created_at: :desc)
    @sales = Sale.where('created_at >= ?', DateTime.current.beginning_of_day)
                 .or(Sale.unpaid).order(created_at: :desc)

    unless params.dig(:q, :created_at_end_of_day_lteq)
      params[:q] ||= {}
      params[:q][:created_at_end_of_day_lteq] = DateTime.current.end_of_day
    end
    unless params.dig(:q, :created_at_gteq)
      params[:q] ||= {}
      params[:q][:created_at_gteq] = DateTime.current.beginning_of_day
    end

    @q = TransactionHistory.ransack(params[:q])
    sales = Sale.where('created_at >= ?', params[:q][:created_at_gteq])
                .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
    @sales_in_usd = sales.price_in_usd
    @sales_in_uzs = sales.price_in_uzs

    delivery_from_counterparties =
      DeliveryFromCounterparty.where('created_at >= ?', params[:q][:created_at_gteq])
                              .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
    @delivery_from_counterparties_in_usd = delivery_from_counterparties.price_in_usd
    @delivery_from_counterparties_in_uzs = delivery_from_counterparties.price_in_uzs

    expenditures =
      Expenditure.where('created_at >= ?', params[:q][:created_at_gteq])
                 .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
    @expenditures_in_usd = expenditures.price_in_usd
    @expenditures_in_uzs = expenditures.price_in_uzs

    @total_salary = Salary.where('created_at >= ?', params[:q][:created_at_gteq])
                          .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
  end

  def define_sale_destination; end

  def shortcuts; end

  def daily_report
    DailyReport.run
    respond_to do |format|
      format.json { render json: {success: true}, status: :ok }
      format.html { redirect_to request.referrer || root_path }
    end
  end

  def admin_page
    authorize PagesController, :access?

    @q = DeliveryFromCounterparty.ransack(params[:q])
    @delivery_from_counterparties = @q.result

    # overall_info
    transaction_histories = TransactionHistory.ransack(params[:q]).result
    profit_from_sale = transaction_histories.where.not(sale_id: nil)

    @sales_in_uzs = profit_from_sale.price_in_uzs.sum(:price)

    @profit_from_sale_in_uzs = profit_from_sale.price_in_uzs.sum(:estimated_profit)

    delivery_from_counterparties = transaction_histories.where.not(delivery_from_counterparty_id: nil)
    @delivery_from_counterparties_in_uzs = delivery_from_counterparties.price_in_uzs.sum(:price)

    expenditures = transaction_histories.where.not(expenditure_id: nil)
    @expenditures_in_uzs = expenditures.price_in_uzs.sum(:price)
    @total_income = (@sales_in_uzs.to_f - (@delivery_from_counterparties_in_uzs.to_f + @salaries.to_f + @prepayment.to_f + @expenditures_in_uzs.to_f))

    salaries = Salary.ransack(params[:q]).result
    @prepayment = salaries.where(prepayment: true).sum(:price)
    @salaries = salaries.where(prepayment: false).sum(:price)
  end
end
