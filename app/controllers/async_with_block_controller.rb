class AsyncWithBlockController < ApplicationController
  include TurboFrameAsync::Helper

  def index
    sleeptime1 = 1

    data1 = async_execute {
      sleep sleeptime1
      {data1: "world1", sleeptime: sleeptime1}
     }

    sleeptime2 = 1
    data2 = async_execute {
      sleep sleeptime2
      {data3: "world2", sleeptime: sleeptime2}
    }

    sleeptime3 = 3
    data3 = async_execute do
      sleep sleeptime3
      # TODO: Need to figure oute why error is not tracked
      raise StandardError.new("Custom error message")
      {data3: "world3", sleeptime: sleeptime3}
    end

    sleeptime4 = 5
    data4 = Concurrent::Promises.future {
      sleep sleeptime4
      {data4: "world4", sleeptime: sleeptime4}
    }

    render :index, locals: {id: params[:id], data1:, data2:, data3:, data4:}
  end
end
