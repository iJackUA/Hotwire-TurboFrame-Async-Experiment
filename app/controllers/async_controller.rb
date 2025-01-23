class AsyncController < ApplicationController
  def index
    data1 = Concurrent::Promises.future {
      sleep 1
      {data1: "world1"}
    }
    data2 = Concurrent::Promises.future {
      sleep 1
      {data2: "world2"}
    }
    data3 = Concurrent::Promises.future {
      sleep 3
      {data3: "world3"}
    }
    data4 = Concurrent::Promises.future {
      sleep 5
      {data4: "world4"}
    }

    render :index, locals: {id: params[:id], data1:, data2:, data3:, data4:}
  end

  def widget
    data = {hello: "world"}
    # simulate long response
    sleep 2
    render partial: "traditional/widget", locals: {id: params[:id], data: data}
  end
end
