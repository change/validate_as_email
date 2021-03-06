require 'spec_helper'

describe ActiveModel::Validations::EmailValidator do
  let(:person) { Person.new(email: 'invalid_format') }

  let(:options) { {attributes: [:email]} }

  def build_validator(options = {})
    ActiveModel::Validations::EmailValidator.new(
      options.merge(attributes: [:email])
    )
  end

  subject(:validator) { build_validator }

  describe '#validate' do
    context 'with a valid email address' do
      before do
        person.email = 'james@logi.cl'
      end

      it 'does not add errors' do
        validator.validate(person)
        expect(person.errors.to_a).to be_empty
      end
    end

    context 'with nil allowed' do
      subject(:validator) do
        build_validator(allow_nil: true)
      end

      before do
        person.email = nil
      end

      it 'skips adding errors is email is nil' do
        validator.validate(person)
        expect(person.errors.to_a).to be_empty
      end
    end

    context 'with blank is allowed' do
      subject(:validator) do
        build_validator(allow_blank: true)
      end

      before do
        person.email = '  '
      end

      it 'skips adding errors is email is nil' do
        validator.validate(person)
        expect(person.errors.to_a).to be_empty
      end
    end

    context 'with no message provided' do
      it 'adds a symbol to errors for I18n lookup' do
        validator.validate(person)
        expect(person.errors.to_a).to match_array ['Email is invalid']
      end
    end

    context 'with a specific error message provided' do
      subject(:validator) do
        build_validator(message: 'is kinda odd looking')
      end

      it 'uses the message you specify' do
        validator.validate(person)
        expect(person.errors.to_a).to match_array ['Email is kinda odd looking']
      end
    end

    context 'when raising Mail::Field::ParseError' do
      it 'adds invalid message error' do
        described_class.any_instance.stub(:valid?).and_raise(Mail::Field::ParseError.new(Mail::AddressList, "", nil))
        validator.validate(person)
        expect(person.errors.to_a).to match_array ['Email is invalid']
      end
    end

    context 'when email prefix is blocklisted' do
      before do
        person.email = 'help@logi.cl'
      end

      it 'adds a symbol to errors for I18n lookup' do
        validator.validate(person)
        expect(person.errors.to_a).to be_present
      end
    end

    context 'when blocklisted email prefix uses an extension' do
      before do
        person.email = 'help+testing@logi.cl'
      end

      it 'adds a symbol to errors for I18n lookup' do
        validator.validate(person)
        expect(person.errors.to_a).to be_present
      end
    end

    context 'when email prefix is blocklisted - case insensitive' do
      before do
        person.email = 'HELP@logi.cl'
      end

      it 'adds a symbol to errors for I18n lookup' do
        validator.validate(person)
        expect(person.errors.to_a).to be_present
      end
    end

    context 'when email has two consecutive dots in the domain' do
      before do
        person.email = 'dwight@change..org'
      end

      it 'adds a symbol to errors for I18n lookup' do
        validator.validate(person)
        expect(person.errors.to_a).to be_present
      end
    end

    context 'when email has two consecutive dots in the address' do
      before do
        person.email = 'dwight..schrute@change.org'
      end

      it 'adds a symbol to errors for I18n lookup' do
        validator.validate(person)
        expect(person.errors.to_a).to be_present
      end
    end

    context 'when email has a domain starting with a dot' do
      before do
        person.email = 'ola2122008@.ru'
      end

      it 'adds a symbol to errors for I18n lookup' do
        validator.validate(person)
        expect(person.errors.to_a).to be_present
      end
    end
  end
end
