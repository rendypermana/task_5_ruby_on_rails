class Comment < ActiveRecord::Base

belongs_to :article
belongs_to :user
 #has_many :families_homes
 #has_many :homes, through: :families_homes


        def default_status

            self.status = "active"

        end
end
