# frozen_string_literal: true

module Service
  extend ActiveSupport::Concern

  SUCCESS = :success
  FAILURE = :failure

  def success **data
    data.merge result: SUCCESS
  end

  def failure **data
    data.merge result: FAILURE
  end

  def data_with_result is_successful, **data
    data.merge(result: is_successful ? SUCCESS : FAILURE)
  end

  module ClassMethods
    def call(*args, **named_args, &block)
      if named_args.any?
        service = new(*args, **named_args)
      else
        service = new(*args)
      end

      if 0 == ActiveRecord::Base.connection.open_transactions
        ApplicationRecord.transaction { service.call(&block) }
      else
        service.call(&block)
      end
    end
  end

  def self.success? data
    SUCCESS == data[:result]
  end

  def self.failure? data
    !success? data
  end

  def self.notice data
    data[:notice]
  end
end
