class AsyncController < ApplicationController
  def index
    sleeptime1 = 1
    data1 = Concurrent::Promises.future {
      sleep sleeptime1
      {data1: "world1", sleeptime: sleeptime1}
    }

    sleeptime2 = 1
    data2 = Concurrent::Promises.future {
      sleep sleeptime2
      {data2: "world2", sleeptime: sleeptime2}
    }

    sleeptime3 = 3
    data3 = Concurrent::Promises.future {
      sleep sleeptime3
      {data3: "world3", sleeptime: sleeptime3}
    }

    sleeptime4 = 5
    data4 = Concurrent::Promises.future {
      sleep sleeptime4
      {data4: "world4", sleeptime: sleeptime4}
    }

    render :index, locals: {id: params[:id], data1:, data2:, data3:, data4:}
  end
end
