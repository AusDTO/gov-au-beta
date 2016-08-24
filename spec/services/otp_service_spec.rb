require 'rails_helper'

RSpec.describe OtpService, type: :service do
  let!(:user) { Fabricate(:user) }

  subject { OtpService.new(user) }

  it {
    expect { subject.create_direct_otp!(:direct_otp) }.to change {
      User.find(user.id).direct_otp
    }
  }

  it {
    expect { subject.create_direct_otp!(:direct_otp) }.to change {
      User.find(user.id).direct_otp_sent_at
    }
  }

  # TODO: may wish to make this a shared_example and provide params for
  # both direct_otp and unconfirmed_phone_number_otp
  describe 'authenticate_otp' do
    before {
      user.direct_otp = '123456'
      user.save
    }

    context 'which is still valid' do
      before {
        user.direct_otp_sent_at = Time.now.utc
        user.save
      }

      it {
        expect { subject.authenticate_otp(:direct_otp, '123456') }.to change {
          User.find(user.id).direct_otp
        }.to(nil)
      }

      it { expect(subject.authenticate_otp(:direct_otp, '123456')).to eq(true) }
    end


    context 'which has expired' do
      before {
        user.direct_otp_sent_at = 10.minutes.ago
        user.save
      }

      it {
        expect { subject.authenticate_otp(:direct_otp, '123456') }.to_not change {
          User.find(user.id).direct_otp
        }
      }

      it { expect(subject.authenticate_otp(:direct_otp, '123456')).to eq(false) }
    end

    context 'which is incorrect' do
      before {
        user.direct_otp_sent_at = Time.now.utc
        user.save
      }

      it {
        expect { subject.authenticate_otp(:direct_otp, '654321') }.to_not change {
          User.find(user.id).direct_otp
        }
      }

      it { expect(subject.authenticate_otp(:direct_otp, '654321')).to eq(false) }
    end
  end


  describe 'otp_expired?' do
    context 'with a valid otp' do
      before {
        user.direct_otp = '123456'
        user.direct_otp_sent_at = Time.now.utc
        user.save
      }

      it { expect(subject.otp_expired?(:direct_otp)).to eq(false) }
    end

    context 'with an invalid otp' do
      before {
        user.direct_otp = '123456'
        user.direct_otp_sent_at = 10.minutes.ago
        user.save
      }

      it { expect(subject.otp_expired?(:direct_otp)).to eq(true) }
    end
  end


  describe 'clear_direct_otp' do
    before {
      user.direct_otp = '123456'
      user.direct_otp_sent_at = Time.now.utc
      user.save
    }

    it {
      expect { subject.clear_direct_otp(:direct_otp) }.to change {
        User.find(user.id).direct_otp
      }.from('123456').to(nil)
    }

    it {
      expect { subject.clear_direct_otp(:direct_otp) }.to change {
        User.find(user.id).direct_otp_sent_at
      }.to(nil)
    }
  end


  describe 'create_direct_otp!' do
    it {
      expect { subject.create_direct_otp!(:direct_otp) }.to change {
        User.find(user.id).direct_otp
      }
    }

    it {
      expect { subject.create_direct_otp!(:direct_otp) }.to change {
        User.find(user.id).direct_otp_sent_at
      }
    }
  end
end