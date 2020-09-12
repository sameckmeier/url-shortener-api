require 'rails_helper'

describe DestroyUrl do
  let(:url) { double(:url) }
  subject(:context) { DestroyUrl.call(url: url) }

  describe :call do
    context 'when destroy is successful' do
      before { allow(url).to receive(:destroy).and_return(true) }

      it 'succeeds' do
        expect(context).to be_a_success
      end
    end

    context 'when destroy is unsuccessful' do
      let(:errors) { double(:errors) }

      before do
        allow(url).to receive(:destroy).and_return(false)
        allow(url).to receive(:errors).and_return(errors)
        allow(errors).to receive(:full_messages).and_return(errors)
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
