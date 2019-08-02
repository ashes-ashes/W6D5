# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ApplicationRecord
  COLORS = ['white',
  'orange',
  'cinnamon',
  'blue',
  'silver',
  'black',
  'tortoiseshell',
  'calico',
  'chocolate',
  'chocolate tabby',
  'grey tabby']

  SEXES = ["M", "F"]


  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: {in: COLORS}
  validates :sex, inclusion: {in: SEXES}
  validate :age

  has_many :rental_requests,
    foreign_key: :cat_id,
    class_name: 'CatRentalRequest',
    dependent: :destroy

  def age
    return nil unless birth_date 
    now = Date.today
    age = now.year - birth_date.year
    if birth_date.month - now.month > 0
      age -= 1
    elsif birth_date.month == now.month && birth_date.day - now.day > 0
      age -= 1
    end
    age
  end

  def self.colors
    COLORS
  end
  def self.sexes
    SEXES
  end


end
