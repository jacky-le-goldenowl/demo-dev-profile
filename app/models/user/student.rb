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
class User::Student < User
  attr_accessor :skip_send_email_welcome

  # constants
  PERMIT_PARAMS = %i[
    email
    password
    region_id
    name
    birthday
    address
    gender
    contact_number
    contact_email
    relation
    emergency_contact_name
    emergency_contact_number
    emergency_contact_relation
    guardian_name
    home_mobile
    medical_history
  ].freeze

  # associations
  has_many :course_students, foreign_key: 'user_id', dependent: :destroy
  has_many :courses, through: :course_students
  has_many :invoices, foreign_key: 'user_id', dependent: :destroy
  has_many :attendances, foreign_key: 'user_id', dependent: :destroy

  validates :name, :birthday, :address, :contact_email,
            :relation, :emergency_contact_name, :emergency_contact_number,
            :emergency_contact_relation, :guardian_name, :home_mobile,
            :medical_history, presence: true
end
