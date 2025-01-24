class TraditionalController < ApplicationController
  def index
  end

  def widget
    sleeptime = params[:sleep]&.to_i || 2
    data = {sleeptime: sleeptime}
    # simulate long response
    sleep sleeptime
    render partial: "traditional/widget", locals: {id: params[:id], data: data}
  end
end
