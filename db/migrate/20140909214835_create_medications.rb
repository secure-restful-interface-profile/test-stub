class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.string :name
      t.string :system
      t.string :code
      t.string :text
      t.boolean :is_brand
      t.string :manufacturer_reference
      t.string :manufacturer_text
      t.string :kind
      t.string :product_form_system
      t.string :product_form_code
      t.string :product_form_text
      t.string :product_ingredient_item_reference
      t.string :product_ingredient_item_text
      t.string :package_container_system
      t.string :package_container_code
      t.string :package_container_text
      t.string :package_content_item_reference
      t.string :package_content_item_text
      t.string :package_content_amount_value
      t.string :package_content_units
      t.string :package_content_system
      t.string :package_content_code

      t.timestamps
    end
  end
end
