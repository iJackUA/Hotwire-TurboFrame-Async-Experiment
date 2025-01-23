class TraditionalController < ApplicationController
  def index
  end

  def widget
    data = {hello: "world"}
    # simulate long response
    sleep 2
    render partial: "traditional/widget", locals: {id: params[:id], data: data}
  end
end
