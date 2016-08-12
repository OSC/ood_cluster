require 'ood_support'
module OodCluster
  module Validations
    # Class used to determine if user is in valid list of groups
    class Groups
      # @param groups [Array<#to_s>] list of groups
      # @param whitelist [Boolean] whether this is a whitelist
      def initialize(groups:, whitelist: true, **_)
        @groups = [*groups].map {|g| OodSupport::Group.new g.to_s}
        @whitelist = whitelist
      end

      # Whether user is in a valid group
      # @return [Boolean] whether in a valid group
      def valid?
        is_user_in_groups = !(@groups & OodSupport::User.new.groups).empty?
        @whitelist ? is_user_in_groups : !is_user_in_groups
      end
    end
  end
end
