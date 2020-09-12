require 'rails_helper'

describe CreateClient do
  let(:client) { double(:client, id: '1') }
  subject(:context) { CreateClient.call }

  describe :call do
    before { allow(Client).to receive(:new).and_return(client) }

    context 'when create succeeds' do
      before { allow(client).to receive(:save).and_return(true) }

      it 'succeeds' do
        expect(context).to be_a_success
      end
    end

    context 'when create fails' do
      let(:errors) { double(:errors) }

      before do
        allow(client).to receive(:save).and_return(false)
        allow(client).to receive(:errors).and_return(errors)
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
