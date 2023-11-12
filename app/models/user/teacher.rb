# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  access_token               :string
#  address                    :string
#  birthday                   :date
#  citizenship                :string
#  code                       :string
#  contact_email              :string
#  contact_number             :string
#  email                      :string           default(""), not null
#  emergency_contact_name     :string
#  emergency_contact_number   :string
#  emergency_contact_relation :string
#  encrypted_password         :string           default(""), not null
#  gender                     :string
#  guardian_name              :string
#  home_mobile                :string
#  identification_number      :string
#  marital_status             :string
#  medical_history            :text
#  name                       :string
#  phone_number               :string
#  qualification              :string
#  race                       :string
#  relation                   :string
#  religion                   :string
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  type                       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  region_id                  :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User::Teacher < User
  PERMIT_PARAMS = %i[
    email
    password
    region_id
    name
    birthday
    address
    gender
    phone_number
    contact_email
    citizenship
    identification_number
    marital_status
    qualification
    race
    religion
  ].freeze

  has_one :bank_info, foreign_key: 'user_id', inverse_of: :user, dependent: :destroy
  has_many :payslips, foreign_key: 'user_id', dependent: :destroy
  has_many :courses, foreign_key: 'user_id', dependent: :destroy

  validates :name, :birthday, :address, :phone_number, :contact_email,
            :religion, :race, :citizenship, :identification_number,
            :marital_status, :phone_number, :qualification, presence: true

  accepts_nested_attributes_for :bank_info
end
