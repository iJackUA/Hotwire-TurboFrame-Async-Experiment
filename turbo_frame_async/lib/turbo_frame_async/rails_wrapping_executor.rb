# frozen_string_literal: true

require "concurrent-edge"

#
# A custom wrapper for Concurrent::WrappingExecutor that automatically wraps
# tasks in the Rails executor context.
#
# This ensures that any task posted to the executor is executed within the
# Rails context, preserving things like ActiveRecord connections and other
# thread-local state that Rails manages.
#
module RailsWrappingExecutor
  module_function

  def new(executor)
    Concurrent::WrappingExecutor.new(executor) do |*args, &task|
      [*args, ->(*task_args) { Rails.application.executor.wrap { task.call(*task_args) } }]
    end
  end
end
