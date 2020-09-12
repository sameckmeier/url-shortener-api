require 'rails_helper'

describe CreateUrl do
  let(:client) { double(:client, id: 'a1') }
  let(:url) { double(:url) }
  let(:url_params) { { original: Faker::Internet.url } }
  subject(:context) { CreateUrl.call(url_params: url_params, client: client) }

  describe :call do
    context 'when given valid params' do
      let(:shortened_url) { double(:shortened_url) }

      before do
        allow(url).to receive(:save).and_return(true)
        allow(Url).to receive(:new).and_return(url)
      end

      context 'and params do not include shortened' do
        before do
          allow(url).to receive(:shortened?).and_return(false)
          allow(shortened_url).to receive(:lock!).and_return(shortened_url)
          allow(ShortenedUrl).to receive(:current).and_return(shortened_url)
          expect_any_instance_of(CreateUrl).to receive(:set_shortened).with(url, shortened_url)
        end

        it 'succeeds' do
          expect(context).to be_a_success
        end

        it 'provides the url' do
          expect(context.url).to eq(url)
        end
      end

      context 'and params include shortened' do
        before do
          allow(url).to receive(:shortened?).and_return(true)
        end

        it 'succeeds' do
          expect(context).to be_a_success
        end

        it 'provides the url' do
          expect(context.url).to eq(url)
        end
      end
    end

    context 'when given invalid params' do
      let(:errors) { double(:errors) }

      before do
        allow(url).to receive(:shortened?).and_return(true)
        allow(url).to receive(:save).and_return(false)
        allow(url).to receive(:errors).and_return(errors)
        allow(errors).to receive(:full_messages).and_return(errors)
        allow(Url).to receive(:new).and_return(url)
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides a failure message' do
        expect(context.error).to be_present
      end
    end
  end
end
