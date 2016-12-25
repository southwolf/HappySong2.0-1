class AddArticleIdToDoWork < ActiveRecord::Migration[5.0]
  def change
    add_reference :do_works, :article
  end
end
