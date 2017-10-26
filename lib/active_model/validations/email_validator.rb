# -*- encoding: utf-8 -*-
require 'mail'
require 'validate_as_email/blacklisted_prefixes'

module ActiveModel
  module Validations
    class EmailValidator < EachValidator
      attr_reader :record, :attribute, :value, :email, :tree

      DEFAULT_ERROR = :invalid

      attr_accessor :default_error

      class << self
        @default_error = DEFAULT_ERROR
        attr_accessor :default_error
      end


      def validate_each(record, attribute, value)
        @record, @attribute, @value = record, attribute, value

        @email = Mail::Address.new(value)
        @tree  = email.__send__(:tree)

        if valid?
          add_error(:prefix) if prefix_blacklisted?
        else
          add_error
        end
      rescue Mail::Field::ParseError
        add_error
      end

      def default_error
        @default_error || self.class.default_error
      end

      private

      def valid?
        !!(
          domain_and_address_present? &&
          domain_has_more_than_one_atom? &&
          !domain_starts_with_dot? &&
          !email_has_consecutive_dots?
        )
      end

      def domain_and_address_present?
        email.domain && email.address == value
      end

      def domain_has_more_than_one_atom?
        tree.domain.dot_atom_text.elements.length > 1
      end

      def email_has_consecutive_dots?
        email.address.match(/[.]{2,}/)
      end

      def domain_starts_with_dot?
        email.domain.start_with?('.')
      end

      def add_error(error = default_error)
        if message = options[:message]
          record.errors[attribute] << message
        else
          record.errors.add(attribute, error)
        end
      end

      def prefix_blacklisted?
        ValidateAsEmail::BlacklistedPrefixes.list.include?(local_base.downcase)
      end

      def local_base
        local = email.local
        domain = email.domain
        separator = '+'

        if domain == 'gmail.com'
          # Gmail ignores periods. If they signed up with periods initially, this won’t catch it
          local = local.delete('.')
        end

        local.gsub(/#{Regexp.escape(separator)}.*/, '')
      end
    end

    module HelperMethods
      def validates_as_email(*attr_names)
        validates_with EmailValidator, _merge_attributes(attr_names)
      end
    end
  end
end
